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
      regex = "^v(12\\.[0-9]+\\.[0-9]+)$";
      version = "12.0.1";
      srcHash = "sha256-369VbCXv0tB3PYDuPrGEBRj40eZfMaPg8iWQ5JcwpLA=";
      vendorHash = "sha256-1cBMtVPS4JMxQsF7vDNRY+eR6A75LIf//JNYYwfACJ8=";
      npmDepsHash = "sha256-n31nZ36c6RCp3c8lajjrHYEppnUU65DtpTwI6KCPSUc=";
      autoUpdate = ./package.nix;
    };
  }
  // args
)
