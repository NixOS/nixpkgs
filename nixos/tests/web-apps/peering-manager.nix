import ../make-test-python.nix ({ lib, pkgs, ... }: {
  name = "peering-manager";

  meta = with lib.maintainers; {
    maintainers = [ yuka ];
  };

  nodes.machine = { ... }: {
    services.peering-manager = {
      enable = true;
      secretKeyFile = pkgs.writeText "secret" ''
        abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
      '';
    };
  };

  testScript = { nodes }: ''
    machine.start()
    machine.wait_for_unit("peering-manager.target")
    machine.wait_until_succeeds("journalctl --since -1m --unit peering-manager --grep Listening")

    print(machine.succeed(
        "curl -sSfL http://[::1]:8001"
    ))
    with subtest("Home screen loads"):
        machine.succeed(
            "curl -sSfL http://[::1]:8001 | grep '<title>Home - Peering Manager</title>'"
        )
    with subtest("checks succeed"):
        machine.succeed(
            "systemctl stop peering-manager peering-manager-rq"
        )
        machine.succeed(
            "sudo -u postgres psql -c 'ALTER USER \"peering-manager\" WITH SUPERUSER;'"
        )
        machine.succeed(
<<<<<<< HEAD
            "cd ${nodes.machine.system.build.peeringManagerPkg}/opt/peering-manager ; peering-manager-manage test --no-input"
=======
            "cd ${nodes.machine.config.system.build.peeringManagerPkg}/opt/peering-manager ; peering-manager-manage test --no-input"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        )
  '';
})
