{ lib, ... }:
{
  _class = "nixosTest";
  name = "snid";

  nodes = {
    machine =
      { pkgs, ... }:
      {
        system.services.snid = {
          imports = [ pkgs.snid.services.default ];
          snid = {
            listen = [ "tcp:8443" ];
            mode = "tcp";
            backendCidrs = [ "127.0.0.0/8" ];
          };
        };

        networking.firewall.allowedTCPPorts = [ 8443 ];
      };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("multi-user.target")
    machine.wait_for_unit("snid.service")
    machine.wait_for_open_port(8443)
  '';

  meta.maintainers = with lib.maintainers; [ tomfitzhenry ];
}
