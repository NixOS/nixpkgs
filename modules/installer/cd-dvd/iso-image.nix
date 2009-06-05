# This module creates a bootable ISO image containing the given NixOS
# configuration.  The derivation for the ISO image will be placed in
# config.system.build.isoImage.

{config, pkgs, ...}:

let
 
  cdLabel = "NIXOS_INSTALLATION_CD";

  # The configuration file for Grub.
  grubCfg = 
    ''
      default 0
      timeout 10
      splashimage /boot/background.xpm.gz

      title Boot from hard disk
        root (hd0)
        chainloader +1
    
      title NixOS Installer / Rescue
        kernel /boot/vmlinuz init=/init ${toString config.boot.kernelParams}
        initrd /boot/initrd
    '';
  
in

{
  # In stage 1 of the boot, mount the CD/DVD as the root FS by label
  # so that we don't need to know its device.
  fileSystems =
    [ { mountPoint = "/";
        label = cdLabel;
      }
    ];

  # We need AUFS in the initrd to make the CD appear writable.
  boot.extraModulePackages = [config.boot.kernelPackages.aufs];
  boot.initrd.extraKernelModules = ["aufs"];

  # Tell stage 1 of the boot to mount a tmpfs on top of the CD using
  # AUFS.  !!! It would be nicer to make the stage 1 init pluggable
  # and move that bit of code here.
  boot.isLiveCD = true;

  # Create the ISO image.
  system.build.isoImage = import ../../../lib/make-iso9660-image.nix {
    inherit (pkgs) stdenv perl cdrkit pathsFromGraph;
    #isoName = "${relName}-${platform}.iso";

    bootable = true;
    bootImage = "boot/grub/stage2_eltorito";

    #compressImage = ...;

    volumeID = cdLabel;

    # Single files to be copied to fixed locations on the CD.
    contents =
      [ { source = "${pkgs.grub}/lib/grub/${if pkgs.stdenv.system == "i686-linux" then "i386-pc" else "x86_64-unknown"}/stage2_eltorito";
          target = "boot/grub/stage2_eltorito";
        }
        { source = pkgs.writeText "menu.lst" grubCfg;
          target = "boot/grub/menu.lst";
        }
        { source = config.boot.kernelPackages.kernel + "/vmlinuz";
          target = "boot/vmlinuz";
        }
        { source = config.system.build.initialRamdisk + "/initrd";
          target = "boot/initrd";
        }
        { source = config.boot.grubSplashImage;
          target = "boot/background.xpm.gz";
        }
      ];

    # Closures to be copied to the Nix store on the CD.
    storeContents =
      [ { object = config.system.build.bootStage2;
          symlink = "/init";
        }
        { object = config.system.build.system;
          symlink = "/system";
        }
      ];
  };

  # After booting, register the contents of the Nix store on the CD in
  # the Nix database in the tmpfs.
  boot.postBootCommands =
    ''
      ${config.environment.nix}/bin/nix-store --load-db < /nix-path-registration
      rm /nix-path-registration
    '';
}
