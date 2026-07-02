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
      version = "11.8.1";
      srcHash = "sha256-9EIbTwnEeZQKg5uixkMp3sp/n+9I2N9W7hxsW5juF3M=";
      vendorHash = "sha256-F2QMrLbio7812ZTGQZZPTqHWtIXbwbDmjUhtvv0DJ9s=";
      npmDepsHash = "sha256-9GRM0VXrh1eR16ocSGEV/F2eflOflzkhrhRRnm9uB6s=";
      autoUpdate = ./package.nix;
    };
  }
  // args
)
