import ./make-test-python.nix (
  { pkgs, ... }:
  let
    server-port = 3141;
  in
  {
    name = "devpi-server";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ cafkafk ];
    };

    nodes = {
      devpi =
        { ... }:
        {
          services.devpi-server = {
            enable = true;
            host = "0.0.0.0";
            port = server-port;
            openFirewall = true;
            secretFile = pkgs.writeText "devpi-secret" "v263P+V3YGDYUyfYL/RBURw+tCPMDw94R/iCuBNJrDhaYrZYjpA6XPFVDDH8ViN20j77y2PHoMM/U0opNkVQ2g==";
          };
        };

      client1 =
        { ... }:
        {
          environment.systemPackages = with pkgs; [
            devpi-client
            jq
          ];
        };
    };

    testScript = ''
      start_all()
      devpi.wait_for_unit("devpi-server.service")
      devpi.wait_for_open_port(${builtins.toString server-port})

      client1.succeed("devpi getjson http://devpi:${builtins.toString server-port}")
    '';
  }
)
