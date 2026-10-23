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
      version = "11.11.1";
      srcHash = "sha256-kbupWQe7pN9D01gpPcuc6sPfElcQZMZ39JClHqoaNG0=";
      vendorHash = "sha256-qSU9pRoyv1c50+hc1a9qSAu7BOKGkRSuyn+G1PbNkmw=";
      npmDepsHash = "sha256-dB1+Idlnn+A/OIDPZtz8LlNyZM4K4AT20Ul/ndZcvL0=";
      autoUpdate = ./package.nix;
    };
  }
  // args
)
