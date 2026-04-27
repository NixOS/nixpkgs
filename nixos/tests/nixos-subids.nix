{ lib, ... }:

# Dedicated test for nixos-subids, independent of the perl->userborn migration
# path. Runs under userborn from a fresh boot.

{
  name = "nixos-subids";

  meta.maintainers = with lib.maintainers; [ rvdp ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.userborn.enable = true;

      users.users = {
        alice = {
          isNormalUser = true;
        };
        bob = {
          isNormalUser = true;
          # Only enabled in the second generation to verify allocation order
          # is deterministic and non-overlapping.
          enable = lib.mkDefault false;
        };
        explicit = {
          isNormalUser = true;
          subUidRanges = [
            {
              startUid = 700000;
              count = 65536;
            }
          ];
          subGidRanges = [
            {
              startGid = 700000;
              count = 65536;
            }
          ];
        };
        # Huge root range like the incus module sets; auto allocations must
        # avoid it.
        root = {
          subUidRanges = [
            {
              startUid = 1000000;
              count = 1000000000;
            }
          ];
          subGidRanges = [
            {
              startGid = 1000000;
              count = 1000000000;
            }
          ];
        };
      };

      # newuidmap is a setuid wrapper provided by the shadow module; make
      # sure unshare is available for the smoke test.
      environment.systemPackages = [ pkgs.util-linux ];

      specialisation.with-bob.configuration = {
        users.users.bob.enable = true;
      };

      # Used to verify the legacy auto-subuid-map seed: carol has no entry in
      # /etc/subuid, but a synthesised legacy map records an old allocation
      # that must be reused instead of allocating a fresh one.
      specialisation.with-carol.configuration = {
        users.users.carol = {
          isNormalUser = true;
        };
      };

      # Strict mode: an explicit range that collides with alice's existing
      # auto allocation must fail the service before writing.
      specialisation.strict-conflict.configuration = {
        users.subIdRanges.strictOverlapCheck = true;
        # We don't know alice's auto range at eval time; instead claim a
        # huge range for a new user that necessarily covers it. The
        # eval-time warning won't fire (auto ranges are runtime state).
        users.users.mallory = {
          isNormalUser = true;
          subUidRanges = [
            {
              startUid = 100000;
              count = 200000;
            }
          ];
          subGidRanges = [
            {
              startGid = 100000;
              count = 200000;
            }
          ];
        };
      };
    };

  testScript =
    # python
    ''
      machine.wait_for_unit("multi-user.target")
      machine.succeed("systemctl is-active nixos-subids.service")

      def ranges(path: str) -> dict[str, list[tuple[int, int]]]:
          out: dict[str, list[tuple[int, int]]] = {}
          for line in machine.succeed(f"cat {path}").splitlines():
              name, start, count = line.split(":")
              out.setdefault(name, []).append((int(start), int(count)))
          return out

      def overlaps(a: tuple[int, int], b: tuple[int, int]) -> bool:
          # Two half-open intervals [start, start+count) overlap iff each one's
          # start lies strictly before the other's end.
          a_start, a_count = a
          b_start, b_count = b
          a_end = a_start + a_count
          b_end = b_start + b_count
          return a_start < b_end and b_start < a_end

      with subtest("files are regular, not symlinks"):
          # newuidmap (shadow-utils) opens with O_NOFOLLOW.
          machine.succeed("test -f /etc/subuid && ! test -L /etc/subuid")
          machine.succeed("test -f /etc/subgid && ! test -L /etc/subgid")

      with subtest("explicit and auto ranges present"):
          subuid = ranges("/etc/subuid")
          t.assertEqual(subuid["explicit"], [(700000, 65536)])
          t.assertEqual(subuid["root"], [(1000000, 1000000000)])
          t.assertEqual(len(subuid["alice"]), 1)
          alice_range = subuid["alice"][0]
          t.assertEqual(alice_range[1], 65536)

      with subtest("auto range avoids explicit ranges"):
          subuid = ranges("/etc/subuid")
          for name, rs in subuid.items():
              if name == "alice":
                  continue
              for r in rs:
                  t.assertFalse(
                      overlaps(alice_range, r),
                      f"alice {alice_range} overlaps {name} {r}",
                  )

      with subtest("newuidmap accepts the file"):
          # Smoke test that the setuid helper can read /etc/subuid; this would
          # fail if the file were a symlink.
          machine.succeed(
              "runuser -u alice -- unshare --user --map-users=auto --map-groups=auto true"
          )

      with subtest("legacy auto-subuid-map seeds the file once"):
          # Simulate state left behind by update-users-groups.pl: carol was
          # auto-allocated, then removed from the config, so /etc/subuid no
          # longer has a line for her but auto-subuid-map still does.
          machine.succeed("mkdir -p /var/lib/nixos")
          machine.succeed(
              'echo \'{"carol": 900000}\' > /var/lib/nixos/auto-subuid-map'
          )
          machine.succeed(
              "/run/booted-system/specialisation/with-carol/bin/switch-to-configuration test"
          )
          machine.succeed("test -e /var/lib/nixos-subids/.legacy-imported")
          subuid = ranges("/etc/subuid")
          t.assertEqual(
              subuid["carol"],
              [(900000, 65536)],
              "carol did not receive the legacy auto-subuid-map allocation",
          )

          # Second run is skipped by ConditionPathExists.
          machine.succeed("systemctl restart nixos-subids-import-legacy.service")
          result = machine.succeed(
              "systemctl show -p ConditionResult nixos-subids-import-legacy.service"
          ).strip()
          t.assertEqual(result, "ConditionResult=no")

          # Switch back; carol's seeded line must survive (never-delete).
          machine.succeed("/run/booted-system/bin/switch-to-configuration test")
          subuid = ranges("/etc/subuid")
          t.assertEqual(subuid["carol"], [(900000, 65536)])

      with subtest("adding a user allocates a fresh non-overlapping range"):
          machine.succeed(
              "/run/booted-system/specialisation/with-bob/bin/switch-to-configuration test"
          )
          subuid = ranges("/etc/subuid")
          t.assertEqual(len(subuid["bob"]), 1)
          bob_range = subuid["bob"][0]
          t.assertEqual(subuid["alice"], [alice_range], "alice range changed after switch")
          for name, rs in subuid.items():
              if name == "bob":
                  continue
              for r in rs:
                  t.assertFalse(
                      overlaps(bob_range, r),
                      f"bob {bob_range} overlaps {name} {r}",
                  )

      with subtest("removed user's range is kept"):
          machine.succeed(
              "/run/booted-system/bin/switch-to-configuration test"
          )
          subuid = ranges("/etc/subuid")
          t.assertEqual(subuid["bob"], [bob_range], "bob range was removed or changed")

      with subtest("idempotent"):
          before = machine.succeed("sha256sum /etc/subuid /etc/subgid")
          machine.succeed("systemctl restart nixos-subids.service")
          after = machine.succeed("sha256sum /etc/subuid /etc/subgid")
          t.assertEqual(before, after)

      with subtest("strict mode rejects overlap and leaves file untouched"):
          before = machine.succeed("sha256sum /etc/subuid /etc/subgid")
          machine.fail(
              "/run/booted-system/specialisation/strict-conflict/bin/switch-to-configuration test"
          )
          machine.succeed("systemctl is-failed nixos-subids.service")
          machine.succeed(
              "journalctl -b -u nixos-subids.service --grep 'overlaps'"
          )
          after = machine.succeed("sha256sum /etc/subuid /etc/subgid")
          t.assertEqual(before, after, "strict mode must not modify files on failure")
          t.assertNotIn("mallory", machine.succeed("cat /etc/subuid"))
    '';
}
