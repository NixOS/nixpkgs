# Mutable users tests.

import ./make-test-python.nix ({ pkgs, ...} : {
  name = "mutable-users";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ gleber ];
  };

  nodes = {
    machine = { ... }: {
      users.mutableUsers = false;
    };
    mutable = { ... }: {
      users.mutableUsers = true;
    };
  };

  testScript = {nodes, ...}: let
    immutableSystem = nodes.machine.config.system.build.toplevel;
    mutableSystem = nodes.mutable.config.system.build.toplevel;
  in ''
    machine.start()
    machine.wait_for_unit("default.target")

    # Machine starts in immutable mode. Add a user and test if reactivating
    # configuration removes the user.
    with subtest("Machine in immutable mode"):
        assert "foobar" not in machine.succeed("cat /etc/passwd")
        machine.succeed("sudo useradd foobar")
        assert "foobar" in machine.succeed("cat /etc/passwd")
        machine.succeed(
            "${immutableSystem}/bin/switch-to-configuration test"
        )
        assert "foobar" not in machine.succeed("cat /etc/passwd")

    # In immutable mode passwd is not wrapped, while in mutable mode it is
    # wrapped.
    with subtest("Password is wrapped in mutable mode"):
        assert "/run/current-system/" in machine.succeed("which passwd")
        machine.succeed(
            "${mutableSystem}/bin/switch-to-configuration test"
        )
        assert "/run/wrappers/" in machine.succeed("which passwd")
  '';
})
