{ lib, ... }:

# Verifies that an existing system managed by update-users-groups.pl can be
# safely switched to userborn without UID/GID reuse.
#
# State that the perl script keeps in /var/lib/nixos/ and that must be honoured
# across the switch:
#   uid-map, gid-map           name -> id, including removed users
#   declarative-{users,groups} names that were declaratively managed
#
# See nixos/modules/services/system/userborn-import-legacy.py for the
# implementation under test.

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
        # Only created in the userborn specialisation, to verify it does not
        # receive ghost's old uid.
        enable = lib.mkDefault false;
      };
    };

    specialisation = {
      # Still perl-managed, but `ghost` has been removed from the config.
      # The perl script deletes the passwd entry but keeps the uid in
      # /var/lib/nixos/uid-map.
      base-ghost-removed.configuration = {
        users.users.ghost.enable = lib.mkForce false;
      };

      # Switch to userborn. `ghost` is still gone, and a new user `intruder`
      # is added without a pinned uid. The migration must ensure `intruder`
      # does not receive `ghost`'s old uid.
      userborn.configuration = {
        services.userborn.enable = lib.mkForce true;
        users.users.ghost.enable = lib.mkForce false;
        users.users.intruder.enable = true;
      };

      # `ghost` re-added under userborn. Must be revived with its original uid.
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

          # ghost must exist as a locked stub with its original uid so that
          # userborn's allocator treats the id as occupied.
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

          # The import script synthesises previous-userborn.json from
          # declarative-users so userborn's first run knows which entries were
          # declarative under perl. We can't inspect the file directly since
          # userborn's ExecStartPost replaces it after consuming it; check the
          # journal instead.
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
          # Import must be skipped on subsequent runs.
          machine.succeed("systemctl restart userborn-import-legacy.service")
          result = machine.succeed(
              "systemctl show -p ConditionResult userborn-import-legacy.service"
          ).strip()
          t.assertEqual(result, "ConditionResult=no")
    '';
}
