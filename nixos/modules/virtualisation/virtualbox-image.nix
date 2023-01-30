{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.virtualbox;

in {

  options = {
    virtualbox = {
      baseImageSize = mkOption {
        type = with types; either (enum [ "auto" ]) int;
        default = "auto";
        example = 50 * 1024;
        description = lib.mdDoc ''
          The size of the VirtualBox base image in MiB.
        '';
      };
      baseImageFreeSpace = mkOption {
        type = with types; int;
        default = 30 * 1024;
        description = lib.mdDoc ''
          Free space in the VirtualBox base image in MiB.
        '';
      };
      memorySize = mkOption {
        type = types.int;
        default = 1536;
        description = lib.mdDoc ''
          The amount of RAM the VirtualBox appliance can use in MiB.
        '';
      };
      vmDerivationName = mkOption {
        type = types.str;
        default = "nixos-ova-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}";
        description = lib.mdDoc ''
          The name of the derivation for the VirtualBox appliance.
        '';
      };
      vmName = mkOption {
        type = types.str;
        default = "${config.system.nixos.distroName} ${config.system.nixos.label} (${pkgs.stdenv.hostPlatform.system})";
        description = lib.mdDoc ''
          The name of the VirtualBox appliance.
        '';
      };
      vmFileName = mkOption {
        type = types.str;
        default = "nixos-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}.ova";
        description = lib.mdDoc ''
          The file name of the VirtualBox appliance.
        '';
      };
      params = mkOption {
        type = with types; attrsOf (oneOf [ str int bool (listOf str) ]);
        example = {
          audio = "alsa";
          rtcuseutc = "on";
          usb = "off";
        };
        description = lib.mdDoc ''
          Parameters passed to the Virtualbox appliance.

          Run `VBoxManage modifyvm --help` to see more options.
        '';
      };
      exportParams = mkOption {
        type = with types; listOf (oneOf [ str int bool (listOf str) ]);
        example = [
          "--vsys" "0" "--vendor" "ACME Inc."
        ];
        default = [];
        description = lib.mdDoc ''
          Parameters passed to the Virtualbox export command.

          Run `VBoxManage export --help` to see more options.
        '';
      };
      extraDisk = mkOption {
        description = lib.mdDoc ''
          Optional extra disk/hdd configuration.
          The disk will be an 'ext4' partition on a separate VMDK file.
        '';
        default = null;
        example = {
          label = "storage";
          mountPoint = "/home/demo/storage";
          size = 100 * 1024;
        };
        type = types.nullOr (types.submodule {
          options = {
            size = mkOption {
              type = types.int;
              description = lib.mdDoc "Size in MiB";
            };
            label = mkOption {
              type = types.str;
              default = "vm-extra-storage";
              description = lib.mdDoc "Label for the disk partition";
            };
            mountPoint = mkOption {
              type = types.str;
              description = lib.mdDoc "Path where to mount this disk.";
            };
          };
        });
      };
    };
  };

  config = {

    virtualbox.params = mkMerge [
      (mapAttrs (name: mkDefault) {
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
      (mkIf (pkgs.stdenv.hostPlatform.system == "i686-linux") { pae = "on"; })
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

          echo "creating VirtualBox pass-through disk wrapper (no copying involved)..."
          VBoxManage internalcommands createrawvmdk -filename disk.vmdk -rawdisk $diskImage

          ${optionalString (cfg.extraDisk != null) ''
            echo "creating extra disk: data-disk.raw"
            dataDiskImage=data-disk.raw
            truncate -s ${toString cfg.extraDisk.size}M $dataDiskImage

            parted --script $dataDiskImage -- \
              mklabel msdos \
              mkpart primary ext4 1MiB -1
            eval $(partx $dataDiskImage -o START,SECTORS --nr 1 --pairs)
            mkfs.ext4 -F -L ${cfg.extraDisk.label} $dataDiskImage -E offset=$(sectorsToBytes $START) $(sectorsToKilobytes $SECTORS)K
            echo "creating extra disk: data-disk.vmdk"
            VBoxManage internalcommands createrawvmdk -filename data-disk.vmdk -rawdisk $dataDiskImage
          ''}

          echo "creating VirtualBox VM..."
          vmName="${cfg.vmName}";
          VBoxManage createvm --name "$vmName" --register \
            --ostype ${if pkgs.stdenv.hostPlatform.system == "x86_64-linux" then "Linux26_64" else "Linux26"}
          VBoxManage modifyvm "$vmName" \
            --memory ${toString cfg.memorySize} \
            ${lib.cli.toGNUCommandLineShell { } cfg.params}
          VBoxManage storagectl "$vmName" --name SATA --add sata --portcount 4 --bootable on --hostiocache on
          VBoxManage storageattach "$vmName" --storagectl SATA --port 0 --device 0 --type hdd \
            --medium disk.vmdk
          ${optionalString (cfg.extraDisk != null) ''
            VBoxManage storageattach "$vmName" --storagectl SATA --port 1 --device 0 --type hdd \
            --medium data-disk.vmdk
          ''}

          echo "exporting VirtualBox VM..."
          mkdir -p $out
          fn="$out/${cfg.vmFileName}"
          VBoxManage export "$vmName" --output "$fn" --options manifest ${escapeShellArgs cfg.exportParams}

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
