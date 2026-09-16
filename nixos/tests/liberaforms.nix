{
  lib,
  ...
}:

let
  ports = {
    service = 8000;
  };
in

{
  name = "liberaforms";
  meta.maintainers = lib.teams.ngi.members;

  nodes = {
    machine =
      { pkgs, ... }:
      {
        services.liberaforms = {
          enable = true;
          settings = {
            FLASK_CONFIG = "default";
            BASE_URL = "http://0.0.0.0:80";
            ROOT_USER = "ngi@nixos.org";
            SECRET_KEY = "a_secret_key";
            SESSION_TYPE = "filesystem";
            TOKEN_EXPIRATION = "604800";
            DEFAULT_TIMEZONE = "Asia/Shanghai";
            TOTAL_UPLOADS_LIMIT = "1 GB";
            DEFAULT_USER_UPLOADS_LIMIT = "50 MB";
            ENABLE_REMOTE_STORAGE = "False";
            MAX_MEDIA_SIZE = "512000";
            MAX_ATTACHMENT_SIZE = "1572864";
            ENABLE_PROMETHEUS_METRICS = "False";
            ENABLE_RSS_FEED = "False";
            DEFAULT_LANGUAGE = "en-US";
          };
        };
      };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("multi-user.target")

    machine.wait_for_unit("liberaforms.service")
    machine.wait_until_succeeds("curl --fail http://0.0.0.0:${toString ports.service}/")
  '';

  # Debug interactively with:
  # - nix run -f . nixosTests.liberaforms.driverInteractive -L
  # - run_tests()
  interactive.sshBackdoor.enable = true;
  interactive.nodes.machine =
    { pkgs, lib, ... }:
    {
      # forward ports from VM to host
      virtualisation.forwardPorts = lib.mapAttrsToList (_: port: {
        from = "host";
        host = { inherit port; };
        guest = { inherit port; };
      }) ports;
    };
}
