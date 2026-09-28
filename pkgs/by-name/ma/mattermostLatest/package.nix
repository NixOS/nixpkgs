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
      version = "11.10.2";
      srcHash = "sha256-d4sOH9L2vawyiRLXIhZLzEqExiYbrdy/h0v4GZW7DNc=";
      vendorHash = "sha256-k3JPDzrZzLeKb20o2aLZR/TX7dN7nhpQs6UZ5olvV94=";
      npmDepsHash = "sha256-jDGUbBwxjZ50bbbnUJVMCzKJMlHYhUKy7Be9zsWjMqg=";
      autoUpdate = ./package.nix;
    };
  }
  // args
)
