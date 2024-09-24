import ./make-test-python.nix (
  { lib, pkgs, ... }:
  {

    name = "artalk";

    meta = {
      maintainers = with lib.maintainers; [ moraxyc ];
    };

    nodes.machine =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.curl ];
        services.artalk = {
          enable = true;
        };
      };

    testScript = ''
      machine.wait_for_unit("artalk.service")

      machine.wait_for_open_port(23366)

      machine.succeed("curl --fail --max-time 10 http://127.0.0.1:23366/")
    '';
  }
)
