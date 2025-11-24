{ lib, pkgs, ... }:

{
  name = "nixos-init";

  meta.maintainers = with lib.maintainers; [ nikstur ];

  nodes.machine =
    { modulesPath, ... }:
    {
      boot.initrd.systemd.enable = true;
      system.etc.overlay.enable = true;
      services.userborn.enable = true;

      system.nixos-init.enable = true;
      # Forcibly set this to only these specific values.
      boot.nixStoreMountOpts = lib.mkForce [
        "nodev"
        "nosuid"
      ];
    };

  testScript =
    { nodes, ... }: # python
    ''
      with subtest("init"):
        with subtest("/nix/store is mounted with the correct options"):
          findmnt_output = machine.succeed("findmnt --direction backward --first-only --noheadings --output OPTIONS /nix/store").strip()
          print(findmnt_output)
          t.assertIn("nodev", findmnt_output)
          t.assertIn("nosuid", findmnt_output)

        t.assertEqual("${nodes.machine.system.build.toplevel}", machine.succeed("readlink /run/booted-system").strip())

      with subtest("activation"):
        t.assertEqual("${nodes.machine.system.build.toplevel}", machine.succeed("readlink /run/current-system").strip())
        t.assertEqual("${nodes.machine.hardware.firmware}/lib/firmware", machine.succeed("cat /sys/module/firmware_class/parameters/path").strip())
        t.assertEqual("${pkgs.kmod}/bin/modprobe", machine.succeed("cat /proc/sys/kernel/modprobe").strip())
        t.assertEqual("${nodes.machine.environment.usrbinenv}", machine.succeed("readlink /usr/bin/env").strip())
        t.assertEqual("${nodes.machine.environment.binsh}", machine.succeed("readlink /bin/sh").strip())

      machine.wait_for_unit("multi-user.target")
      with subtest("systemd state passing"):
        systemd_analyze_output = machine.succeed("systemd-analyze")
        print(systemd_analyze_output)
        t.assertIn("(initrd)", systemd_analyze_output, "systemd-analyze has no information about the initrd")

        ps_output = machine.succeed("ps ax -o command | grep systemd | head -n 1")
        print(ps_output)
        t.assertIn("--deserialize", ps_output, "--deserialize flag wasn't passed to systemd")
    '';
}
