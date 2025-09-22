{
  mattermost,
}:

mattermost.override {
  versionInfo = {
    # Latest, non-RC releases only.
    # If the latest is an ESR (Extended Support Release),
    # duplicate it here to facilitate the update script.
    # See https://docs.mattermost.com/about/mattermost-server-releases.html
    # and make sure the version regex is up to date here.
    # Ensure you also check ../mattermost/package.nix for ESR releases.
    regex = "^v(10\\.[0-9]+\\.[0-9]+)$";
    version = "10.12.0";
    srcHash = "sha256-oVZlXprw0NddHrtx1g2WRoGm1ATq/pqncD0mewN12nw=";
    vendorHash = "sha256-Lqa463LLy41aaRbrtJFclfOj55vLjK4pWFAFLzX3TJE=";
    npmDepsHash = "sha256-O9iX6hnwkEHK0kkHqWD6RYXqoSEW6zs+utiYHnt54JY=";
    lockfileOverlay = ''
      unlock(.; "@floating-ui/react"; "channels/node_modules/@floating-ui/react")
    '';
    autoUpdate = ./package.nix;
  };
}
