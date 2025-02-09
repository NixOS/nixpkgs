let
  port = 43110;
in
import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "zeronet-conservancy";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ fgaz ];
    };

    nodes.machine =
      { config, pkgs, ... }:
      {
        services.zeronet = {
          enable = true;
          package = pkgs.zeronet-conservancy;
          inherit port;
        };
      };

    testScript = ''
      machine.wait_for_unit("zeronet.service")

      machine.wait_for_open_port(${toString port})

      machine.succeed("curl --fail -H 'Accept: text/html, application/xml, */*' localhost:${toString port}/Stats")
    '';
  }
)
