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
      version = "11.7.0";
      srcHash = "sha256-oH9bLN2BPvRSWl5m3VNHBNMBXfdmkwaE9tzL7pcD1mg=";
      vendorHash = "sha256-PmwwiXNaDarc1H7z1G4zstgs7tvmZ/d7V5eGqMh1VX4=";
      npmDepsHash = "sha256-C3vfWW2hMOMnrPn1538kT+ma09T9VswrmADV/KPkrPc=";
      autoUpdate = ./package.nix;
    };
  }
  // args
)
