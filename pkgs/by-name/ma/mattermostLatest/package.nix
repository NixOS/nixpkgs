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
      version = "11.7.1";
      srcHash = "sha256-9eI9tX6qHEEzm7aro7ky2JORfAmqbjmrmxABFVTZzW8=";
      vendorHash = "sha256-xu399pAtIJUIns+GhKFlDR0crWV+8HiN9Wf38EMu5q8=";
      npmDepsHash = "sha256-M+yoCLR4yT30n3rhqZu1z8zeWas+5VniP4aaIJPz6VU=";
      autoUpdate = ./package.nix;
    };
  }
  // args
)
