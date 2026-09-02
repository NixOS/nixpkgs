{ lib, pkgs, ... }:

# /etc/sub{u,g}id management via userborn.

{
  name = "userborn-subids";

  meta.maintainers = with lib.maintainers; [ rvdp ];

  nodes.machine =
    { ... }:
    {
      services.userborn.enable = true;

      users.users = {
        alice.isNormalUser = true;

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

        # Huge root range like incus sets, auto allocations must avoid it.
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

      environment.systemPackages = [ pkgs.util-linux ];

      specialisation = {
        with-bob.configuration = {
          users.users.bob.isNormalUser = true;
        };

        # Overlaps alice's auto allocation, must fail before writing.
        conflict.configuration = {
          users.users.mallory = {
            isNormalUser = true;
            subUidRanges = [
              {
                startUid = 100000;
                count = 200000;
              }
            ];
          };
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("userborn.service")

    def switch_to(spec):
        machine.succeed(
            f"/run/booted-system/specialisation/{spec}/bin/switch-to-configuration switch"
        )

    def parse(path):
        out = {}
        for line in machine.succeed(f"cat {path}").splitlines():
            name, start, count = line.split(":")
            out.setdefault(name, []).append((int(start), int(count)))
        return out

    def overlaps(a, b):
        return a[0] < b[0] + b[1] and b[0] < a[0] + a[1]

    with subtest("/etc/subuid is a plain regular file (newuidmap O_NOFOLLOW)"):
        assert machine.succeed("stat -c '%F' /etc/subuid").strip() == "regular file"
        assert machine.succeed("stat -c '%a' /etc/subuid").strip() == "644"
        machine.fail("mountpoint -q /etc/subuid")

    subuid = parse("/etc/subuid")
    subgid = parse("/etc/subgid")

    with subtest("explicit ranges are honoured verbatim"):
        assert subuid["explicit"] == [(700000, 65536)]
        assert subuid["root"] == [(1000000, 1000000000)]

    with subtest("alice gets an auto range below the root range"):
        (start, count), = subuid["alice"]
        assert count == 65536
        assert start >= 100000
        assert not overlaps((start, count), (1000000, 1000000000))
        assert subgid["alice"] == subuid["alice"]

    with subtest("newuidmap accepts the file"):
        machine.succeed(
            "runuser -u alice -- unshare --user --map-auto -- true"
        )

    alice_before = subuid["alice"]
    switch_to("with-bob")
    subuid = parse("/etc/subuid")

    with subtest("alice's range is preserved across generations"):
        assert subuid["alice"] == alice_before

    with subtest("bob's range does not overlap anything"):
        (bstart, bcount), = subuid["bob"]
        for owner, ranges in subuid.items():
            if owner == "bob":
                continue
            for r in ranges:
                assert not overlaps((bstart, bcount), r), f"bob overlaps {owner}"

    with subtest("overlapping ranges fail the service"):
        machine.fail(
            "/run/booted-system/specialisation/conflict/bin/switch-to-configuration switch"
        )
        # File must be unchanged (no mallory entry written).
        assert "mallory" not in machine.succeed("cat /etc/subuid")
  '';
}
