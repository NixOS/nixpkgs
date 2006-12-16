rec {

  
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
    };
  };


  system = import ../configuration/system.nix {
    inherit configuration;
    stage2Init = "/init";
  };


  pkgs = system.pkgs;
  

  # Since the CD is read-only, the mount points must be on disk.
  cdMountPoints = pkgs.runCommand "mount-points" {} "
    ensureDir $out
    cd $out
    mkdir proc sys tmp etc dev var mnt nix nix/var
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
  nixosTarball = makeTarball "nixos.tar.bz2" (builtins.filterSource
    (name: let base = baseNameOf (toString name); in base != ".svn" && base != "result") ./..);


  # Get a recent copy of Nixpkgs.
  nixpkgsRel = "nixpkgs-0.11pre7355";
  nixpkgsURL = http://nix.cs.uu.nl/dist/nix/ + nixpkgsRel;

  nixpkgsTarball = pkgs.fetchurl {
    url = nixpkgsURL + "/" + nixpkgsRel + ".tar.bz2";
    md5 = "9d3e5e9f6ab64536803abf3f2e1c6056";
  };


  # Create an ISO image containing the isolinux boot loader, the
  # kernel, the initrd produced above, and the closure of the stage 2
  # init.
  rescueCD = import ../helpers/make-iso9660-image.nix {
    inherit (pkgs) stdenv cdrtools;
    isoName = "nixos.iso";
    
    contents = [
      { source = pkgs.syslinux + "/lib/syslinux/isolinux.bin";
        target = "isolinux/isolinux.bin";
      }
      { source = ../helpers/isolinux.cfg;
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
      { source = nixpkgsTarball;
        target = "/nixpkgs.tar.bz2";
      }
    ];

    init = system.bootStage2;
    
    bootable = true;
    bootImage = "isolinux/isolinux.bin";
  };


}
