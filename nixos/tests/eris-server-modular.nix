{ lib, ... }:
{
  _class = "nixosTest";
  name = "eris-server";
  meta.maintainers = with lib.maintainers; [ ehmry ];

  nodes.server =
    { config, pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.eris-go
        pkgs.eriscmd
      ];
      system.services.eris = {
        imports = [ pkgs.eris-go.services.default ];
        eris-server = {
          enable = true;
          decode = true;
          listenHttp = "[::1]:80";
          backends = [ "badger+file:///var/cache/eris.badger?get&put" ];
        };
      };
    };

  testScript =
    { ... }:
    ''
      start_all()
      server.wait_for_unit("eris.service")
      server.wait_for_open_port(5683)
      server.wait_for_open_port(80)
      server.succeed("eriscmd get http://[::1] $(echo 'Hail ERIS!' | eriscmd put coap+tcp://[::1]:5683)")
    '';
}
