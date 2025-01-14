{ lib, ... }: {

  name = "activation-etc-overlay-mutable";

  meta.maintainers = with lib.maintainers; [ nikstur ];

  nodes.machine = { pkgs, ... }: {
    system.etc.overlay.enable = true;
    system.etc.overlay.mutable = true;

    # Prerequisites
    boot.initrd.systemd.enable = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;

    specialisation.new-generation.configuration = {
      environment.etc."newgen".text = "newgen";
    };
  };

  testScript = ''
    with subtest("/etc is mounted as an overlay"):
      machine.succeed("findmnt --kernel --type overlay /etc")

    with subtest("switching to the same generation"):
      machine.succeed("/run/current-system/bin/switch-to-configuration test")

    with subtest("switching to a new generation"):
      machine.fail("stat /etc/newgen")
      machine.succeed("echo -n 'mutable' > /etc/mutable")

      # Directory
      machine.succeed("mkdir /etc/mountpoint")
      machine.succeed("mount -t tmpfs tmpfs /etc/mountpoint")
      machine.succeed("touch /etc/mountpoint/extra-file")

      # File
      machine.succeed("touch /etc/filemount")
      machine.succeed("mount --bind /dev/null /etc/filemount")

      machine.succeed("/run/current-system/specialisation/new-generation/bin/switch-to-configuration switch")

      assert machine.succeed("cat /etc/newgen") == "newgen"
      assert machine.succeed("cat /etc/mutable") == "mutable"

      print(machine.succeed("findmnt /etc/mountpoint"))
      print(machine.succeed("stat /etc/mountpoint/extra-file"))
      print(machine.succeed("findmnt /etc/filemount"))
  '';
}
