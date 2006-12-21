{ platform ? __currentSystem
, stage2Init ? ""
, configuration
}:

rec {

  # Make a configuration object from which we can retrieve option
  # values.
  config = import ./config.nix pkgs.library configuration;
  

  pkgs = import ../pkgs/top-level/all-packages.nix {system = platform;};

  pkgsDiet = import ../pkgs/top-level/all-packages.nix {
    system = platform;
    bootStdenv = pkgs.useDietLibC pkgs.stdenv;
  };

  pkgsStatic = import ../pkgs/top-level/all-packages.nix {
    system = platform;
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


  rootModules = 
    (config.get ["boot" "initrd" "kernelModules"]) ++
    (config.get ["boot" "initrd" "extraKernelModules"]);


  # Determine the set of modules that we need to mount the root FS.
  modulesClosure = import ../helpers/modules-closure.nix {
    inherit (pkgs) stdenv kernel module_init_tools;
    inherit rootModules;
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
    autoDetectRootDevice = config.get ["boot" "autoDetectRootDevice"];
    rootDevice =
      (pkgs.library.findSingle (fs: fs.mountPoint == "/")
        (abort "No root mount point declared.")
        (config.get ["fileSystems"])).device;
    rootLabel = config.get ["boot" "rootLabel"];
    inherit stage2Init;
    modulesDir = modulesClosure;
    modules = rootModules;
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
    inherit config pkgs nix splashThemes;
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
    inherit (pkgs) kernel;
    readOnlyRoot = config.get ["boot" "readOnlyRoot"];
    hostName = config.get ["networking" "hostName"];
    wrapperDir = setuidWrapper.wrapperDir;

    path = [
      pkgs.coreutils pkgs.gnugrep pkgs.findutils
      pkgs.glibc # needed for getent
      pkgs.pwdutils
    ];

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
    inherit activateConfiguration;
    readOnlyRoot = config.get ["boot" "readOnlyRoot"];
    upstartPath = [
      pkgs.coreutils
      pkgs.findutils
      pkgs.gnugrep
      pkgs.gnused
      pkgs.upstart
    ];
  };


  # Script to build the Grub menu containing the current and previous
  # system configurations.
  grubMenuBuilder = pkgs.substituteAll {
    src = ../installer/grub-menu-builder.sh;
    isExecutable = true;
    inherit (pkgs) bash;
    path = [pkgs.coreutils pkgs.gnused pkgs.gnugrep];
  };


  # Putting it all together.  This builds a store object containing
  # symlinks to the various parts of the built configuration (the
  # kernel, the Upstart services, the init scripts, etc.) as well as a
  # script `switch-to-configuration' that activates the configuration
  # and makes it bootable.
  system = pkgs.stdenvNew.mkDerivation {
    name = "system";
    builder = ./system.sh;
    switchToConfiguration = ./switch-to-configuration.sh;
    inherit (pkgs) grub coreutils gnused gnugrep diffutils findutils;
    grubDevice = config.get ["boot" "grubDevice"];
    kernelParams =
      (config.get ["boot" "kernelParams"]) ++
      (config.get ["boot" "extraKernelParams"]);
    inherit bootStage2;
    inherit activateConfiguration;
    inherit grubMenuBuilder;
    inherit etc;
    kernel = pkgs.kernel + "/vmlinuz";
    initrd = initialRamdisk + "/initrd";
    # Most of these are needed by grub-install.
    path = [
      pkgs.coreutils
      pkgs.gnused
      pkgs.gnugrep
      pkgs.findutils
      pkgs.diffutils
      pkgs.upstart # for initctl
    ];
  };


}
