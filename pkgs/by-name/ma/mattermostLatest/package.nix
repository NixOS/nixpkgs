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
    regex = "^v(11\\.[0-9]+\\.[0-9]+)$";
    version = "11.2.0";
    srcHash = "sha256-XVv0cmKkfA5MyZr/VuS7tGEteoSzhaKWq0Ae05jkRiQ=";
    vendorHash = "sha256-mvQivHijLEdfTk7QzlfWQQn9S/9lMfrI+jSKKz0bh3M=";
    npmDepsHash = "sha256-YuJ0IfvhWb6kzBoTMYWV3mUhMuhrAelKoyXlmnQJovo=";
    lockfileOverlay = ''
      unlock(.; "@floating-ui/react"; "channels/node_modules/@floating-ui/react")
    '';
    autoUpdate = ./package.nix;
  };
}
