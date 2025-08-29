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
    version = "10.10.1";
    srcHash = "sha256-tPjwtbGzg1G9fWoo8UC82RLm2GOQhvtQiw4vXKxz2ww=";
    vendorHash = "sha256-hsTmqwISOln2YlMXNBXKu4iPwWsLEyoe5IIth9lYjbM=";
    npmDepsHash = "sha256-Uv2lqcz2AV/gJJFWSN5cSP7JYgnEJBXzexruKqNU7p4=";
    lockfileOverlay = ''
      unlock(.; "@floating-ui/react"; "channels/node_modules/@floating-ui/react")
    '';
    autoUpdate = ./package.nix;
  };
}
