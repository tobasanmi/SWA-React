# Stage 1: Build the React app
FROM node:16-slim AS build
WORKDIR /app

# Copy only package.json and package-lock.json
COPY package*.json ./

# Install only production dependencies
RUN npm ci --only=production

# Copy the rest of the application code
COPY . .

# Build the app
RUN npm run build && rm -rf /tmp/* && rm -rf node_modules/.cache

# Stage 2: Serve the app with Nginx
FROM nginx:alpine

# Remove default Nginx content
RUN rm -rf /usr/share/nginx/html/*

# Copy the built React app from the previous stage
COPY --from=build /app/build /usr/share/nginx/html

# Remove any unnecessary caches or tmp files
RUN rm -rf /var/cache/apk/*

# Expose port 80
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]

