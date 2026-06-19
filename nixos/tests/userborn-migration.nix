{ lib, ... }:

# Verifies that switching from update-users-groups.pl to userborn honours
# /var/lib/nixos/{uid,gid}-map and declarative-{users,groups}, so removed
# users keep their ids reserved and are not reassigned.

{
  name = "userborn-migration";

  meta.maintainers = with lib.maintainers; [ rvdp ];

  nodes.machine = {
    services.userborn.enable = false;
    systemd.sysusers.enable = false;
    users.mutableUsers = true;

    users.users = {
      survivor = {
        isNormalUser = true;
      };
      ghost = {
        isNormalUser = true;
      };
      intruder = {
        isNormalUser = true;
        # Only created under userborn. Must not get ghost's old uid.
        enable = lib.mkDefault false;
      };
    };

    specialisation = {
      # Still perl-managed. ghost is removed but kept in uid-map.
      base-ghost-removed.configuration = {
        users.users.ghost.enable = lib.mkForce false;
      };

      # Switch to userborn with ghost gone and a new unpinned user.
      userborn.configuration = {
        services.userborn.enable = lib.mkForce true;
        users.users.ghost.enable = lib.mkForce false;
        users.users.intruder.enable = true;
      };

      # ghost re-added under userborn. Must keep its original uid.
      userborn-revived.configuration = {
        services.userborn.enable = lib.mkForce true;
        users.users.intruder.enable = true;
      };
    };
  };

  testScript =
    # python
    ''
      import json

      machine.wait_for_unit("multi-user.target")

      def uid(name: str) -> int:
          return int(machine.succeed(f"id --user {name}").strip())

      def switch(specialisation: str) -> None:
          machine.succeed(
              f"/run/booted-system/specialisation/{specialisation}/bin/switch-to-configuration switch 2>&1 | tee /dev/stderr"
          )

      with subtest("perl: capture allocated state"):
          survivor_uid = uid("survivor")
          ghost_uid = uid("ghost")

          uid_map = json.loads(machine.succeed("cat /var/lib/nixos/uid-map"))
          t.assertEqual(uid_map["ghost"], ghost_uid)
          t.assertEqual(uid_map["survivor"], survivor_uid)

      with subtest("perl: remove ghost"):
          switch("base-ghost-removed")
          machine.fail("getent passwd ghost")

          uid_map = json.loads(machine.succeed("cat /var/lib/nixos/uid-map"))
          t.assertEqual(
              uid_map["ghost"], ghost_uid, "perl script must retain removed users in uid-map"
          )

      with subtest("userborn: legacy state is imported"):
          switch("userborn")

          machine.succeed("test -e /var/lib/userborn/.legacy-imported")

          # ghost must be a locked stub with its original uid.
          ghost_passwd = machine.succeed("getent passwd ghost").strip()
          t.assertEqual(
              int(ghost_passwd.split(":")[2]),
              ghost_uid,
              f"ghost stub has wrong uid: {ghost_passwd}",
          )
          ghost_shadow = machine.succeed("getent shadow ghost").strip()
          t.assertTrue(
              ghost_shadow.split(":")[1].startswith("!"),
              f"ghost stub is not locked: {ghost_shadow}",
          )

          # previous-userborn.json is replaced by ExecStartPost after use,
          # so check the journal instead.
          machine.succeed(
              "journalctl -u userborn-import-legacy.service --grep 'synthesised.*previous-userborn.json'"
          )

      with subtest("userborn: no uid collision for new user"):
          intruder_uid = uid("intruder")
          t.assertNotEqual(
              intruder_uid,
              ghost_uid,
              "intruder was allocated ghost's old uid; migration failed to reserve it",
          )
          t.assertEqual(uid("survivor"), survivor_uid, "survivor uid changed across migration")

      with subtest("userborn: revival keeps original uid"):
          switch("userborn-revived")
          t.assertEqual(
              uid("ghost"),
              ghost_uid,
              "ghost was not revived with its original uid",
          )

      with subtest("idempotency"):
          machine.succeed("systemctl restart userborn-import-legacy.service")
          result = machine.succeed(
              "systemctl show -p ConditionResult userborn-import-legacy.service"
          ).strip()
          t.assertEqual(result, "ConditionResult=no")
    '';
}
