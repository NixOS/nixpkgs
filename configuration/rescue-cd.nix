{ platform ? __currentSystem
}:

rec {

  
  nixpkgsRel = "nixpkgs-0.12pre10056";


  configuration = {
  
    boot = {
      autoDetectRootDevice = true;
      readOnlyRoot = true;
      # The label used to identify the installation CD.
      rootLabel = "NIXOS";
      extraTTYs = [7 8]; # manual, rogue
    };
    
    services = {
    
      sshd = {
        enable = false;
      };
      
      xserver = {
        enable = false;
      };

      extraJobs = [
        # Unpack the NixOS/Nixpkgs sources to /etc/nixos.
        { name = "unpack-sources";
          job = "
            start on startup
            script
              export PATH=${pkgs.gnutar}/bin:${pkgs.bzip2}/bin:$PATH
              mkdir -p /etc/nixos/nixos
              tar xjf /nixos.tar.bz2 -C /etc/nixos/nixos
              tar xjf /nixpkgs.tar.bz2 -C /etc/nixos
              mv /etc/nixos/nixpkgs-* /etc/nixos/nixpkgs
              ln -sfn ../nixpkgs/pkgs /etc/nixos/nixos/pkgs
              chown -R root.root /etc/nixos
            end script
          ";
        }
      
        # Show the NixOS manual on tty7.
        { name = "manual";
          job = "
            start on udev
            stop on shutdown
            respawn ${pkgs.w3m}/bin/w3m ${import ../doc/manual}/manual.html < /dev/tty7 > /dev/tty7 2>&1
          ";
        }

        # Allow the user to do something useful on tty8 while waiting
        # for the installation to finish.
        { name = "rogue";
          job = "
            start on udev
            stop on shutdown
            respawn ${pkgs.rogue}/bin/rogue < /dev/tty8 > /dev/tty8 2>&1
          ";
        }
      ];

      # And a background to go with that.
      ttyBackgrounds = {
        specificThemes = [
          { tty = 7;
            # Theme is GPL according to http://kde-look.org/content/show.php/Green?content=58501.
            theme = pkgs.fetchurl {
              url = http://www.kde-look.org/CONTENT/content-files/58501-green.tar.gz;
              sha256 = "0sdykpziij1f3w4braq8r8nqg4lnsd7i7gi1k5d7c31m2q3b9a7r";
            };
          }
          { tty = 8;
            theme = pkgs.fetchurl {
              url = http://www.bootsplash.de/files/themes/Theme-GNU.tar.bz2;
              md5 = "61969309d23c631e57b0a311102ef034";
            };
          }
        ];
      };

      mingetty = {
        helpLine = ''
        
          Log in as "root" with an empty password.  Press <Alt-F7> for help.
        '';
      };
      
    };

    fonts = {
      enableFontConfig = false;
    };
    
    installer = {
      nixpkgsURL = http://nix.cs.uu.nl/dist/nix/ + nixpkgsRel;
    };

    security = {
      sudo = {
        enable = false;
      };
    };
 
    environment = {
      extraPackages = pkgs: [
        pkgs.vim
        pkgs.subversion # for nixos-checkout
        pkgs.w3m # needed for the manual anyway
      ];
    };
   
  };


  system = import ../system/system.nix {
    inherit configuration platform;
    stage2Init = "/init";
  };


  pkgs = system.pkgs;


  # Since the CD is read-only, the mount points must be on disk.
  cdMountPoints = pkgs.runCommand "mount-points" {} "
    ensureDir $out
    cd $out
    mkdir proc sys tmp etc dev var mnt nix nix/var root bin
    touch $out/${configuration.boot.rootLabel}
  ";


  # We need a copy of the Nix expressions for Nixpkgs and NixOS on the
  # CD.  We put them in a tarball because accessing that many small
  # files from a slow device like a CD-ROM takes too long.
  makeTarball = tarName: input: pkgs.runCommand "tarball" {inherit tarName;} "
    ensureDir $out
    (cd ${input} && tar cvfj $out/${tarName} . \\
      --exclude '*~' \\
      --exclude 'pkgs' --exclude 'result')
  ";

  
  # Put the current directory in a tarball (making sure to filter
  # out crap like the .svn directories).
  nixosTarball =
    let filter = name: type:
      let base = baseNameOf (toString name);
      in base != ".svn" && base != "result";
    in
      makeTarball "nixos.tar.bz2" (builtins.filterSource filter ./..);


  # Get a recent copy of Nixpkgs.
  nixpkgsTarball = pkgs.fetchurl {
    url = configuration.installer.nixpkgsURL + "/" + nixpkgsRel + ".tar.bz2";
    md5 = "a25cd6eb5e753703823fdd3ae86e9f25";
  };


  # The configuration file for Grub.
  grubCfg = pkgs.writeText "menu.lst" ''
    default 0
    timeout 10
    splashimage /boot/background.xpm.gz
    
    title NixOS Installer / Rescue
      kernel /boot/vmlinuz ${toString system.config.boot.kernelParams}
      initrd /boot/initrd

    title Memtest86+
      kernel /boot/memtest.bin
  '';


  # Create an ISO image containing the Grub boot loader, the kernel,
  # the initrd produced above, and the closure of the stage 2 init.
  rescueCD = import ../helpers/make-iso9660-image.nix {
    inherit (pkgs) stdenv perl cdrkit;
    isoName = "nixos-${platform}.iso";

    # Single files to be copied to fixed locations on the CD.
    contents = [
      { source = "${pkgs.grub}/lib/grub/i386-pc/stage2_eltorito";
        target = "boot/grub/stage2_eltorito";
      }
      { source = grubCfg;
        target = "boot/grub/menu.lst";
      }
      { source = pkgs.kernel + "/vmlinuz";
        target = "boot/vmlinuz";
      }
      { source = system.initialRamdisk + "/initrd";
        target = "boot/initrd";
      }
      { source = pkgs.memtest86 + "/memtest.bin";
        target = "boot/memtest.bin";
      }
      { source = system.config.boot.grubSplashImage;
        target = "boot/background.xpm.gz";
      }
      { source = cdMountPoints;
        target = "/";
      }
      { source = nixosTarball + "/" + nixosTarball.tarName;
        target = "/" + nixosTarball.tarName;
      }
      { source = nixpkgsTarball;
        target = "/nixpkgs.tar.bz2";
      }
    ];

    # Closures to be copied to the Nix store on the CD.
    storeContents = [
      { object = system.bootStage2;
        symlink = "/init";
      }
      { object = system.system;
        symlink = "/system";
      }
      # To speed up the installation, provide the full stdenv.
      { object = pkgs.stdenv;
        symlink = "none";
      }
    ];
    
    bootable = true;
    bootImage = "boot/grub/stage2_eltorito";
  };


}
