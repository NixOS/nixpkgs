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
    version = "11.2.4";
    srcHash = "sha256-T3dESgTpp5TJx+gY5lDV/L1aBuWAA2hlF8DTczWMdB0=";
    vendorHash = "sha256-7BXDp9R/Ivgxp1nbpOt1i8h2h4XzKLJnbbnsKc1+UKI=";
    npmDepsHash = "sha256-YuJ0IfvhWb6kzBoTMYWV3mUhMuhrAelKoyXlmnQJovo=";
    lockfileOverlay = ''
      unlock(.; "@floating-ui/react"; "channels/node_modules/@floating-ui/react")
    '';
    autoUpdate = ./package.nix;
  };
}
