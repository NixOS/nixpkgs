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
    version = "10.9.2";
    srcHash = "sha256-0el9PROsErFFnOIhv+TdFAXaXRECEeBqaiaPGMt5M5E=";
    vendorHash = "sha256-+wmemZZyuz90VCXjO0ekplxdkv2p0s5h4qUObAA0XwU=";
    npmDepsHash = "sha256-uAB599r3ZWjnt+jwk7sjSiPsc/tUyiBZzGqLZxuU3xE=";
    lockfileOverlay = ''
      unlock(.; "@floating-ui/react"; "channels/node_modules/@floating-ui/react")
    '';
    autoUpdate = ./package.nix;
  };
}
