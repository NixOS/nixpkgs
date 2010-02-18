# This module creates a bootable ISO image containing the given NixOS
# configuration.  The derivation for the ISO image will be placed in
# config.system.build.tarball.

{ config, pkgs, ... }:

with pkgs.lib;

let

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

  # A clue for the uboot loading
  ubootKernelParams = pkgs.writeText "uboot-kernel-params.txt" ''
    Kernel Parameters:
      init=${config.system.build.bootStage2}
      systemConfig=${config.system.build.toplevel}
      ${toString config.boot.kernelParams}
  '';

  versionFile = pkgs.writeText "nixos-version" config.system.nixosVersion;

in

{
  require = options;

  # Don't build the GRUB menu builder script, since we don't need it
  # here and it causes a cyclic dependency.
  boot.loader.grub.enable = false;

  # !!! Hack - attributes expected by other modules.
  system.build.menuBuilder = "true";
  system.boot.loader.kernelFile = "bzImage";
  environment.systemPackages = [ pkgs.grub2 ];

  # In stage 1 of the boot, mount the CD/DVD as the root FS by label
  # so that we don't need to know its device.
  fileSystems =
    [ { mountPoint = "/";
        label = "rootfs";
      }
    ];

  # boot.initrd.availableKernelModules = [ "mvsdio" "mmc_block" "reiserfs" "ext3" "ext4" ];

  # boot.initrd.kernelModules = [ "rtc_mv" ];

  # Closures to be copied to the Nix store on the CD, namely the init
  # script and the top-level system configuration directory.
  tarball.storeContents =
    [ {
        object = config.system.build.bootStage2;
        symlink = "none";
      }
      {
        object = config.system.build.toplevel;
        symlink = "/var/run/current-system";
      }
    ];

  # Individual files to be included on the CD, outside of the Nix
  # store on the CD.
  tarball.contents =
    [ { source = config.boot.kernelPackages.kernel + "/bzImage";
        target = "/boot/bzImage";
      }
      { source = config.system.build.initialRamdisk + "/initrd";
        target = "/boot/initrd";
      }
      { source = "${pkgs.grub2}/share/grub/unicode.pf2";
        target = "/boot/grub/unicode.pf2";
      }
      { source = config.boot.loader.grub.splashImage;
        target = "/boot/grub/splash.png";
      }
/*
      { source = pkgs.ubootKernelParams;
        target = "/uboot-kernelparams.txt";
      }
*/
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
      ${config.environment.nix}/bin/nix-store --load-db < /nix/store/nix-path-registration

      # nixos-rebuild also requires a "system" profile and an
      # /etc/NIXOS tag.
      touch /etc/NIXOS
      ${config.environment.nix}/bin/nix-env -p /nix/var/nix/profiles/system --set /var/run/current-system
    '';
}
