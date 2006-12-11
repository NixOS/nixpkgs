{ system ? __currentSystem
, autoDetectRootDevice ? false
, rootDevice ? ""
, rootLabel ? ""
, stage2Init
, readOnlyRoot
, configData ? {}
}:

rec {

  # Make a configuration object from which we can retrieve option
  # values.
  config = import ./config.nix pkgs.library configData;
  

  pkgs = import ../pkgs/top-level/all-packages.nix {inherit system;};

  pkgsDiet = import ../pkgs/top-level/all-packages.nix {
    inherit system;
    bootStdenv = pkgs.useDietLibC pkgs.stdenv;
  };

  pkgsStatic = import ../pkgs/top-level/all-packages.nix {
    inherit system;
    bootStdenv = pkgs.makeStaticBinaries pkgs.stdenv;
  };

  stdenvLinuxStuff = import ../pkgs/stdenv/linux {
    system = pkgs.stdenv.system;
    allPackages = import ../pkgs/top-level/all-packages.nix;
  };

  nix = pkgs.nixUnstable; # we need the exportReferencesGraph feature


  # Splash configuration.
  splashThemes = import ./splash-themes.nix {
    inherit (pkgs) fetchurl;
  };


  # Determine the set of modules that we need to mount the root FS.
  modulesClosure = import ../helpers/modules-closure.nix {
    inherit (pkgs) stdenv kernel module_init_tools;
    rootModules = ["ide-cd" "ide-disk" "ide-generic"];
  };


  # Some additional utilities needed in stage 1, notably mount.  We
  # don't want to bring in all of util-linux, so we just copy what we
  # need.
  extraUtils = pkgs.runCommand "extra-utils"
    { buildInputs = [pkgs.nukeReferences];
      inherit (pkgsStatic) utillinux;
      inherit (pkgs) splashutils;
      e2fsprogs = pkgs.e2fsprogsDiet;
    }
    "
      ensureDir $out/bin
      cp $utillinux/bin/mount $utillinux/bin/umount $utillinux/sbin/pivot_root $out/bin
      cp -p $e2fsprogs/sbin/fsck* $e2fsprogs/sbin/e2fsck $out/bin
      cp $splashutils/bin/splash_helper $out/bin
      nuke-refs $out/bin/*
    ";
  

  # The init script of boot stage 1 (loading kernel modules for
  # mounting the root FS).
  bootStage1 = import ../boot/boot-stage-1.nix {
    inherit (pkgs) substituteAll;
    inherit (pkgsDiet) module_init_tools;
    inherit extraUtils;
    inherit autoDetectRootDevice rootDevice rootLabel;
    inherit stage2Init;
    modules = modulesClosure;
    staticShell = stdenvLinuxStuff.bootstrapTools.bash;
    staticTools = stdenvLinuxStuff.staticTools;
  };
  

  # The closure of the init script of boot stage 1 is what we put in
  # the initial RAM disk.
  initialRamdisk = import ../boot/make-initrd.nix {
    inherit (pkgs) stdenv cpio;
    contents = [
      { object = bootStage1;
        symlink = "/init";
      }
      { object = extraUtils;
        suffix = "/bin/splash_helper";
        symlink = "/sbin/splash_helper";
      }
      { object = import ../helpers/unpack-theme.nix {
          inherit (pkgs) stdenv;
          theme = splashThemes.splashScreen;
        };
        symlink = "/etc/splash";
      }
    ];
  };


  # The installer.
  nixosInstaller = import ../installer/nixos-installer.nix {
    inherit (pkgs) stdenv runCommand substituteAll;
    inherit nix;
  };


  # The services (Upstart) configuration for the system.
  upstartJobs = import ./upstart.nix {
    inherit pkgs nix splashThemes;
  };


  # The static parts of /etc.
  etc = import ./etc.nix {
    inherit pkgs upstartJobs;
  };


  # The wrapper setuid programs (since we can't have setuid programs
  # in the Nix store).  
  setuidWrapper = import ../helpers/setuid {
    inherit (pkgs) stdenv;
    wrapperDir = "/var/setuid-wrappers";
  };


  # The packages you want in the boot environment.
  fullPath = [
    pkgs.bash
    pkgs.bzip2
    pkgs.coreutils
    pkgs.cpio
    pkgs.curl
    pkgs.e2fsprogs
    pkgs.findutils
    pkgs.gnugrep
    pkgs.gnused
    pkgs.gnutar
    pkgs.grub
    pkgs.gzip
    pkgs.iputils
    pkgs.less
    pkgs.module_init_tools
    pkgs.nano
    pkgs.netcat
    pkgs.nettools
    pkgs.perl
    pkgs.procps
    pkgs.pwdutils
    pkgs.rsync
    pkgs.strace
    pkgs.sysklogd
    pkgs.udev
    pkgs.upstart
    pkgs.utillinux
#    pkgs.vim
    nix
    nixosInstaller
    setuidWrapper
  ];


  # The script that activates the configuration, i.e., it sets up
  # /etc, accounts, etc.  It doesn't do anything that can only be done
  # at boot time (such as start `init').
  activateConfiguration = pkgs.substituteAll {
    src = ./activate-configuration.sh;
    isExecutable = true;

    inherit etc;
    inherit readOnlyRoot;
    inherit (pkgs) kernel;
    hostName = config.get ["networking" "hostname"];
    wrapperDir = setuidWrapper.wrapperDir;
    accounts = ../helpers/accounts.sh;

    path = [pkgs.coreutils pkgs.gnugrep pkgs.findutils];

    # We don't want to put all of `startPath' and `path' in $PATH, since
    # then we get an embarrassingly long $PATH.  So use the user
    # environment builder to make a directory with symlinks to those
    # packages.
    fullPath = pkgs.buildEnv {
      name = "boot-stage-2-path";
      paths = fullPath;
      pathsToLink = ["/bin" "/sbin" "/man/man1" "/share/man/man1"];
      ignoreCollisions = true;
    };
  };


  # The init script of boot stage 2, which is supposed to do
  # everything else to bring up the system.
  bootStage2 = import ../boot/boot-stage-2.nix {
    inherit (pkgs) substituteAll coreutils 
      utillinux kernel udev upstart;
    inherit readOnlyRoot;
    inherit activateConfiguration;
    upstartPath = [
      pkgs.coreutils
      pkgs.findutils
      pkgs.gnugrep
      pkgs.gnused
      pkgs.upstart
    ];
  };

}
