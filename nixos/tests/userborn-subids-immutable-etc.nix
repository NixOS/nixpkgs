{ lib, pkgs, ... }:

# /etc/sub{u,g}id with userborn on an immutable /etc.
# The files are written to passwordFilesLocation and bind-mounted into
# /etc so that newuidmap (which opens with O_NOFOLLOW) accepts them.

let
  common = {
    services.userborn.enable = true;
    boot.initrd.systemd.enable = true;
    networking.useNetworkd = true;
    system.etc.overlay = {
      enable = true;
      mutable = false;
    };
  };
in
{
  name = "userborn-subids-immutable-etc";

  meta.maintainers = with lib.maintainers; [ rvdp ];

  nodes.machine =
    { ... }:
    {
      imports = [ common ];

      users.users.alice.isNormalUser = true;

      specialisation.with-bob = {
        inheritParentConfig = false;
        configuration = {
          nixpkgs = { inherit pkgs; };
          imports = [ common ];
          users.users.alice.isNormalUser = true;
          users.users.bob.isNormalUser = true;
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("userborn.service")

    def parse(path):
        out = {}
        for line in machine.succeed(f"cat {path}").splitlines():
            name, start, count = line.split(":")
            out.setdefault(name, []).append((int(start), int(count)))
        return out

    with subtest("/etc/subuid is a regular file, not a symlink"):
        assert machine.succeed("stat -c '%F' /etc/subuid").strip() == "regular file"
        assert machine.succeed("stat -c '%F' /etc/subgid").strip() == "regular file"

    with subtest("/etc/subuid is bind-mounted from passwordFilesLocation"):
        machine.succeed("mountpoint -q /etc/subuid")
        # Same inode as the backing file proves the bind is in place.
        a = machine.succeed("stat -c %d:%i /etc/subuid").strip()
        b = machine.succeed("stat -c %d:%i /var/lib/nixos/subuid").strip()
        assert a == b, f"/etc/subuid {a} != /var/lib/nixos/subuid {b}"

    subuid = parse("/etc/subuid")
    with subtest("alice has an auto range"):
        (start, count), = subuid["alice"]
        assert count == 65536

    with subtest("newuidmap accepts the bind-mounted file"):
        machine.succeed("runuser -u alice -- unshare --user --map-auto -- true")

    alice_before = subuid["alice"]
    machine.succeed(
        "/run/current-system/specialisation/with-bob/bin/switch-to-configuration switch"
    )

    with subtest("bind mount is refreshed gaplessly across generations"):
        assert machine.succeed("stat -c '%F' /etc/subuid").strip() == "regular file"
        # Exactly one mount stacked on /etc/subuid (refresh popped the old).
        n = machine.succeed("grep -c ' /etc/subuid ' /proc/self/mountinfo").strip()
        assert n == "1", f"expected 1 mount on /etc/subuid, got {n}"

    subuid = parse("/etc/subuid")
    with subtest("alice's range survived the generation switch"):
        assert subuid["alice"] == alice_before

    with subtest("bob has a non-overlapping range"):
        (bstart, bcount), = subuid["bob"]
        assert not (bstart < alice_before[0][0] + alice_before[0][1]
                    and alice_before[0][0] < bstart + bcount)

    with subtest("newuidmap still works after the swap"):
        machine.succeed("runuser -u alice -- unshare --user --map-auto -- true")
  '';
}
