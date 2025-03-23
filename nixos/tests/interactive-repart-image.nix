# Tests building and running an interactive image with repart.

{ lib, ... }:

let
  common = {
    imports = [ ../modules/image/interactive.nix ];

    # These options serve to make it properly boot from the provided image.
    virtualisation = {
      directBoot.enable = false;
      mountHostNixStore = false;
      useEFIBoot = true;
      fileSystems = lib.mkForce {
        "/" = {
          device = "/dev/disk/by-partlabel/root";
          fsType = "ext4";
        };
      };
    };

    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    system.switch.enable = true;

  };
in
{
  name = "interactive-repart-image";

  meta.maintainers = with lib.maintainers; [ nikstur ];

  nodes = {
    machine =
      { nodes, ... }:
      {
        imports = [ common ];
        system.extraDependencies = [ nodes.new.system.build.toplevel ];
      };

    new = {
      imports = [ common ];
      system.name = "new";
    };
  };

  testScript =
    { nodes, ... }:
    ''
      import os
      import subprocess
      import tempfile

      tmp_disk_image = tempfile.NamedTemporaryFile()

      subprocess.run([
        "${nodes.machine.virtualisation.qemu.package}/bin/qemu-img",
        "create",
        "-f",
        "qcow2",
        "-b",
        "${nodes.machine.system.build.image}/${nodes.machine.image.repart.imageFile}",
        "-F",
        "raw",
        tmp_disk_image.name,
      ])

      # Set NIX_DISK_IMAGE so that the qemu script finds the right disk image.
      os.environ['NIX_DISK_IMAGE'] = tmp_disk_image.name

      # Before switching (and thus creating new boot loader entries) this path shouldn't exist
      machine.fail("stat /efi/EFI/nixos")

      machine.succeed("nix-env -p /nix/var/nix/profiles/system --set ${nodes.new.system.build.toplevel}")
      machine.succeed("${nodes.new.system.build.toplevel}/bin/switch-to-configuration boot")

      # After switching there should be three files in here, an initrd and a
      # kernel from the initial generation and a new initrd from the new
      # generation.
      files_on_esp = machine.succeed("ls -1 /efi/EFI/nixos/").strip()
      number_of_files = len(files_on_esp.splitlines())

      print(files_on_esp)
      print(number_of_files)

      assert number_of_files == 3
    '';
}
