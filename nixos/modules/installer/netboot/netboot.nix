# This module creates netboot media containing the given NixOS
# configuration.

{ config, lib, pkgs, ... }:

with lib;

{
  options = {

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
      ++ (if pkgs.stdenv.hostPlatform.system == "aarch64-linux"
          then []
          else [ pkgs.grub2 pkgs.syslinux ]);

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
      { fsType = "overlay";
        device = "overlay";
        options = [
          "lowerdir=/nix/.ro-store"
          "upperdir=/nix/.rw-store/store"
          "workdir=/nix/.rw-store/work"
        ];

        depends = [
          "/nix/.ro-store"
          "/nix/.rw-store/store"
          "/nix/.rw-store/work"
        ];
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
    };


    # Create the initrd
    system.build.netbootRamdisk = pkgs.makeInitrd {
      inherit (config.boot.initrd) compressor;
      prepend = [ "${config.system.build.initialRamdisk}/initrd" ];

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
      kernel ${pkgs.stdenv.hostPlatform.linux-kernel.target} init=${config.system.build.toplevel}/init initrd=initrd ${toString config.boot.kernelParams} ''${cmdline}
      initrd initrd
      boot
    '';

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
