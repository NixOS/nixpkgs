# This module creates netboot media containing the given NixOS
# configuration.

{ options, config, lib, pkgs, ... }:

with lib;

{
  options = {

    netboot.squashfsCompression = mkOption {
      default = with pkgs.stdenv.hostPlatform; "xz -Xdict-size 100% "
                + lib.optionalString isx86 "-Xbcj x86"
                # Untested but should also reduce size for these platforms
                + lib.optionalString isAarch "-Xbcj arm"
                + lib.optionalString (isPower && is32bit && isBigEndian) "-Xbcj powerpc"
                + lib.optionalString (isSparc) "-Xbcj sparc";
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

    # !!! Hack - attributes expected by other modules.
    environment.systemPackages = [ pkgs.grub2_efi ]
      ++ (lib.optionals (lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.syslinux)
        [pkgs.grub2 pkgs.syslinux]);

    # We only want to set those options in the context of
    # the QEMU infrastructure.
    virtualisation = lib.optionalAttrs (options ? virtualisation.directBoot) {
      # By default, using netboot images in virtualized contexts
      # should not create any disk image ideally, except if
      # asked explicitly.
      diskImage = mkDefault null;
      # We do not want to mount the host Nix store in those situations.
      mountHostNixStore = mkDefault false;
      # We do not need the nix store image because:
      # - either we boot through network and we have the squashfs image
      # - either we direct boot, we have the squashfs image
      useNixStoreImage = mkDefault false;
      # Though, we still want a writable store through .rw-store
      writableStore = mkDefault true;
      # Ideally, we might not want to test the network / firmware.
      directBoot = {
        enable = mkDefault true;
        # We need to use our netboot initrd which contains a copy of the Nix store.
        initrd = "${config.system.build.netbootRamdisk}/${config.system.boot.loader.initrdFile}";
      };
      # We do not want to use the default filesystems.
      useDefaultFilesystems = mkDefault false;
      # Bump the default memory size as we are loading the whole initrd in RAM.
      memorySize = mkDefault 1536;
    };


    fileSystems."/" = mkImageMediaOverride
      { fsType = "tmpfs";
        options = [ "mode=0755" ];
      };

    # In stage 1, mount a tmpfs on top of /nix/store (the squashfs
    # image) to make this a live CD.
    fileSystems."/nix/.ro-store" = mkImageMediaOverride
      { fsType = "squashfs";
        device = "../nix-store.squashfs";
        options = [ "loop" ];
        neededForBoot = true;
      };

    fileSystems."/nix/.rw-store" = mkImageMediaOverride
      { fsType = "tmpfs";
        options = [ "mode=0755" ];
        neededForBoot = true;
      };

    fileSystems."/nix/store" = mkImageMediaOverride
      { overlay = {
          lowerdir = [ "/nix/.ro-store" ];
          upperdir = "/nix/.rw-store/store";
          workdir = "/nix/.rw-store/work";
        };
        neededForBoot = true;
      };

    boot.initrd.availableKernelModules = [ "squashfs" "overlay" ];

    boot.initrd.kernelModules = [ "loop" "overlay" ];

    # Closures to be copied to the Nix store, namely the init
    # script and the top-level system configuration directory.
    netboot.storeContents =
      [ config.system.build.toplevel ];

    # Create the squashfs image that contains the Nix store.
    system.build.squashfsStore = pkgs.callPackage ../../../lib/make-squashfs.nix {
      storeContents = config.netboot.storeContents;
      comp = config.netboot.squashfsCompression;
    };


    # Create the initrd
    system.build.netbootRamdisk = pkgs.makeInitrdNG {
      prepend = [ "${config.system.build.initialRamdisk}/${config.system.boot.loader.initrdFile}" ];

      contents =
        [ { object = config.system.build.squashfsStore;
            symlink = "/nix-store.squashfs";
          }
        ];
    };

    system.build.netbootIpxeScript = pkgs.writeTextDir "netboot.ipxe" ''
      #!ipxe
      # Use the cmdline variable to allow the user to specify custom kernel params
      # when chainloading this script from other iPXE scripts like netboot.xyz
      kernel ${pkgs.stdenv.hostPlatform.linux-kernel.target} init=${config.system.build.toplevel}/init initrd=${config.system.boot.loader.initrdFile} ${toString config.boot.kernelParams} ''${cmdline}
      initrd ${config.system.boot.loader.initrdFile}
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
        --initrd=''${SCRIPT_DIR}/${config.system.boot.loader.initrdFile} \
        --command-line "init=${config.system.build.toplevel}/init ${toString config.boot.kernelParams}"
      kexec -e
    '';

    # A tree containing initrd.gz, bzImage and a kexec-boot script.
    system.build.kexecTree = pkgs.linkFarm "kexec-tree" [
      {
        name = "${config.system.boot.loader.initrdFile}";
        path = "${config.system.build.netbootRamdisk}/${config.system.boot.loader.initrdFile}";
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

    boot.loader.timeout = 10;

    boot.postBootCommands =
      ''
        # After booting, register the contents of the Nix store
        # in the Nix database in the tmpfs.
        ${config.nix.package}/bin/nix-store --load-db < /nix/store/nix-path-registration

        # nixos-rebuild also requires a "system" profile and an
        # /etc/NIXOS tag.
        touch /etc/NIXOS
        ${config.nix.package}/bin/nix-env -p /nix/var/nix/profiles/system --set /run/current-system
      '';

  };

}
