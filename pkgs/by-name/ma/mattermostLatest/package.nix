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
    version = "11.0.5";
    srcHash = "sha256-rycML/NL/0fA1OEdE8krHPo5+3DxSaQWoEV4UDfRK5E=";
    vendorHash = "sha256-QlBq8YlphD2YuOrdnhW8g5XXeMkESVDRvKg6i5MGA0k=";
    npmDepsHash = "sha256-F0LzT1Ko95Zm3BZu5/P/Tz1dkd+l3FWNtFw+p0NQ5Xw=";
    lockfileOverlay = ''
      unlock(.; "@floating-ui/react"; "channels/node_modules/@floating-ui/react")
    '';
    autoUpdate = ./package.nix;
  };
}
