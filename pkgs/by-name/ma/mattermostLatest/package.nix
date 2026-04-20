{
  mattermost,
  ...
}@args:

mattermost.override (
  {
    versionInfo = {
      # Latest, non-RC releases only.
      # If the latest is an ESR (Extended Support Release),
      # duplicate it here to facilitate the update script.
      # See https://docs.mattermost.com/about/mattermost-server-releases.html
      # and make sure the version regex is up to date here.
      # Ensure you also check ../mattermost/package.nix for ESR releases.
      regex = "^v(11\\.[0-9]+\\.[0-9]+)$";
      version = "11.5.1";
      srcHash = "sha256-3ij6JYGectkAYc2z6caD3L0NUP1UJJ6QaR2qLcTWXoI=";
      vendorHash = "sha256-ao8jWfrzMTs9JJokaGH0kuoZ0d3VnIDGc5uDN2hCrhk=";
      npmDepsHash = "sha256-r7iq1pCAJjFyspZBdeNWe00W7A3l73PGC6rrsZ7O6Uw=";
      lockfileOverlay = ''
        unlock(.; "@floating-ui/react"; "channels/node_modules/@floating-ui/react")
      '';
      autoUpdate = ./package.nix;
    };
  }
  // args
)
