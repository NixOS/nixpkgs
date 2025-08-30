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
    version = "10.11.2";
    srcHash = "sha256-lqMdH7jvnO6Z+dP+DHbxeM4iHU6EoJ3/bx8t/oJau0Q=";
    vendorHash = "sha256-Lqa463LLy41aaRbrtJFclfOj55vLjK4pWFAFLzX3TJE=";
    npmDepsHash = "sha256-p9dq31qw0EZDQIl2ysKE38JgDyLA6XvSv+VtHuRh+8A=";
    lockfileOverlay = ''
      unlock(.; "@floating-ui/react"; "channels/node_modules/@floating-ui/react")
    '';
    autoUpdate = ./package.nix;
  };
}
