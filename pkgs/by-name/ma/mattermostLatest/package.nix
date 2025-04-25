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
    version = "10.7.0";
    srcHash = "sha256-T8lLF5AsJYALVijXOUxkSACa6h8W4HcqoML2+BPsEsY=";
    vendorHash = "sha256-B2vfHszOVKbkN7h0tQGeGzLdeuxQDgaFv9QWkQgGCWs=";
    npmDepsHash = "sha256-ZMgsfdmGtU3PgdmiY0xMCHh8dAOAmEFNbKcxXKO7CJc=";
    lockfileOverlay = ''
      unlock(.; "@floating-ui/react"; "channels/node_modules/@floating-ui/react")
    '';
    autoUpdate = ./package.nix;
  };
}
