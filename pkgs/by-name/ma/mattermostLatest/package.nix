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
    version = "10.5.1";
    srcHash = "sha256-Hkv5jaWzJ5NjLR5/XH2kqaGlJGIluFDhXEatQd6Tthg=";
    vendorHash = "sha256-7jghoXFKA+WZ/ywOT0wWDMTfqAcBqp5gswOvpB7weL0=";
    npmDepsHash = "sha256-sPR08IUjAJ28MbAC065IZpqtk0aZ6rjN063NpZHVmnw=";
    lockfileOverlay = ''
      unlock(.; "@floating-ui/react"; "channels/node_modules/@floating-ui/react")
    '';
    autoUpdate = ./package.nix;
  };
}
