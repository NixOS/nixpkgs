# Mutable users tests.

import ./make-test-python.nix ({ pkgs, lib, ...} : {
  name = "mutable-users";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ gleber ];
  };

  nodes = let
    maybeOutOfUids = i: { ... }: {
      users.mutableUsers = false;

      specialisation.first = {
        inheritParentConfig = true;
        configuration = {
          users = {
            extraUsers = lib.fold (a: b: a // b) { } (builtins.map (i: {
              "test${builtins.toString i}" = {
              group = "test";
              home = "/var/empty";
              shell = pkgs.nologin;
              isSystemUser = true;
            };
          }) (lib.range 1 i));
            extraGroups.test = { name = "test"; };
          };
        };
      };

      specialisation.second = {
        inheritParentConfig = true;
        configuration = {};
      };

      specialisation.third = {
        inheritParentConfig = true;
        configuration = {
          users.users.whichuid.isSystemUser = true;
          users.users.whichuid.group = "whichuid";
          users.groups.whichuid = {};
        };
      };
    }; in {
    machine = { ... }: {
      users.mutableUsers = false;
    };
    mutable = { ... }: {
      users.mutableUsers = true;
      users.users.dry-test.isNormalUser = true;
    };
    noUidReuse = { ... }: {
      users.mutableUsers = false;

      specialisation.first = {
        inheritParentConfig = true;
        configuration = {
          users.users.test0.isNormalUser = true;
        };
      };

      specialisation.second = {
        inheritParentConfig = true;
        configuration = {};
      };

      specialisation.third = {
        inheritParentConfig = true;
        configuration = {
          users.users.test1.isNormalUser = true;
        };
      };
    };
    outOfUidsNoReuse = maybeOutOfUids 600;
    notOutOfUidsNoReuse = maybeOutOfUids 599;
  };

  testScript = {nodes, ...}: let
    immutableSystem = nodes.machine.config.system.build.toplevel;
    mutableSystem = nodes.mutable.config.system.build.toplevel;
    noUidReuseSystem = nodes.noUidReuse.config.system.build.toplevel;
    outOfUidsNoReuseSystem = nodes.outOfUidsNoReuse.config.system.build.toplevel;
    notOutOfUidsNoReuseSystem = nodes.notOutOfUidsNoReuse.config.system.build.toplevel;
  in ''
    noUidReuse.start()
    outOfUidsNoReuse.start()
    notOutOfUidsNoReuse.start()
    machine.start()


    noUidReuse.wait_for_unit("default.target")

    assert "test0:x:" not in noUidReuse.succeed("cat /etc/passwd")
    assert "test1:x:" not in noUidReuse.succeed("cat /etc/passwd")

    noUidReuse.succeed("${noUidReuseSystem}/bin/switch-to-configuration test")
    noUidReuse.succeed("/run/current-system/specialisation/first/bin/switch-to-configuration test")
    assert "test0:x:1000:" in noUidReuse.succeed("cat /etc/passwd")
    assert "test1:x:" not in noUidReuse.succeed("cat /etc/passwd")

    noUidReuse.succeed("${noUidReuseSystem}/bin/switch-to-configuration test")
    noUidReuse.succeed("/run/current-system/specialisation/second/bin/switch-to-configuration test")
    assert "test0:x:" not in noUidReuse.succeed("cat /etc/passwd")
    assert "test1:x:" not in noUidReuse.succeed("cat /etc/passwd")

    noUidReuse.succeed("${noUidReuseSystem}/bin/switch-to-configuration test")
    noUidReuse.succeed("/run/current-system/specialisation/third/bin/switch-to-configuration test")
    assert "test0:x:" not in noUidReuse.succeed("cat /etc/passwd")
    assert "test1:x:1001:" in noUidReuse.succeed("cat /etc/passwd")


    outOfUidsNoReuse.wait_for_unit("default.target")

    outOfUidsNoReuse.succeed("${outOfUidsNoReuseSystem}/bin/switch-to-configuration test")
    outOfUidsNoReuse.succeed("/run/current-system/specialisation/first/bin/switch-to-configuration test")
    assert "test" in outOfUidsNoReuse.succeed("cat /etc/passwd")

    outOfUidsNoReuse.succeed("${outOfUidsNoReuseSystem}/bin/switch-to-configuration test")
    outOfUidsNoReuse.succeed("/run/current-system/specialisation/second/bin/switch-to-configuration test")
    assert "test" not in outOfUidsNoReuse.succeed("cat /etc/passwd")
    assert "whichuid:x:" not in outOfUidsNoReuse.succeed("cat /etc/passwd")

    outOfUidsNoReuse.succeed("${outOfUidsNoReuseSystem}/bin/switch-to-configuration test")
    assert "Activation script snippet 'users' failed" in outOfUidsNoReuse.fail("/run/current-system/specialisation/third/bin/switch-to-configuration test")
    assert "whichuid:x:" not in outOfUidsNoReuse.succeed("cat /etc/passwd")


    notOutOfUidsNoReuse.wait_for_unit("default.target")

    notOutOfUidsNoReuse.succeed("${notOutOfUidsNoReuseSystem}/bin/switch-to-configuration test")
    notOutOfUidsNoReuse.succeed("/run/current-system/specialisation/first/bin/switch-to-configuration test")
    assert "test" in notOutOfUidsNoReuse.succeed("cat /etc/passwd")
    assert ":x:400:" not in notOutOfUidsNoReuse.succeed("cat /etc/passwd")

    notOutOfUidsNoReuse.succeed("${notOutOfUidsNoReuseSystem}/bin/switch-to-configuration test")
    notOutOfUidsNoReuse.succeed("/run/current-system/specialisation/second/bin/switch-to-configuration test")
    assert "test" not in notOutOfUidsNoReuse.succeed("cat /etc/passwd")
    assert "whichuid:x:" not in notOutOfUidsNoReuse.succeed("cat /etc/passwd")

    notOutOfUidsNoReuse.succeed("${notOutOfUidsNoReuseSystem}/bin/switch-to-configuration test")
    notOutOfUidsNoReuse.succeed("/run/current-system/specialisation/third/bin/switch-to-configuration test")
    assert "whichuid:x:400:" in notOutOfUidsNoReuse.succeed("cat /etc/passwd")


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
})
