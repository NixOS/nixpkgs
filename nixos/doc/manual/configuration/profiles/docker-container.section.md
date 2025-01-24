# Docker Container {#sec-profile-docker-container}

This is the profile from which the Docker images are generated. It prepares a
working system by importing the [Minimal](#sec-profile-minimal) and
[Clone Config](#sec-profile-clone-config) profiles, and
setting appropriate configuration options that are useful inside a container
context, like [](#opt-boot.isContainer).
