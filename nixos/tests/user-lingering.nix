# Test user lingering management (`man 1 loginctl`).

import ./make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "user-lingering";
    meta.maintainers = with lib.maintainers; [ tomeon ];

    nodes.machine =
      { config, ... }:
      let
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
      in
      {
        # Stop this service in order to isolate the lingering-management logic
        # in `update-users-groups.pl`.
        systemd.services.linger-users.enable = false;

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

      def manageLinger(user, mode, host=machine):
          return host.succeed(f"loginctl {mode} {user}")

      def disableLinger(user, host=machine):
          return manageLinger(user, "disable-linger", host=host)

      def enableLinger(user, host=machine):
          return manageLinger(user, "enable-linger", host=host)

      def lingerDirOf(user):
          return f"/var/lib/systemd/linger/{user}"

      def lingerDirPresent(user, host=machine):
          return host.succeed(f"test -e {lingerDirOf(user)}")

      def lingerDirAbsent(user, host=machine):
          return host.fail(f"test -e {lingerDirOf(user)}")

      def prepLingering():
          disableLinger("yes-linger")
          enableLinger("no-linger")
          lingerDirAbsent("yes-linger")
          lingerDirPresent("no-linger")

      with subtest("Lingering settings for new users are enforced in mutable mode"):
          lingerDirAbsent("yes-linger")
          lingerDirAbsent("no-linger")
          machine.succeed(
              "/run/booted-system/specialisation/mutable/bin/switch-to-configuration test"
          )
          lingerDirPresent("yes-linger")
          lingerDirAbsent("no-linger")

      with subtest("Lingering settings are enforced in immutable mode"):
          prepLingering()
          machine.succeed(
              "/run/booted-system/specialisation/immutable/bin/switch-to-configuration test"
          )
          lingerDirPresent("yes-linger")
          lingerDirAbsent("no-linger")

      with subtest("Lingering settings for existing users are left untouched in mutable mode"):
          prepLingering()
          machine.succeed(
              "/run/booted-system/specialisation/mutable/bin/switch-to-configuration test"
          )
          lingerDirAbsent("yes-linger")
          lingerDirPresent("no-linger")

      with subtest("dry-activation does not change lingering settings"):
          prepLingering()
          machine.succeed(
              "/run/booted-system/specialisation/immutable/bin/switch-to-configuration dry-activate"
          )
          lingerDirAbsent("yes-linger")
          lingerDirPresent("no-linger")

      with subtest("Removing declarative user accounts in immutable mode disables lingering for those users"):
          machine.succeed(
              "/run/booted-system/specialisation/immutable/bin/switch-to-configuration test"
          )
          enableLinger("no-linger")
          lingerDirPresent("no-linger")
          machine.succeed(
              "/run/booted-system/specialisation/removed-immutable/bin/switch-to-configuration test"
          )
          lingerDirAbsent("yes-linger")
          lingerDirAbsent("no-linger")

      with subtest("Removing declarative user accounts in mutable mode disables lingering for those users"):
          machine.succeed(
              "/run/booted-system/specialisation/immutable/bin/switch-to-configuration test"
          )
          enableLinger("no-linger")
          lingerDirPresent("no-linger")
          machine.succeed(
              "/run/booted-system/specialisation/removed-mutable/bin/switch-to-configuration test"
          )
          lingerDirAbsent("yes-linger")
          lingerDirAbsent("no-linger")

      with subtest("Removing non-declarative user accounts in immutable mode disables lingering for those users"):
          user = "extra-linger"
          machine.succeed(
              "/run/booted-system/specialisation/immutable/bin/switch-to-configuration test"
          )
          machine.succeed(f"useradd {user}")
          enableLinger(user)
          lingerDirPresent(user)
          machine.succeed(
              "/run/booted-system/specialisation/immutable/bin/switch-to-configuration test"
          )
          lingerDirAbsent(user)

      with subtest("Applying user configuration in mutable mode does not disable lingering for non-declarative users"):
          user = "extra-linger"
          machine.succeed(
              "/run/booted-system/specialisation/immutable/bin/switch-to-configuration test"
          )
          machine.succeed(f"useradd {user}")
          enableLinger(user)
          lingerDirPresent(user)
          machine.succeed(
              "/run/booted-system/specialisation/removed-mutable/bin/switch-to-configuration test"
          )
          lingerDirPresent(user)
    '';
  }
)
