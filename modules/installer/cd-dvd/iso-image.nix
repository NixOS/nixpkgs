# This module creates a bootable ISO image containing the given NixOS
# configuration.  The derivation for the ISO image will be placed in
# config.system.build.isoImage.

{config, pkgs, ...}:

let

  options = {

    isoImage.isoName = pkgs.lib.mkOption {
      default = "cd.iso";
      description = ''
        Name of the generated ISO image file.
      '';
    };

    isoImage.compressImage = pkgs.lib.mkOption {
      default = false;
      description = ''
        Whether the ISO image should be compressed using
        <command>bzip2</command>.
      '';
    };

    isoImage.volumeID = pkgs.lib.mkOption {
      default = "NIXOS_BOOT_CD";
      description = ''
        Specifies the label or volume ID of the generated ISO image.
        Note that the label is used by stage 1 of the boot process to
        mount the CD, so it should be reasonably distinctive.
      '';
    };

    isoImage.contents = pkgs.lib.mkOption {
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

    isoImage.storeContents = pkgs.lib.mkOption {
      example = [pkgs.stdenv];
      description = ''
        This option lists additional derivations to be included in the
        Nix store in the generated ISO image.
      '';
    };

  };


  # The Grub image.
  grubImage = pkgs.runCommand "grub_eltorito" {}
    ''
      ${pkgs.grub2}/bin/grub-mkimage -o tmp biosdisk iso9660 help linux linux16 sh chain
      cat ${pkgs.grub2}/lib/grub/*/cdboot.img tmp > $out
    ''; # */


  # The configuration file for Grub.
  grubCfg = 
    ''
      set default = 0
      set timeout = 10

      #splashimage /boot/background.xpm.gz

      ${config.boot.extraGrubEntries}
    '';
  
in

{
  require = options;

  # In stage 1 of the boot, mount the CD/DVD as the root FS by label
  # so that we don't need to know its device.
  fileSystems =
    [ { mountPoint = "/";
        label = config.isoImage.volumeID;
      }
      { mountPoint = "/nix/store";
        fsType = "squashfs";
        device = "/nix-store.squashfs";
        options = "loop";
        neededForBoot = true;
      }
    ];

  # We need squashfs in the initrd to mount the compressed Nix store,
  # and aufs to make the root filesystem appear writable.
  boot.extraModulePackages = (pkgs.lib.optional 
    (! config.boot.kernelPackages.kernel.features ? aufs) 
    config.boot.kernelPackages.aufs);
  boot.initrd.extraKernelModules = ["aufs" "squashfs"];

  # Tell stage 1 of the boot to mount a tmpfs on top of the CD using
  # AUFS.  !!! It would be nicer to make the stage 1 init pluggable
  # and move that bit of code here.
  boot.isLiveCD = true;

  # Closures to be copied to the Nix store on the CD, namely the init
  # script and the top-level system configuration directory.
  isoImage.storeContents =
    [ config.system.build.bootStage2
      config.system.build.toplevel
    ];

  # Create the squashfs image that contains the Nix store.
  system.build.squashfsStore = import ../../../lib/make-squashfs.nix {
    inherit (pkgs) stdenv squashfsTools perl pathsFromGraph;
    storeContents = config.isoImage.storeContents;
  };

  # Individual files to be included on the CD, outside of the Nix
  # store on the CD.
  isoImage.contents =
    [ { source = grubImage;
        target = "/boot/grub/grub_eltorito";
      }
      { source = pkgs.writeText "grub.cfg" grubCfg;
        target = "/boot/grub/grub.cfg";
      }
      { source = config.boot.kernelPackages.kernel + "/vmlinuz";
        target = "/boot/vmlinuz";
      }
      { source = config.system.build.initialRamdisk + "/initrd";
        target = "/boot/initrd";
      }
      { source = config.boot.grubSplashImage;
        target = "/boot/background.xpm.gz";
      }
      { source = config.system.build.squashfsStore;
        target = "/nix-store.squashfs";
      }
      { # Quick hack: need a mount point for the store.
        source = pkgs.runCommand "empty" {} "ensureDir $out";
        target = "/nix/store";
      }
      { # Another quick hack: the kernel needs a systemConfig
        # parameter in menu.lst, but the system config depends on
        # menu.lst.  Break the cyclic dependency by having a /system
        # symlink on the CD, and having menu.lst refer to /system.
        source = pkgs.runCommand "system" {}
          "ln -s ${config.system.build.toplevel} $out";
        target = "/system";
      }
      { # Idem for the stage-2 init script.
        source = pkgs.runCommand "system" {}
          "ln -s ${config.system.build.bootStage2} $out";
        target = "/init";
      }
    ];

  # The Grub menu.
  boot.extraGrubEntries =
    ''
      menuentry "Boot from hard disk" {
        set root=(hd0)
        chainloader +1
      }
    
      menuentry "NixOS Installer / Rescue" {
        linux /boot/vmlinuz init=/init systemConfig=/system ${toString config.boot.kernelParams}
        initrd /boot/initrd
      }
    '';

  # Create the ISO image.
  system.build.isoImage = import ../../../lib/make-iso9660-image.nix {
    inherit (pkgs) stdenv perl cdrkit pathsFromGraph;
    
    inherit (config.isoImage) isoName compressImage volumeID contents;

    bootable = true;
    bootImage = "/boot/grub/grub_eltorito";
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
