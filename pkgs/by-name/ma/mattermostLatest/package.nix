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
      regex = "^v(11\\.[0-9]+\\.[0-9]+)$";
      version = "11.11.3";
      srcHash = "sha256-OAo4ghcio/gAscHm33TwK3a2wk5BM4uLTbSZT7LiN3k=";
      vendorHash = "sha256-/ffib81EbvQmgsRXEBKb9agZl4HyEPgaBnrEgn/zJc0=";
      npmDepsHash = "sha256-GTj6kRH5nT80JpVCLQJSKE7ef8ct17jjeWC6Sexw/1w=";
      autoUpdate = ./package.nix;
    };
  }
  // args
)
