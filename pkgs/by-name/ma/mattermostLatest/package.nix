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
    version = "10.6.0";
    srcHash = "sha256-GnXxhhbOKJezUAyKRBbn5IE22gzsn80mwnPANOT9Qu4=";
    vendorHash = "sha256-wj+bAQNJSs9m2SSfl+Ipm965iAhKQ2v1iMjH7I79qf4=";
    npmDepsHash = "sha256-MdLfjLmizFbLfSqOdAZ+euXomB2ZPjZOqspQYnyHcuk=";
    lockfileOverlay = ''
      unlock(.; "@floating-ui/react"; "channels/node_modules/@floating-ui/react")
    '';
    autoUpdate = ./package.nix;
  };
}
