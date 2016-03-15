{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.virtualbox;

in {

  options = {
    virtualbox = {
      baseImageSize = mkOption {
        type = types.int;
        default = 10 * 1024;
        description = ''
          The size of the VirtualBox base image in MiB.
        '';
      };
    };
  };

  config = {

    system.build.virtualBoxOVA = import ../../lib/make-disk-image.nix {
      name = "nixos-ova-${config.system.nixosLabel}-${pkgs.stdenv.system}";

      inherit pkgs lib config;
      partitioned = true;
      diskSize = cfg.baseImageSize;

      configFile = pkgs.writeText "configuration.nix"
        ''
          {
            imports = [ <nixpkgs/nixos/modules/virtualisation/virtualbox-image.nix> ];
          }
        '';

      postVM =
        ''
          echo "creating VirtualBox disk image..."
          ${pkgs.vmTools.qemu}/bin/qemu-img convert -f raw -O vdi $diskImage disk.vdi
          rm $diskImage

          echo "creating VirtualBox VM..."
          export HOME=$PWD
          export PATH=${pkgs.linuxPackages.virtualbox}/bin:$PATH
          vmName="NixOS ${config.system.nixosLabel} (${pkgs.stdenv.system})"
          VBoxManage createvm --name "$vmName" --register \
            --ostype ${if pkgs.stdenv.system == "x86_64-linux" then "Linux26_64" else "Linux26"}
          VBoxManage modifyvm "$vmName" \
            --memory 1536 --acpi on --vram 32 \
            ${optionalString (pkgs.stdenv.system == "i686-linux") "--pae on"} \
            --nictype1 virtio --nic1 nat \
            --audiocontroller ac97 --audio alsa \
            --rtcuseutc on \
            --usb on --mouse usbtablet
          VBoxManage storagectl "$vmName" --name SATA --add sata --portcount 4 --bootable on --hostiocache on
          VBoxManage storageattach "$vmName" --storagectl SATA --port 0 --device 0 --type hdd \
            --medium disk.vdi

          echo "exporting VirtualBox VM..."
          mkdir -p $out
          fn="$out/nixos-${config.system.nixosLabel}-${pkgs.stdenv.system}.ova"
          VBoxManage export "$vmName" --output "$fn"

          mkdir -p $out/nix-support
          echo "file ova $fn" >> $out/nix-support/hydra-build-products
        '';
    };

    fileSystems."/".device = "/dev/disk/by-label/nixos";

    boot.loader.grub.device = "/dev/sda";

    virtualisation.virtualbox.guest.enable = true;

  };
}
