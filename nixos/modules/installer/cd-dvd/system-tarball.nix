# This module creates a bootable ISO image containing the given NixOS
# configuration.  The derivation for the ISO image will be placed in
# config.system.build.tarball.

{ config, pkgs, ... }:

with pkgs.lib;

let

  versionFile = pkgs.writeText "nixos-version" config.system.nixosVersion;

in

{
  options = {
    tarball.contents = mkOption {
      example =
        [ { source = pkgs.memtest86 + "/memtest.bin";
            target = "boot/memtest.bin";
          }
        ];
      description = ''
        This option lists files to be copied to fixed locations in the
        generated ISO image.
      '';
    };

    tarball.storeContents = mkOption {
      example = [pkgs.stdenv];
      description = ''
        This option lists additional derivations to be included in the
        Nix store in the generated ISO image.
      '';
    };

  };

  config = {

    # In stage 1 of the boot, mount the CD/DVD as the root FS by label
    # so that we don't need to know its device.
    fileSystems = [ ];

    # boot.initrd.availableKernelModules = [ "mvsdio" "mmc_block" "reiserfs" "ext3" "ext4" ];

    # boot.initrd.kernelModules = [ "rtc_mv" ];

    # Closures to be copied to the Nix store on the CD, namely the init
    # script and the top-level system configuration directory.
    tarball.storeContents =
      [ { object = config.system.build.toplevel;
          symlink = "/run/current-system";
        }
      ];

    # Individual files to be included on the CD, outside of the Nix
    # store on the CD.
    tarball.contents =
      [ { source = config.system.build.initialRamdisk + "/initrd";
          target = "/boot/initrd";
        }
        { source = versionFile;
          target = "/nixos-version.txt";
        }
      ];

    # Create the tarball
    system.build.tarball = import ../../../lib/make-system-tarball.nix {
      inherit (pkgs) stdenv perl xz pathsFromGraph;

      inherit (config.tarball) contents storeContents;
    };

    boot.postBootCommands =
      ''
        # After booting, register the contents of the Nix store on the
        # CD in the Nix database in the tmpfs.
        if [ -f /nix-path-registration ]; then
          ${config.environment.nix}/bin/nix-store --load-db < /nix-path-registration &&
          rm /nix-path-registration
        fi

        # nixos-rebuild also requires a "system" profile and an
        # /etc/NIXOS tag.
        touch /etc/NIXOS
        ${config.environment.nix}/bin/nix-env -p /nix/var/nix/profiles/system --set /run/current-system
      '';

  };

}
