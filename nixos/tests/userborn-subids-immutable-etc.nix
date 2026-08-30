{ lib, pkgs, ... }:

# Immutable /etc, subid files written to passwordFilesLocation and exposed
# in /etc via systemd bind mount units over build-time placeholders.

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
  users = {
    # Auto allocation at runtime, must work on an immutable /etc.
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
  };
in
{
  name = "userborn-subids-immutable-etc";

  meta.maintainers = with lib.maintainers; [ rvdp ];

  nodes.machine =
    { ... }:
    {
      imports = [ common ];

      users.users = users;

      specialisation.with-bob = {
        inheritParentConfig = false;
        configuration = {
          nixpkgs = { inherit pkgs; };
          imports = [ common ];
          users.users = users // {
            bob.isNormalUser = true;
          };
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

    with subtest("/etc/subuid is a bind mount backed by passwordFilesLocation"):
        assert machine.succeed("stat -c '%F' /etc/subuid").strip() == "regular file"
        machine.succeed("mountpoint -q /etc/subuid")
        machine.succeed("systemctl is-active etc-subuid.mount etc-subgid.mount")
        a = machine.succeed("stat -c %d:%i /etc/subuid").strip()
        b = machine.succeed("stat -c %d:%i /var/lib/nixos/subuid").strip()
        assert a == b

    subuid = parse("/etc/subuid")
    subgid = parse("/etc/subgid")
    with subtest("alice got an auto range and explicit's range is present"):
        assert len(subuid["alice"]) == 1
        assert subuid["alice"][0][1] == 65536
        assert subuid["explicit"] == [(700000, 65536)]
        assert subgid["explicit"] == [(700000, 65536)]

    with subtest("newuidmap accepts the bind-mounted file"):
        machine.succeed("runuser -u alice -- unshare --user --map-auto -- true")

    before = machine.succeed("cat /etc/subuid")
    machine.succeed(
        "/run/current-system/specialisation/with-bob/bin/switch-to-configuration switch"
    )

    with subtest("bind is refreshed across activations without stacking"):
        n = machine.succeed("grep -c ' /etc/subuid ' /proc/self/mountinfo").strip()
        assert n == "1", f"expected 1 mount on /etc/subuid, got {n}"
        a = machine.succeed("stat -c %d:%i /etc/subuid").strip()
        b = machine.succeed("stat -c %d:%i /var/lib/nixos/subuid").strip()
        assert a == b

    with subtest("existing ranges survived and bob was added"):
        after = machine.succeed("cat /etc/subuid")
        assert "bob:" in after
        for line in before.splitlines():
            assert line in after

    with subtest("newuidmap still works after the switch"):
        machine.succeed("runuser -u alice -- unshare --user --map-auto -- true")
  '';
}
