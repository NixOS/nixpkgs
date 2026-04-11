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
      version = "11.4.3";
      srcHash = "sha256-XlkPGD86i5wN1cY1pM4mvwkUQCAtd3HzyiEhCm5blwc=";
      vendorHash = "sha256-sufyiIvtdnRLBTh0/FOp1J4ZjRVTjZBcCy40QtVfeQc=";
      npmDepsHash = "sha256-MrFV87WslmFxil9zW5JmoT5psM0GAJvmDK3WfkxpoUo=";
      lockfileOverlay = ''
        unlock(.; "@floating-ui/react"; "channels/node_modules/@floating-ui/react")
      '';
      autoUpdate = ./package.nix;
    };
  }
  // args
)
