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
    version = "10.6.5";
    srcHash = "sha256-rka1wN4MTvbggm+Wzsrc/xDiFT/pf0UQbNjJ0KI4tvs=";
    vendorHash = "sha256-HFwA1t1FZJ/naRUqep6Z4Vl06r7T+8MDEcDJZLkkF4Y=";
    npmDepsHash = "sha256-MdLfjLmizFbLfSqOdAZ+euXomB2ZPjZOqspQYnyHcuk=";
    lockfileOverlay = ''
      unlock(.; "@floating-ui/react"; "channels/node_modules/@floating-ui/react")
    '';
    autoUpdate = ./package.nix;
  };
}
