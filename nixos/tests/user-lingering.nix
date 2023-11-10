# Test user lingering management (`man 1 loginctl`).

import ./make-test-python.nix ({ pkgs, lib, ...} : {
  name = "user-lingering";
  meta.maintainers = with lib.maintainers; [ tomeon ];

  nodes.machine = { config, ... }: let
    common = {
      users.users = {
        yes-linger = {
          isNormalUser = true;
          linger = true;
        };

        no-linger = {
          isNormalUser = true;
          linger = false;
        };
      };
    };
  in {
    users.mutableUsers = lib.mkDefault false;
    users.users.on-boot-linger = {
      isNormalUser = true;
      linger = true;
    };

    specialisation.mutable.configuration = lib.mkMerge [
      common
      { users.mutableUsers = true; }
    ];

    specialisation.immutable.configuration = lib.mkMerge [
      common
      { users.mutableUsers = false; }
    ];

    specialisation.removed-mutable.configuration = {
      users.mutableUsers = true;
    };

    specialisation.removed-immutable.configuration = {
      users.mutableUsers = false;
    };
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("default.target")

    def prepLingering():
        machine.succeed("loginctl disable-linger yes-linger")
        machine.succeed("loginctl enable-linger no-linger")
        machine.fail("test -e /var/lib/systemd/linger/yes-linger")
        machine.succeed("test -e /var/lib/systemd/linger/no-linger")

    def checkSession():
        machine.wait_for_unit("multi-user.target")
        machine.succeed("test -e /var/lib/systemd/linger/on-boot-linger")
        state = machine.succeed("loginctl show-user --value --property=State on-boot-linger").strip()
        assert state in ("lingering", "active"), f"expected state to be 'lingering' or 'active' but got '{state}'"
        machine.wait_for_unit("user@$(id -u on-boot-linger)")

    with subtest("User lingering settings apply successfully on boot"):
        checkSession()

    with subtest("Lingering settings for new users are enforced in mutable mode"):
        machine.fail("test -e /var/lib/systemd/linger/yes-linger")
        machine.fail("test -e /var/lib/systemd/linger/no-linger")
        machine.succeed(
            "/run/booted-system/specialisation/mutable/bin/switch-to-configuration test"
        )
        machine.succeed("test -e /var/lib/systemd/linger/yes-linger")
        machine.fail("test -e /var/lib/systemd/linger/no-linger")

    with subtest("Lingering settings are enforced in immutable mode"):
        prepLingering()
        machine.succeed(
            "/run/booted-system/specialisation/immutable/bin/switch-to-configuration test"
        )
        machine.succeed("test -e /var/lib/systemd/linger/yes-linger")
        machine.fail("test -e /var/lib/systemd/linger/no-linger")

    with subtest("Lingering settings for existing users are left untouched in mutable mode"):
        prepLingering()
        machine.succeed(
            "/run/booted-system/specialisation/mutable/bin/switch-to-configuration test"
        )
        machine.fail("test -e /var/lib/systemd/linger/yes-linger")
        machine.succeed("test -e /var/lib/systemd/linger/no-linger")

    with subtest("dry-activation does not change lingering settings"):
        prepLingering()
        machine.succeed(
            "/run/booted-system/specialisation/immutable/bin/switch-to-configuration dry-activate"
        )
        machine.fail("test -e /var/lib/systemd/linger/yes-linger")
        machine.succeed("test -e /var/lib/systemd/linger/no-linger")

    with subtest("Removing declarative user accounts in immutable mode disables lingering for those users"):
        machine.succeed(
            "/run/booted-system/specialisation/immutable/bin/switch-to-configuration test"
        )
        machine.succeed("loginctl enable-linger no-linger")
        machine.succeed("test -e /var/lib/systemd/linger/no-linger")
        machine.succeed(
            "/run/booted-system/specialisation/removed-immutable/bin/switch-to-configuration test"
        )
        machine.fail("test -e /var/lib/systemd/linger/yes-linger")
        machine.fail("test -e /var/lib/systemd/linger/no-linger")

    with subtest("Removing declarative user accounts in mutable mode disables lingering for those users"):
        machine.succeed(
            "/run/booted-system/specialisation/immutable/bin/switch-to-configuration test"
        )
        machine.succeed("loginctl enable-linger no-linger")
        machine.succeed("test -e /var/lib/systemd/linger/no-linger")
        machine.succeed(
            "/run/booted-system/specialisation/removed-mutable/bin/switch-to-configuration test"
        )
        machine.fail("test -e /var/lib/systemd/linger/yes-linger")
        machine.fail("test -e /var/lib/systemd/linger/no-linger")

    with subtest("Removing non-declarative user accounts in immutable mode disables lingering for those users"):
        machine.succeed(
            "/run/booted-system/specialisation/immutable/bin/switch-to-configuration test"
        )
        machine.succeed("useradd extra-linger")
        machine.succeed("loginctl enable-linger extra-linger")
        machine.succeed("test -e /var/lib/systemd/linger/extra-linger")
        machine.succeed(
            "/run/booted-system/specialisation/immutable/bin/switch-to-configuration test"
        )
        machine.fail("test -e /var/lib/systemd/linger/extra-linger")

    with subtest("Applying user configuration in mutable mode does not disable lingering for non-declarative users"):
        machine.succeed(
            "/run/booted-system/specialisation/immutable/bin/switch-to-configuration test"
        )
        machine.succeed("useradd extra-linger")
        machine.succeed("loginctl enable-linger extra-linger")
        machine.succeed("test -e /var/lib/systemd/linger/extra-linger")
        machine.succeed(
            "/run/booted-system/specialisation/removed-mutable/bin/switch-to-configuration test"
        )
        machine.succeed("test -e /var/lib/systemd/linger/extra-linger")

    with subtest("User lingering settings reapply successfully on boot"):
        machine.execute("loginctl disable-linger on-boot-linger")
        # Since the `on-boot-linger` account might not be present right now
        machine.succeed("rm -f /var/lib/systemd/linger/on-boot-linger")
        machine.shutdown()
        machine.start()
        checkSession()
  '';
})
