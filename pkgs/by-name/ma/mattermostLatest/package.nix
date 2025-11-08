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
    version = "11.0.4";
    srcHash = "sha256-odBY/TVvED7h7+u+5nSRng4rRnjt1eee7fUWjxqnAJ4=";
    vendorHash = "sha256-QlBq8YlphD2YuOrdnhW8g5XXeMkESVDRvKg6i5MGA0k=";
    npmDepsHash = "sha256-YU6FDsMX0QIGFatUDRos/AkgwljIBeI5w/TJt/lglw0=";
    lockfileOverlay = ''
      unlock(.; "@floating-ui/react"; "channels/node_modules/@floating-ui/react")
    '';
    autoUpdate = ./package.nix;
  };
}
