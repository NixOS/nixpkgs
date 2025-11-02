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
    version = "10.12.2";
    srcHash = "sha256-PPUc4fg1LcGwkyixa8KVW4Ag3xxt2qmOKe1loaLHZrk=";
    vendorHash = "sha256-Lsw/cvl98JdVmzWr85lAv/JMcTmZZZ4ALLunFLNcrro=";
    npmDepsHash = "sha256-O9iX6hnwkEHK0kkHqWD6RYXqoSEW6zs+utiYHnt54JY=";
    lockfileOverlay = ''
      unlock(.; "@floating-ui/react"; "channels/node_modules/@floating-ui/react")
    '';
    autoUpdate = ./package.nix;
  };
}
