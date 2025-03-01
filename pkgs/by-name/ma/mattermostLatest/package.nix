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
    version = "10.5.0";
    srcHash = "sha256-xPEtgY/bGZAB0JodLHbbmZcdm5M0BFAIG2oXLIjQqog=";
    vendorHash = "sha256-AcemUxcBoytE/ZoXqaIlxkzAnmGV/C1laDqziMuE+XE=";
    npmDepsHash = "sha256-Fxm9OX5kFNL9NE5BBPUy0bfvZ0Aj46B80wemaMcA2J0=";
    lockfileOverlay = ''
      unlock(.; "@floating-ui/react"; "channels/node_modules/@floating-ui/react")
    '';
    autoUpdate = ./package.nix;
  };
}
