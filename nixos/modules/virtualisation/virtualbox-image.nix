{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.virtualbox;

in {

  options = {
    virtualbox = {
      baseImageSize = mkOption {
        type = types.int;
        default = 50 * 1024;
        description = ''
          The size of the VirtualBox base image in MiB.
        '';
      };
      memorySize = mkOption {
        type = types.int;
        default = 1536;
        description = ''
          The amount of RAM the VirtualBox appliance can use in MiB.
        '';
      };
      vmDerivationName = mkOption {
        type = types.str;
        default = "nixos-ova-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}";
        description = ''
          The name of the derivation for the VirtualBox appliance.
        '';
      };
      vmName = mkOption {
        type = types.str;
        default = "NixOS ${config.system.nixos.label} (${pkgs.stdenv.hostPlatform.system})";
        description = ''
          The name of the VirtualBox appliance.
        '';
      };
      vmFileName = mkOption {
        type = types.str;
        default = "nixos-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}.ova";
        description = ''
          The file name of the VirtualBox appliance.
        '';
      };
    };
  };

  config = {
    system.build.virtualBoxOVA = import ../../lib/make-disk-image.nix {
      name = cfg.vmDerivationName;

      inherit pkgs lib config;
      partitionTableType = "legacy";
      diskSize = cfg.baseImageSize;

      postVM =
        ''
          export HOME=$PWD
          export PATH=${pkgs.virtualbox}/bin:$PATH

          echo "creating VirtualBox pass-through disk wrapper (no copying involved)..."
          VBoxManage internalcommands createrawvmdk -filename disk.vmdk -rawdisk $diskImage

          echo "creating VirtualBox VM..."
          vmName="${cfg.vmName}";
          VBoxManage createvm --name "$vmName" --register \
            --ostype ${if pkgs.stdenv.hostPlatform.system == "x86_64-linux" then "Linux26_64" else "Linux26"}
          VBoxManage modifyvm "$vmName" \
            --memory ${toString cfg.memorySize} --acpi on --vram 32 \
            ${optionalString (pkgs.stdenv.hostPlatform.system == "i686-linux") "--pae on"} \
            --nictype1 virtio --nic1 nat \
            --audiocontroller ac97 --audio alsa --audioout on \
            --rtcuseutc on \
            --usb on --usbehci on --mouse usbtablet
          VBoxManage storagectl "$vmName" --name SATA --add sata --portcount 4 --bootable on --hostiocache on
          VBoxManage storageattach "$vmName" --storagectl SATA --port 0 --device 0 --type hdd \
            --medium disk.vmdk

          echo "exporting VirtualBox VM..."
          mkdir -p $out
          fn="$out/${cfg.vmFileName}"
          VBoxManage export "$vmName" --output "$fn" --options manifest

          rm -v $diskImage

          mkdir -p $out/nix-support
          echo "file ova $fn" >> $out/nix-support/hydra-build-products
        '';
    };

    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      autoResize = true;
      fsType = "ext4";
    };

    boot.growPartition = true;
    boot.loader.grub.device = "/dev/sda";

    swapDevices = [{
      device = "/var/swap";
      size = 2048;
    }];

    virtualisation.virtualbox.guest.enable = true;

  };
}
