{ lib, ... }:
{

  name = "nix-store-veritysetup";

  meta.maintainers = with lib.maintainers; [ nikstur ];

  nodes.machine =
    { config, modulesPath, ... }:
    {

      imports = [
        "${modulesPath}/image/repart.nix"
      ];

      image.repart = {
        name = "nix-store";
        partitions = {
          "nix-store" = {
            storePaths = [ config.system.build.toplevel ];
            nixStorePrefix = "/";
            repartConfig = {
              Type = "linux-generic";
              Label = "nix-store";
              Format = "erofs";
              Minimize = "best";
              Verity = "data";
              VerityMatchKey = "nix-store";
            };
          };
          "nix-store-verity" = {
            repartConfig = {
              Type = "linux-generic";
              Label = "nix-store-verity";
              Verity = "hash";
              VerityMatchKey = "nix-store";
              Minimize = "best";
            };
          };
        };
      };

      boot.initrd = {
        systemd = {
          enable = true;
          dmVerity.enable = true;
        };
        nix-store-veritysetup.enable = true;
      };

      virtualisation = {
        mountHostNixStore = false;
        qemu.drives = [
          {
            name = "nix-store";
            file = ''"$NIX_STORE"'';
          }
        ];
        fileSystems = {
          "/nix/store" = {
            fsType = "erofs";
            device = "/dev/mapper/nix-store";
          };
        };
      };

    };

  testScript =
    { nodes, ... }:
    ''
      import os
      import json
      import subprocess
      import tempfile

      with open("${nodes.machine.system.build.image}/repart-output.json") as f:
        data = json.load(f)

      storehash = data[0]["roothash"]

      os.environ["QEMU_KERNEL_PARAMS"] = f"storehash={storehash}"

      tmp_disk_image = tempfile.NamedTemporaryFile()

      subprocess.run([
        "${nodes.machine.virtualisation.qemu.package}/bin/qemu-img",
        "create",
        "-f",
        "qcow2",
        "-b",
        "${nodes.machine.system.build.image}/${nodes.machine.image.fileName}",
        "-F",
        "raw",
        tmp_disk_image.name,
      ])

      os.environ["NIX_STORE"] = tmp_disk_image.name

      machine.start()

      print(machine.succeed("findmnt"))
      print(machine.succeed("dmsetup info nix-store"))

      machine.wait_for_unit("multi-user.target")
    '';

}
