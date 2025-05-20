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
    regex = "^v(10\\.[0-9]+\\.[0-9]+)$";
    version = "10.8.0";
    srcHash = "sha256-JfMQXwRXb3KdZssi5z4KU+X6oBu4+SZRN7KeCBd2Q1E=";
    vendorHash = "sha256-K51Ps1hvi4O0sCYAiAhYHJa2Igpt1dF16VUJPA3S3XA=";
    npmDepsHash = "sha256-iddiDUXW9o6bCvswxCQTk9GbaZ1Kk0RN7RY9dPrClXQ=";
    lockfileOverlay = ''
      unlock(.; "@floating-ui/react"; "channels/node_modules/@floating-ui/react")
    '';
    autoUpdate = ./package.nix;
  };
}
