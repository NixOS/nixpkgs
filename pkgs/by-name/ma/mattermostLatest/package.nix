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
    version = "10.5.7";
    srcHash = "sha256-HPQmN6GXDTEmloIcU0k+sYx/Qeh1j6T2yCT/W1/aWz4=";
    vendorHash = "sha256-9Jl+lxvSoxUReziTqkDRyeNrijGWcBDbqoywJRIeD2k=";
    npmDepsHash = "sha256-tIeuDUZbqgqooDm5TRfViiTT5OIyN0BPwvJdI+wf7p0=";
    lockfileOverlay = ''
      unlock(.; "@floating-ui/react"; "channels/node_modules/@floating-ui/react")
    '';
    autoUpdate = ./package.nix;
  };
}
