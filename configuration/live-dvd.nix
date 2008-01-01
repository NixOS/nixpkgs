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
          { tty = 8;
            theme = pkgs.fetchurl {
              url = http://www.bootsplash.de/files/themes/Theme-GNU.tar.bz2;
              md5 = "61969309d23c631e57b0a311102ef034";
            };
          }
        ];
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
        pkgs.vimDiet
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


  # The configuration file for isolinux.
  isolinuxCfg = pkgs.writeText "isolinux.cfg" "
    default linux
    prompt 1
    timeout 60
    label linux
      kernel vmlinuz
      append initrd=initrd ${toString (system.config.boot.kernelParams)}
  ";
    


  # Create an ISO image containing the isolinux boot loader, the
  # kernel, the initrd produced above, and the closure of the stage 2
  # init.
  rescueCD = import ../helpers/make-iso9660-image.nix {
    inherit (pkgs) stdenv perl cdrtools;
    isoName = "nixos-${platform}.iso";

    # Single files to be copied to fixed locations on the CD.
    contents = [
      { source = pkgs.syslinux + "/lib/syslinux/isolinux.bin";
        target = "isolinux/isolinux.bin";
      }
      { source = isolinuxCfg;
        target = "isolinux/isolinux.cfg";
      }
      { source = pkgs.kernel + "/vmlinuz";
        target = "isolinux/vmlinuz";
      }
      { source = system.initialRamdisk + "/initrd";
        target = "isolinux/initrd";
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
    bootImage = "isolinux/isolinux.bin";
  };


}
