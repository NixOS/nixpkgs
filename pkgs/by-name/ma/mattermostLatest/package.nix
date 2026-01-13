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
    version = "11.3.0";
    srcHash = "sha256-D5LR3kk9HO8vuvykCgaV5k5Y/M7t63afxXj1iUBS1j8=";
    vendorHash = "sha256-3Ic8ogcLLzcFOmBzhFnsh16hVvhyIsfDeNgZevQlL9A=";
    npmDepsHash = "sha256-w54D5HMLW5wP6ercgWXv3Hb7Ayrj3M1SvNoUu1aU2Bk=";
    lockfileOverlay = ''
      unlock(.; "@floating-ui/react"; "channels/node_modules/@floating-ui/react")
    '';
    autoUpdate = ./package.nix;
  };
}
