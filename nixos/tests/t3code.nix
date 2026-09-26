{ lib, ... }:
{
  name = "t3code";

  nodes.machine = {
    users.users.alice.isNormalUser = true;

    services.t3code = {
      enable = true;
      user = "alice";
    };
  };

  testScript =
    { nodes, ... }:
    let
      t3 = lib.getExe' nodes.machine.services.t3code.package "t3";
    in
    ''
      machine.wait_for_unit("t3code.service")
      machine.wait_until_succeeds("journalctl -u t3code.service | grep 'T3 Code server is ready'")
      machine.succeed("curl --fail -s --max-time 10 http://127.0.0.1:3773/ | grep -i '<html'")
      machine.fail("journalctl -u t3code.service | grep 'Failed to flush telemetry'")
      machine.fail("journalctl -u t3code.service | grep -E 'Token: |Pairing URL: |█'")
      machine.succeed("su - alice -c '${t3} auth pairing create --json' | grep credential")
    '';

  meta.maintainers = with lib.maintainers; [ jakob1379 ];
}
