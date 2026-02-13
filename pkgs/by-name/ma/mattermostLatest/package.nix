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
    version = "11.3.1";
    srcHash = "sha256-04Ozgd0egsLEuJtCWthdgyy/ircAIBS34L/az9q9CtM=";
    vendorHash = "sha256-5ukIxeMiWuFwhD2iIaFpPynm6t7MI0rI5b1uROs1FdQ=";
    npmDepsHash = "sha256-w54D5HMLW5wP6ercgWXv3Hb7Ayrj3M1SvNoUu1aU2Bk=";
    lockfileOverlay = ''
      unlock(.; "@floating-ui/react"; "channels/node_modules/@floating-ui/react")
    '';
    autoUpdate = ./package.nix;
  };
}
