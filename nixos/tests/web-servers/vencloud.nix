import ../make-test-python.nix (
  { lib, pkgs, ... }:
  {
    name = "vencloud";
    meta.maintainers = with lib.maintainers; [ eveeifyeve ];

    nodes.server = {
      services.vencloud = {
        enable = true;
        settings = {
          redis = {
            enable = true;
            user = "vencloud";
            host = "localhost";
            port = 6379;
          };
        };
      };
    };

    testScript = ''
      server.start()
      server.wait_for_unit("vencloud.service")
      server.wait_for_open_port(8080)
      server.succeed("curl --fail http://localhost:8080/")
    '';
  }
)
