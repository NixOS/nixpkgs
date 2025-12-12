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
    version = "11.1.1";
    srcHash = "sha256-8JpAdjQbIoam0q9XR93YqRLbHGBpRKuHPUOb9+cKqZk=";
    vendorHash = "sha256-yI+8GAwCZjZxDiYEALKDCYAWbGE7/zCFTBkPj4RmHJk=";
    npmDepsHash = "sha256-5OgWhootvh4r7nyuELAfBL8tvmJrkUCblT8IRtd6kXM=";
    lockfileOverlay = ''
      unlock(.; "@floating-ui/react"; "channels/node_modules/@floating-ui/react")
    '';
    autoUpdate = ./package.nix;
  };
}
