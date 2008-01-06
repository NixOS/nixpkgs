{ platform ? __currentSystem
}:

rec {

  
  nixpkgsRel = "nixpkgs";


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
              mkdir -p /etc/nixos/nixpkgs
              tar xjf /nixpkgs.tar.bz2 -C /etc/nixos/nixpkgs
              mv /etc/nixos/nixpkgs-* /etc/nixos/nixpkgs || test -e /etc/nixos/nixpkgs
              ln -sfn ../nixpkgs/pkgs /etc/nixos/nixos/pkgs
              chown -R root.root /etc/nixos
	      touch /etc/resolv.conf
            end script
          ";
        }
      
        # Show the NixOS manual on tty7.
        { name = "manual";
          job = "
            start on udev
            stop on shutdown
            respawn ${pkgs.w3m}/bin/w3m ${manual} < /dev/tty7 > /dev/tty7 2>&1
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
      enableFontConfig = true;
    };
    
    installer = {
      manifests = [ file:///mnt/MANIFEST ];
      nixpkgsURL = file:///mnt/ ;
    };

    security = {
      sudo = {
        enable = true;
      };
    };
 
    environment = {
      extraPackages = pkgs: [
	pkgs.irssi
	pkgs.elinks
	pkgs.ltrace
	pkgs.subversion
        pkgs.which
	pkgs.file
	pkgs.zip
	pkgs.unzip
	pkgs.unrar
	pkgs.usbutils
	pkgs.bc
	pkgs.cpio
	pkgs.ncat
	pkgs.patch
	pkgs.fuse
	pkgs.indent
	pkgs.zsh
	pkgs.hddtemp
	pkgs.hdparm
	pkgs.sdparm
	pkgs.sqlite
	pkgs.wpa_supplicant
	pkgs.lynx
	pkgs.db4
	pkgs.rogue
	pkgs.attr
	pkgs.acl
	pkgs.automake
	pkgs.autoconf
	pkgs.libtool
	pkgs.gnupg
	pkgs.openssl
	pkgs.units
	pkgs.gnumake
	pkgs.manpages
	pkgs.cabextract
	pkgs.upstartJobControl
	pkgs.fpc
	pkgs.python
	pkgs.perl
	pkgs.lftp
	pkgs.wget
	pkgs.guile
	pkgs.utillinuxCurses
	pkgs.emacs
	pkgs.iproute
	pkgs.MPlayer
	pkgs.diffutils
	pkgs.pciutils
	pkgs.lsof
	pkgs.vim
      ];
    };
   
  };


  system = import ../system/system.nix {
    inherit configuration platform;
    stage2Init = "/init";
  };


  pkgs = system.pkgs;


  # The NixOS manual, with a backward compatibility hack for Nix <=
  # 0.11 (you won't get the manual).
  manual =
    if builtins ? unsafeDiscardStringContext
    then "${import ../doc/manual}/manual.html"
    else pkgs.writeText "dummy-manual" "Manual not included in this build!";


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
      --exclude 'result')
  ";
  makeTarballNixos = tarName: input: pkgs.runCommand "tarball" {inherit tarName;} "
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
      in base != "result";
    in
      makeTarballNixos "nixos.tar.bz2" (builtins.filterSource filter ./..);


  # Get a recent copy of Nixpkgs.
  nixpkgsTarball = /* /root/nixpkgs.tar.bz2; */
    let filter = name: type:
      let base = baseNameOf (toString name);
      in base != "result";
    in
      makeTarball "nixpkgs.tar.bz2" (builtins.filterSource filter /etc/nixos/nixpkgs);


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
      { source = nixpkgsTarball + "/" +nixpkgsTarball.tarName;
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
    buildStoreContents = [
      {
        object = system.system.drvPath;
	symlink = "none";
      }
    ];
    
    bootable = true;
    bootImage = "boot/grub/stage2_eltorito";
  };


}
