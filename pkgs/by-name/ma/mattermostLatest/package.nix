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
      version = "11.11.0";
      srcHash = "sha256-QB7C3TCmrUgTUST6hUEIM143cUfiORyaYnP6I2t37b8=";
      vendorHash = "sha256-FNZ6030d8Tro06ZlycN9lU9gd+7oxfuFciJOeLv+enQ=";
      npmDepsHash = "sha256-5Bl+enzE3i8GBPjTtudvrOM9DjfNHL3CkMbNMXSH4AU=";
      autoUpdate = ./package.nix;
    };
  }
  // args
)
