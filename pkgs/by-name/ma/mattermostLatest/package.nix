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
    regex = "^v(11\\.[0-9]+\\.[0-9]+)$";
    version = "11.4.0";
    srcHash = "sha256-w+/slirvft6OQHLmZHwy92GEy0SSJ+5uV/8e3xOB2CE=";
    vendorHash = "sha256-8Q5jiEsLy3hZLL81tU3xG8zp65KpAYsjSE9jit77fEI=";
    npmDepsHash = "sha256-MrFV87WslmFxil9zW5JmoT5psM0GAJvmDK3WfkxpoUo=";
    lockfileOverlay = ''
      unlock(.; "@floating-ui/react"; "channels/node_modules/@floating-ui/react")
    '';
    autoUpdate = ./package.nix;
  };
}
