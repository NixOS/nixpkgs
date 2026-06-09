{ lib, pkgs, ... }:

let
  port = 3001;
in
{
  name = "tinyauth";
  meta.maintainers = with lib.maintainers; [ shaunren ];

  nodes.machine = {
    services.tinyauth = {
      enable = true;
      settings = {
        APPURL = "http://auth.example.com";
        SERVER_PORT = port;
        ANALYTICS_ENABLED = false;
      };

      environmentFile = pkgs.writeText "tinyauth-env" ''
        TINYAUTH_AUTH_USERS=test:$$2a$$10$$NP5wKRFw5GuVVI.g07zvAucRYk0cyL83WDPVQ81Zai.Xi5tkNvxL6
      '';
    };
  };

  testScript = ''
    machine.wait_for_unit("tinyauth.service")
    machine.wait_for_open_port(${toString port})

    machine.succeed("curl -sSf -H Host:auth.example.com http://localhost:${toString port}")
  '';
}
