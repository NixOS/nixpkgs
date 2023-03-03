import ../make-test-python.nix ({ lib, pkgs, ... }: {
  name = "netbox";

  meta = with lib.maintainers; {
    maintainers = [ n0emis ];
  };

  nodes.machine = { ... }: {
    services.netbox = {
      enable = true;
      secretKeyFile = pkgs.writeText "secret" ''
        abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
      '';
    };
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("netbox.target")
    machine.wait_until_succeeds("journalctl --since -1m --unit netbox --grep Listening")

    with subtest("Home screen loads"):
        machine.succeed(
            "curl -sSfL http://[::1]:8001 | grep '<title>Home | NetBox</title>'"
        )

    with subtest("Staticfiles are generated"):
        machine.succeed("test -e /var/lib/netbox/static/netbox.js")
  '';
})
