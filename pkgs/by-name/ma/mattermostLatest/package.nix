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
    version = "10.9.0";
    srcHash = "sha256-4AnWjWg+Aak/+Kv4AWPa7ao1h/2Lqr9TEWPUmnlqxe4=";
    vendorHash = "sha256-c5qwJ2q4C1vI6WfTz/rj0gtS7FcY5PPkr6KUXiKxnXg=";
    npmDepsHash = "sha256-uAB599r3ZWjnt+jwk7sjSiPsc/tUyiBZzGqLZxuU3xE=";
    lockfileOverlay = ''
      unlock(.; "@floating-ui/react"; "channels/node_modules/@floating-ui/react")
    '';
    autoUpdate = ./package.nix;
  };
}
