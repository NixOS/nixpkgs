{ lib, ... }:

# /etc/sub{u,g}id with userborn writing to a custom passwordFilesLocation
# while /etc itself is mutable (no overlay). Exercises the bind-mount path
# without relying on the etc-overlay placeholder mechanism.

{
  name = "userborn-subids-custom-location";

  meta.maintainers = with lib.maintainers; [ rvdp ];

  nodes.machine =
    { ... }:
    {
      services.userborn = {
        enable = true;
        passwordFilesLocation = "/var/lib/nixos";
      };

      users.users.alice.isNormalUser = true;

      specialisation.with-bob.configuration = {
        users.users.bob.isNormalUser = true;
      };
    };

  testScript = ''
    machine.wait_for_unit("userborn.service")

    with subtest("/etc/subuid is a regular file backed by passwordFilesLocation"):
        assert machine.succeed("stat -c '%F' /etc/subuid").strip() == "regular file"
        machine.succeed("mountpoint -q /etc/subuid")
        a = machine.succeed("stat -c %d:%i /etc/subuid").strip()
        b = machine.succeed("stat -c %d:%i /var/lib/nixos/subuid").strip()
        assert a == b

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

    with subtest("alice's range survived and bob was added"):
        after = machine.succeed("cat /etc/subuid")
        assert "alice:" in after and "bob:" in after
        for line in before.splitlines():
            assert line in after

    with subtest("newuidmap still works after the swap"):
        machine.succeed("runuser -u alice -- unshare --user --map-auto -- true")
  '';
}
