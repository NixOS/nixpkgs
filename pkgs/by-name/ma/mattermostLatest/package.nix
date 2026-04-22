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
      version = "11.5.3";
      srcHash = "sha256-r7rfiQ4C0E511QWdpQihydsuoRZCzboodmh1iT4a8r4=";
      vendorHash = "sha256-/ts6j86tvbYFjVACkJwcSnXDd+8BXzpaFVdV9DRHkqY=";
      npmDepsHash = "sha256-r7iq1pCAJjFyspZBdeNWe00W7A3l73PGC6rrsZ7O6Uw=";
      lockfileOverlay = ''
        unlock(.; "@floating-ui/react"; "channels/node_modules/@floating-ui/react")
      '';
      autoUpdate = ./package.nix;
    };
  }
  // args
)
