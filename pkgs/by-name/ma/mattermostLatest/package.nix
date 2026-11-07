{
  mattermost,
  ...
}@args:

mattermost.override (
  {
    latestVersionInfo = {
      # Latest, non-RC releases only.
      # If the latest is an ESR (Extended Support Release),
      # duplicate it here to facilitate the update script.
      # Note that the Mattermost package will prefer whichever is later of this one
      # or itself, in case the update script is lagging on one set of hashes.
      # See https://docs.mattermost.com/about/mattermost-server-releases.html
      # and make sure the version regex is up to date here.
      # Ensure you also check ../mattermost/package.nix for ESR releases.
      regex = "^v(12\\.[0-9]+\\.[0-9]+)$";
      version = "12.0.2";
      srcHash = "sha256-4Bp9mTEBSnQ5wQsFlme+EPAxgFAKaSVm8pxbC9B8rXc=";
      vendorHash = "sha256-wN2n/dwWkvz4R0KH/ElqfjHadCtDhHt8e4xgWTRnC3k=";
      npmDepsHash = "sha256-hx1vW5dovxidAgxQv1vqkR/tQHLzqs7uMxYbB+6w2g8=";
      autoUpdate = ./package.nix;
    };
  }
  // args
)
