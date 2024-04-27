{ config, pkgs, lib, ... }:

with lib;

{
  options.proxmox = {
    qemuConf = {
      # essential configs
      boot = mkOption {
        type = types.str;
        default = "";
        example = "order=scsi0;net0";
        description = ''
          Default boot device. PVE will try all devices in its default order if this value is empty.
        '';
      };
      scsihw = mkOption {
        type = types.str;
        default = "virtio-scsi-pci";
        example = "lsi";
        description = ''
          SCSI controller type. Must be one of the supported values given in
          <https://pve.proxmox.com/wiki/Qemu/KVM_Virtual_Machines>
        '';
      };
      virtio0 = mkOption {
        type = types.str;
        default = "local-lvm:vm-9999-disk-0";
        example = "ceph:vm-123-disk-0";
        description = ''
          Configuration for the default virtio disk. It can be used as a cue for PVE to autodetect the target storage.
          This parameter is required by PVE even if it isn't used.
        '';
      };
      ostype = mkOption {
        type = types.str;
        default = "l26";
        description = ''
          Guest OS type
        '';
      };
      cores = mkOption {
        type = types.ints.positive;
        default = 1;
        description = ''
          Guest core count
        '';
      };
      memory = mkOption {
        type = types.ints.positive;
        default = 1024;
        description = ''
          Guest memory in MB
        '';
      };
      bios = mkOption {
        type = types.enum [ "seabios" "ovmf" ];
        default = "seabios";
        description = ''
          Select BIOS implementation (seabios = Legacy BIOS, ovmf = UEFI).
        '';
      };

      # optional configs
      name = mkOption {
        type = types.str;
        default = "nixos-${config.system.nixos.label}";
        description = ''
          VM name
        '';
      };
      additionalSpace = mkOption {
        type = types.str;
        default = "512M";
        example = "2048M";
        description = ''
          additional disk space to be added to the image if diskSize "auto"
          is used.
        '';
      };
      bootSize = mkOption {
        type = types.str;
        default = "256M";
        example = "512M";
        description = ''
          Size of the boot partition. Is only used if partitionTableType is
          either "efi" or "hybrid".
        '';
      };
      diskSize = mkOption {
        type = types.str;
        default = "auto";
        example = "20480";
        description = ''
          The size of the disk, in megabytes.
          if "auto" size is calculated based on the contents copied to it and
          additionalSpace is taken into account.
        '';
      };
      net0 = mkOption {
        type = types.commas;
        default = "virtio=00:00:00:00:00:00,bridge=vmbr0,firewall=1";
        description = ''
          Configuration for the default interface. When restoring from VMA, check the
          "unique" box to ensure device mac is randomized.
        '';
      };
      serial0 = mkOption {
        type = types.str;
        default = "socket";
        example = "/dev/ttyS0";
        description = ''
          Create a serial device inside the VM (n is 0 to 3), and pass through a host serial device (i.e. /dev/ttyS0),
          or create a unix socket on the host side (use qm terminal to open a terminal connection).
        '';
      };
      agent = mkOption {
        type = types.bool;
        apply = x: if x then "1" else "0";
        default = true;
        description = ''
          Expect guest to have qemu agent running
        '';
      };
    };
    qemuExtraConf = mkOption {
      type = with types; attrsOf (oneOf [ str int ]);
      default = {};
      example = literalExpression ''
        {
          cpu = "host";
          onboot = 1;
        }
      '';
      description = ''
        Additional options appended to qemu-server.conf
      '';
    };
    partitionTableType = mkOption {
      type = types.enum [ "efi" "hybrid" "legacy" "legacy+gpt" ];
      description = ''
        Partition table type to use. See make-disk-image.nix partitionTableType for details.
        Defaults to 'legacy' for 'proxmox.qemuConf.bios="seabios"' (default), other bios values defaults to 'efi'.
        Use 'hybrid' to build grub-based hybrid bios+efi images.
      '';
      default = if config.proxmox.qemuConf.bios == "seabios" then "legacy" else "efi";
      defaultText = lib.literalExpression ''if config.proxmox.qemuConf.bios == "seabios" then "legacy" else "efi"'';
      example = "hybrid";
    };
    filenameSuffix = mkOption {
      type = types.str;
      default = config.proxmox.qemuConf.name;
      example = "999-nixos_template";
      description = ''
        Filename of the image will be vzdump-qemu-''${filenameSuffix}.vma.zstd.
        This will also determine the default name of the VM on restoring the VMA.
        Start this value with a number if you want the VMA to be detected as a backup of
        any specific VMID.
      '';
    };
  };

  config = let
    cfg = config.proxmox;
    cfgLine = name: value: ''
      ${name}: ${builtins.toString value}
    '';
    virtio0Storage = builtins.head (builtins.split ":" cfg.qemuConf.virtio0);
    cfgFile = fileName: properties: pkgs.writeTextDir fileName ''
      # generated by NixOS
      ${lib.concatStrings (lib.mapAttrsToList cfgLine properties)}
      #qmdump#map:virtio0:drive-virtio0:${virtio0Storage}:raw:
    '';
    inherit (cfg) partitionTableType;
    supportEfi = partitionTableType == "efi" || partitionTableType == "hybrid";
    supportBios = partitionTableType == "legacy" || partitionTableType == "hybrid" || partitionTableType == "legacy+gpt";
    hasBootPartition = partitionTableType == "efi" || partitionTableType == "hybrid";
    hasNoFsPartition = partitionTableType == "hybrid" || partitionTableType == "legacy+gpt";
  in {
    assertions = [
      {
        assertion = config.boot.loader.systemd-boot.enable -> config.proxmox.qemuConf.bios == "ovmf";
        message = "systemd-boot requires 'ovmf' bios";
      }
      {
        assertion = partitionTableType == "efi" -> config.proxmox.qemuConf.bios == "ovmf";
        message = "'efi' disk partitioning requires 'ovmf' bios";
      }
      {
        assertion = partitionTableType == "legacy" -> config.proxmox.qemuConf.bios == "seabios";
        message = "'legacy' disk partitioning requires 'seabios' bios";
      }
      {
        assertion = partitionTableType == "legacy+gpt" -> config.proxmox.qemuConf.bios == "seabios";
        message = "'legacy+gpt' disk partitioning requires 'seabios' bios";
      }
    ];
    system.build.VMA = import ../../lib/make-disk-image.nix {
      name = "proxmox-${cfg.filenameSuffix}";
      inherit (cfg) partitionTableType;
      postVM = let
        # Build qemu with PVE's patch that adds support for the VMA format
        vma = (pkgs.qemu_kvm.override {
          alsaSupport = false;
          pulseSupport = false;
          sdlSupport = false;
          jackSupport = false;
          gtkSupport = false;
          vncSupport = false;
          smartcardSupport = false;
          spiceSupport = false;
          ncursesSupport = false;
          libiscsiSupport = false;
          tpmSupport = false;
          numaSupport = false;
          seccompSupport = false;
          guestAgentSupport = false;
        }).overrideAttrs ( super: rec {
          # Check https://github.com/proxmox/pve-qemu/tree/master for the version
          # of qemu and patch to use
          version = "8.1.5";
          src = pkgs.fetchurl {
            url = "https://download.qemu.org/qemu-${version}.tar.xz";
            hash = "sha256-l2Ox7+xP1JeWtQgNCINRLXDLY4nq1lxmHMNoalIjKJY=";
          };
          patches = [
            # Proxmox' VMA tool is published as a particular patch upon QEMU
            "${pkgs.fetchFromGitHub {
              owner = "proxmox";
              repo = "pve-qemu";
              rev = "71dd2d48f9122e60e4c0a8480122a27aab15dc70";
              hash = "sha256-Q8AxNv4geDdlbVIWphRO5P3ESo0SGgvUpVPmPJzubJM=";
            }}/debian/patches/pve/0027-PVE-Backup-add-vma-backup-format-code.patch"
          ];

          buildInputs = super.buildInputs ++ [ pkgs.libuuid ];
          nativeBuildInputs = super.nativeBuildInputs ++ [ pkgs.perl ];

        });
      in
      ''
        ${vma}/bin/vma create "vzdump-qemu-${cfg.filenameSuffix}.vma" \
          -c ${cfgFile "qemu-server.conf" (cfg.qemuConf // cfg.qemuExtraConf)}/qemu-server.conf drive-virtio0=$diskImage
        rm $diskImage
        ${pkgs.zstd}/bin/zstd "vzdump-qemu-${cfg.filenameSuffix}.vma"
        mv "vzdump-qemu-${cfg.filenameSuffix}.vma.zst" $out/

        mkdir -p $out/nix-support
        echo "file vma $out/vzdump-qemu-${cfg.filenameSuffix}.vma.zst" > $out/nix-support/hydra-build-products
      '';
      inherit (cfg.qemuConf) additionalSpace diskSize bootSize;
      format = "raw";
      inherit config lib pkgs;
    };

    boot = {
      growPartition = true;
      kernelParams = [ "console=ttyS0" ];
      loader.grub = {
        device = lib.mkDefault (if (hasNoFsPartition || supportBios) then
          # Even if there is a separate no-fs partition ("/dev/disk/by-partlabel/no-fs" i.e. "/dev/vda2"),
          # which will be used the bootloader, do not set it as loader.grub.device.
          # GRUB installation fails, unless the whole disk is selected.
          "/dev/vda"
        else
          "nodev");
        efiSupport = lib.mkDefault supportEfi;
        efiInstallAsRemovable = lib.mkDefault supportEfi;
      };

      loader.timeout = 0;
      initrd.availableKernelModules = [ "uas" "virtio_blk" "virtio_pci" ];
    };

    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      autoResize = true;
      fsType = "ext4";
    };
    fileSystems."/boot" = lib.mkIf hasBootPartition {
      device = "/dev/disk/by-label/ESP";
      fsType = "vfat";
    };

    services.qemuGuest.enable = lib.mkDefault true;
  };
}
