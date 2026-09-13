{ lib, ... }:
{
  _class = "nixosTest";
  name = "opengist-modular";
  meta.maintainers = with lib.maintainers; [ tomasrivera ];

  nodes.machine = { pkgs, ... }: {
    system.services.opengist = {
      imports = [ pkgs.opengist.services.default ];
      opengist.settings = {
        opengist-home = "/tmp/test";
      };
    };
  };

  # Opengist already tests the internals during the checkPhase. Checking them here would be redundant. See https://github.com/thomiceli/opengist/blob/master/internal/web/test/api.go and https://github.com/thomiceli/opengist/blob/master/internal/web/test/server.go for more information.

  testScript = ''
    machine.wait_for_unit("opengist.service")
    print(machine.execute("systemctl status opengist"))
    print(machine.execute("journalctl -u opengist -n 100 --no-pager"))
    machine.wait_until_succeeds("curl -s http://localhost:6157", timeout=60)
  '';
}
