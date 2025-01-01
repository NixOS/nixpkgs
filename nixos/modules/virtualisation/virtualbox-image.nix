{ config, lib, pkgs, ... }:
let

  cfg = config.virtualbox;

in {

  options = {
    virtualbox = {
      baseImageSize = lib.mkOption {
        type = with lib.types; either (enum [ "auto" ]) int;
        default = "auto";
        example = 50 * 1024;
        description = ''
          The size of the VirtualBox base image in MiB.
        '';
      };
      baseImageFreeSpace = lib.mkOption {
        type = with lib.types; int;
        default = 30 * 1024;
        description = ''
          Free space in the VirtualBox base image in MiB.
        '';
      };
      memorySize = lib.mkOption {
        type = lib.types.int;
        default = 1536;
        description = ''
          The amount of RAM the VirtualBox appliance can use in MiB.
        '';
      };
      vmDerivationName = lib.mkOption {
        type = lib.types.str;
        default = "nixos-ova-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}";
        description = ''
          The name of the derivation for the VirtualBox appliance.
        '';
      };
      vmName = lib.mkOption {
        type = lib.types.str;
        default = "${config.system.nixos.distroName} ${config.system.nixos.label} (${pkgs.stdenv.hostPlatform.system})";
        description = ''
          The name of the VirtualBox appliance.
        '';
      };
      vmFileName = lib.mkOption {
        type = lib.types.str;
        default = "nixos-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}.ova";
        description = ''
          The file name of the VirtualBox appliance.
        '';
      };
      params = lib.mkOption {
        type = with lib.types; attrsOf (oneOf [ str int bool (listOf str) ]);
        example = {
          audio = "alsa";
          rtcuseutc = "on";
          usb = "off";
        };
        description = ''
          Parameters passed to the Virtualbox appliance.

          Run `VBoxManage modifyvm --help` to see more options.
        '';
      };
      exportParams = lib.mkOption {
        type = with lib.types; listOf (oneOf [ str int bool (listOf str) ]);
        example = [
          "--vsys" "0" "--vendor" "ACME Inc."
        ];
        default = [];
        description = ''
          Parameters passed to the Virtualbox export command.

          Run `VBoxManage export --help` to see more options.
        '';
      };
      extraDisk = lib.mkOption {
        description = ''
          Optional extra disk/hdd configuration.
          The disk will be an 'ext4' partition on a separate file.
        '';
        default = null;
        example = {
          label = "storage";
          mountPoint = "/home/demo/storage";
          size = 100 * 1024;
        };
        type = lib.types.nullOr (lib.types.submodule {
          options = {
            size = lib.mkOption {
              type = lib.types.int;
              description = "Size in MiB";
            };
            label = lib.mkOption {
              type = lib.types.str;
              default = "vm-extra-storage";
              description = "Label for the disk partition";
            };
            mountPoint = lib.mkOption {
              type = lib.types.str;
              description = "Path where to mount this disk.";
            };
          };
        });
      };
      postExportCommands = lib.mkOption {
        type = lib.types.lines;
        default = "";
        example = ''
          ${pkgs.cot}/bin/cot edit-hardware "$fn" \
            -v vmx-14 \
            --nics 2 \
            --nic-types VMXNET3 \
            --nic-names 'Nic name' \
            --nic-networks 'Nic match' \
            --network-descriptions 'Nic description' \
            --scsi-subtypes VirtualSCSI
        '';
        description = ''
          Extra commands to run after exporting the OVA to `$fn`.
        '';
      };
      storageController = lib.mkOption {
        type = with lib.types; attrsOf (oneOf [ str int bool (listOf str) ]);
        example = {
          name = "SCSI";
          add = "scsi";
          portcount = 16;
          bootable = "on";
          hostiocache = "on";
        };
        default = {
          name = "SATA";
          add = "sata";
          portcount = 4;
          bootable = "on";
          hostiocache = "on";
        };
        description = ''
          Parameters passed to the VirtualBox appliance. Must have at least
          `name`.

          Run `VBoxManage storagectl --help` to see more options.
        '';
      };
    };
  };

  config = {

    virtualbox.params = lib.mkMerge [
      (lib.mapAttrs (name: lib.mkDefault) {
        acpi = "on";
        vram = 32;
        nictype1 = "virtio";
        nic1 = "nat";
        audiocontroller = "ac97";
        audio = "alsa";
        audioout = "on";
        graphicscontroller = "vmsvga";
        rtcuseutc = "on";
        usb = "on";
        usbehci = "on";
        mouse = "usbtablet";
      })
      (lib.mkIf (pkgs.stdenv.hostPlatform.system == "i686-linux") { pae = "on"; })
    ];

    system.build.virtualBoxOVA = import ../../lib/make-disk-image.nix {
      name = cfg.vmDerivationName;

      inherit pkgs lib config;
      partitionTableType = "legacy";
      diskSize = cfg.baseImageSize;
      additionalSpace = "${toString cfg.baseImageFreeSpace}M";

      postVM =
        ''
          export HOME=$PWD
          export PATH=${pkgs.virtualbox}/bin:$PATH

          echo "converting image to VirtualBox format..."
          VBoxManage convertfromraw $diskImage disk.vdi

          ${lib.optionalString (cfg.extraDisk != null) ''
            echo "creating extra disk: data-disk.raw"
            dataDiskImage=data-disk.raw
            truncate -s ${toString cfg.extraDisk.size}M $dataDiskImage

            parted --script $dataDiskImage -- \
              mklabel msdos \
              mkpart primary ext4 1MiB -1
            eval $(partx $dataDiskImage -o START,SECTORS --nr 1 --pairs)
            mkfs.ext4 -F -L ${cfg.extraDisk.label} $dataDiskImage -E offset=$(sectorsToBytes $START) $(sectorsToKilobytes $SECTORS)K
            echo "creating extra disk: data-disk.vdi"
            VBoxManage convertfromraw $dataDiskImage data-disk.vdi
          ''}

          echo "creating VirtualBox VM..."
          vmName="${cfg.vmName}";
          VBoxManage createvm --name "$vmName" --register \
            --ostype ${if pkgs.stdenv.hostPlatform.system == "x86_64-linux" then "Linux26_64" else "Linux26"}
          VBoxManage modifyvm "$vmName" \
            --memory ${toString cfg.memorySize} \
            ${lib.cli.toGNUCommandLineShell { } cfg.params}
          VBoxManage storagectl "$vmName" ${lib.cli.toGNUCommandLineShell { } cfg.storageController}
          VBoxManage storageattach "$vmName" --storagectl ${cfg.storageController.name} --port 0 --device 0 --type hdd \
            --medium disk.vdi
          ${lib.optionalString (cfg.extraDisk != null) ''
            VBoxManage storageattach "$vmName" --storagectl ${cfg.storageController.name} --port 1 --device 0 --type hdd \
            --medium data-disk.vdi
          ''}

          echo "exporting VirtualBox VM..."
          mkdir -p $out
          fn="$out/${cfg.vmFileName}"
          VBoxManage export "$vmName" --output "$fn" --options manifest ${lib.escapeShellArgs cfg.exportParams}
          ${cfg.postExportCommands}

          rm -v $diskImage

          mkdir -p $out/nix-support
          echo "file ova $fn" >> $out/nix-support/hydra-build-products
        '';
    };

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-label/nixos";
        autoResize = true;
        fsType = "ext4";
      };
    } // (lib.optionalAttrs (cfg.extraDisk != null) {
      ${cfg.extraDisk.mountPoint} = {
        device = "/dev/disk/by-label/" + cfg.extraDisk.label;
        autoResize = true;
        fsType = "ext4";
      };
    });

    boot.growPartition = true;
    boot.loader.grub.device = "/dev/sda";

    swapDevices = [{
      device = "/var/swap";
      size = 2048;
    }];

    virtualisation.virtualbox.guest.enable = true;

  };
}
