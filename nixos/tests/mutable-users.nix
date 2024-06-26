# Mutable users tests.

import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "mutable-users";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ gleber ];
    };

    nodes = {
      machine =
        { ... }:
        {
          users.mutableUsers = false;
        };
      mutable =
        { ... }:
        {
          users.mutableUsers = true;
          users.users.dry-test.isNormalUser = true;
        };
    };

    testScript =
      { nodes, ... }:
      let
        immutableSystem = nodes.machine.config.system.build.toplevel;
        mutableSystem = nodes.mutable.config.system.build.toplevel;
      in
      ''
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

        with subtest("dry-activation does not change files"):
            machine.succeed('test -e /home/dry-test')  # home was created
            machine.succeed('rm -rf /home/dry-test')

            files_to_check = ['/etc/group',
                              '/etc/passwd',
                              '/etc/shadow',
                              '/etc/subuid',
                              '/etc/subgid',
                              '/var/lib/nixos/uid-map',
                              '/var/lib/nixos/gid-map',
                              '/var/lib/nixos/declarative-groups',
                              '/var/lib/nixos/declarative-users'
                             ]
            expected_hashes = {}
            expected_stats = {}
            for file in files_to_check:
                expected_hashes[file] = machine.succeed(f"sha256sum {file}")
                expected_stats[file] = machine.succeed(f"stat {file}")

            machine.succeed("/run/current-system/bin/switch-to-configuration dry-activate")

            machine.fail('test -e /home/dry-test')  # home was not recreated
            for file in files_to_check:
                assert machine.succeed(f"sha256sum {file}") == expected_hashes[file]
                assert machine.succeed(f"stat {file}") == expected_stats[file]
      '';
  }
)
