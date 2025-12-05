# This module creates netboot media containing the given NixOS
# configuration.

{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

with lib;

{
  imports = [
    ../../image/file-options.nix
  ];

  options = {

    netboot.squashfsCompression = mkOption {
      default = "zstd -Xcompression-level 19";
      description = ''
        Compression settings to use for the squashfs nix store.
      '';
      example = "zstd -Xcompression-level 6";
      type = types.str;
    };

    netboot.storeContents = mkOption {
      example = literalExpression "[ pkgs.stdenv ]";
      description = ''
        This option lists additional derivations to be included in the
        Nix store in the generated netboot image.
      '';
    };

  };

  config = {
    # Don't build the GRUB menu builder script, since we don't need it
    # here and it causes a cyclic dependency.
    boot.loader.grub.enable = false;

    fileSystems."/" = mkImageMediaOverride {
      fsType = "tmpfs";
      options = [ "mode=0755" ];
    };

    # In stage 1, mount a tmpfs on top of /nix/store (the squashfs
    # image) to make this a live CD.
    fileSystems."/nix/.ro-store" = mkImageMediaOverride {
      fsType = "squashfs";
      device = "../nix-store.squashfs";
      options = [
        "loop"
      ]
      ++ lib.optional (config.boot.kernelPackages.kernel.kernelAtLeast "6.2") "threads=multi";
      neededForBoot = true;
    };

    fileSystems."/nix/.rw-store" = mkImageMediaOverride {
      fsType = "tmpfs";
      options = [ "mode=0755" ];
      neededForBoot = true;
    };

    fileSystems."/nix/store" = mkImageMediaOverride {
      overlay = {
        lowerdir = [ "/nix/.ro-store" ];
        upperdir = "/nix/.rw-store/store";
        workdir = "/nix/.rw-store/work";
      };
      neededForBoot = true;
    };

    boot.initrd.availableKernelModules = [
      "squashfs"
      "overlay"
    ];

    boot.initrd.kernelModules = [
      "loop"
      "overlay"
    ];

    # Closures to be copied to the Nix store, namely the init
    # script and the top-level system configuration directory.
    netboot.storeContents = [ config.system.build.toplevel ];

    # Create the squashfs image that contains the Nix store.
    system.build.squashfsStore = pkgs.callPackage ../../../lib/make-squashfs.nix {
      storeContents = config.netboot.storeContents;
      comp = config.netboot.squashfsCompression;
    };

    # Create the initrd
    system.build.netbootRamdisk = pkgs.makeInitrdNG {
      inherit (config.boot.initrd) compressor compressorArgs;
      prepend = [ "${config.system.build.initialRamdisk}/initrd" ];

      contents = [
        {
          source = config.system.build.squashfsStore;
          target = "/nix-store.squashfs";
        }
      ];
    };

    system.build.netbootIpxeScript = pkgs.writeTextDir "netboot.ipxe" ''
      #!ipxe
      # Use the cmdline variable to allow the user to specify custom kernel params
      # when chainloading this script from other iPXE scripts like netboot.xyz
      kernel ${pkgs.stdenv.hostPlatform.linux-kernel.target} init=${config.system.build.toplevel}/init initrd=initrd ${toString config.boot.kernelParams} ''${cmdline}
      initrd initrd
      boot
    '';

    # A script invoking kexec on ./bzImage and ./initrd.gz.
    # Usually used through system.build.kexecTree, but exposed here for composability.
    system.build.kexecScript = pkgs.writeScript "kexec-boot" ''
      #!/usr/bin/env bash
      if ! kexec -v >/dev/null 2>&1; then
        echo "kexec not found: please install kexec-tools" 2>&1
        exit 1
      fi
      SCRIPT_DIR=$( cd -- "$( dirname -- "''${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
      kexec --load ''${SCRIPT_DIR}/bzImage \
        --initrd=''${SCRIPT_DIR}/initrd.gz \
        --command-line "init=${config.system.build.toplevel}/init ${toString config.boot.kernelParams}"
      kexec -e
    '';

    # A tree containing initrd.gz, bzImage and a kexec-boot script.
    system.build.kexecTree = pkgs.linkFarm "kexec-tree" [
      {
        name = "initrd.gz";
        path = "${config.system.build.netbootRamdisk}/initrd";
      }
      {
        name = "bzImage";
        path = "${config.system.build.kernel}/${config.system.boot.loader.kernelFile}";
      }
      {
        name = "kexec-boot";
        path = config.system.build.kexecScript;
      }
    ];

    image.extension = "tar.xz";
    image.filePath = "tarball/${config.image.fileName}";
    system.nixos.tags = [ "kexec" ];
    system.build.image = config.system.build.kexecTarball;
    system.build.kexecTarball =
      pkgs.callPackage "${toString modulesPath}/../lib/make-system-tarball.nix"
        {
          fileName = config.image.baseName;
          storeContents = [
            {
              object = config.system.build.kexecScript;
              symlink = "/kexec_nixos";
            }
          ];
          contents = [ ];
        };

    boot.loader.timeout = 10;

    boot.postBootCommands = ''
      # After booting, register the contents of the Nix store
      # in the Nix database in the tmpfs.
      ${config.nix.package}/bin/nix-store --load-db < /nix/store/nix-path-registration

      # nixos-rebuild also requires a "system" profile and an
      # /etc/NIXOS tag.
      touch /etc/NIXOS
      ${config.nix.package}/bin/nix-env -p /nix/var/nix/profiles/system --set /run/current-system

      # Set password for user nixos if specified on cmdline
      # Allows using nixos-anywhere in headless environments
      for o in $(</proc/cmdline); do
        case "$o" in
          live.nixos.passwordHash=*)
            set -- $(IFS==; echo $o)
            ${pkgs.gnugrep}/bin/grep -q "root::" /etc/shadow && ${pkgs.shadow}/bin/usermod -p "$2" root
            ;;
          live.nixos.password=*)
            set -- $(IFS==; echo $o)
            ${pkgs.gnugrep}/bin/grep -q "root::" /etc/shadow && echo "root:$2" | ${pkgs.shadow}/bin/chpasswd
            ;;
        esac
      done
    '';
  };
}
