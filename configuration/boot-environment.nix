{ system ? __currentSystem
, autoDetectRootDevice ? false
, rootDevice ? ""
, rootLabel ? ""
, stage2Init
, readOnlyRoot
}:

rec {

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
  extraUtils = pkgs.stdenv.mkDerivation {
    name = "extra-utils";
    builder = builtins.toFile "builder.sh" "
      source $stdenv/setup
      ensureDir $out/bin
      cp $utillinux/bin/mount $utillinux/bin/umount $utillinux/sbin/pivot_root $out/bin
      cp -p $e2fsprogs/sbin/fsck* $e2fsprogs/sbin/e2fsck $out/bin
      cp $splashutils/bin/splash_helper $out/bin
      nuke-refs $out/bin/*
    ";
    buildInputs = [pkgs.nukeReferences];
    inherit (pkgsStatic) utillinux;
    inherit (pkgs) splashutils;
    e2fsprogs = pkgs.e2fsprogsDiet;
  };
  

  # The init script of boot stage 1 (loading kernel modules for
  # mounting the root FS).
  bootStage1 = import ../boot/boot-stage-1.nix {
    inherit (pkgs) genericSubstituter;
    inherit (pkgsDiet) module_init_tools;
    inherit extraUtils;
    inherit autoDetectRootDevice rootDevice rootLabel;
    inherit stage2Init;
    modules = modulesClosure;
    shell = stdenvLinuxStuff.bootstrapTools.bash;
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
    inherit (pkgs) stdenv genericSubstituter;
    inherit nix;
    shell = pkgs.bash + "/bin/sh";
  };


  # The services (Upstart) configuration for the system.
  upstartJobs = import ../upstart-jobs/gather.nix {
    inherit (pkgs) stdenv;

    jobs = map makeJob [
      # Syslogd.
      (import ../upstart-jobs/syslogd.nix {
        inherit (pkgs) sysklogd;
      })

      # Hardware scan; loads modules for PCI devices.
      (import ../upstart-jobs/hardware-scan.nix {
        inherit (pkgs) kernel module_init_tools;
      })
      
      # Network interfaces.
      (import ../upstart-jobs/network-interfaces.nix {
        inherit (pkgs) nettools kernel module_init_tools;
      })
      
      # DHCP client.
      (import ../upstart-jobs/dhclient.nix {
        dhcp = pkgs.dhcpWrapper;
      })

      # SSH daemon.
      (import ../upstart-jobs/sshd.nix {
        inherit (pkgs) openssh;
      })

      # X server.
      (import ../upstart-jobs/xserver.nix {
        inherit (pkgs) genericSubstituter;
        inherit (pkgs.xorg) xorgserver xf86inputkeyboard xf86inputmouse xf86videovesa;
      })

      # Transparent TTY backgrounds.
      (import ../upstart-jobs/tty-backgrounds.nix {
        inherit (pkgs) stdenv splashutils;
        backgrounds = splashThemes.ttyBackgrounds;
      })

      # Handles the maintenance/stalled event (single-user shell).
      (import ../upstart-jobs/maintenance-shell.nix {
        inherit (pkgs) bash;
      })

      # Ctrl-alt-delete action.
      (import ../upstart-jobs/ctrl-alt-delete.nix)

    ]

    # Handles the reboot/halt events.
    ++ (map
      (event: makeJob (import ../upstart-jobs/halt.nix {
        inherit (pkgs) bash;
        inherit event;
      }))
      ["reboot" "halt" "system-halt" "power-off"]
    )
    
    # The terminals on ttyX.
    ++ (map 
      (ttyNumber: makeJob (import ../upstart-jobs/mingetty.nix {
        mingetty = pkgs.mingettyWrapper;
        inherit ttyNumber;
      }))
      [1 2 3 4 5 6]
    )

    # For the builtin logd job.
    ++ [pkgs.upstart];
  };

  
  makeJob = import ../upstart-jobs/make-job.nix {
    inherit (pkgs) stdenv;
  };


  setuidWrapper = import ../helpers/setuid {
    inherit (pkgs) stdenv;
    wrapperDir = "/var/setuid-wrappers";
  };


  # The init script of boot stage 2, which is supposed to do
  # everything else to bring up the system.
  bootStage2 = import ../boot/boot-stage-2.nix {
    inherit (pkgs) genericSubstituter buildEnv coreutils findutils
      utillinux kernel udev upstart;
    inherit setuidWrapper;
    inherit upstartJobs;
    shell = pkgs.bash + "/bin/sh";

    # Additional stuff; add whatever you want here.
    path = [
      pkgs.bash
      pkgs.bzip2
      pkgs.cpio
      pkgs.curl
      pkgs.e2fsprogs
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
      pkgs.rsync
      pkgs.shadowutils
      pkgs.strace
      pkgs.sysklogd
#      pkgs.vim
      nix
      nixosInstaller
    ];

    inherit readOnlyRoot;

    hostName = config.get ["networking" "hostname"];
  };


  lib = pkgs.library;


  config = rec {

    # The user configuration.
    config = {
      networking = {
        hostname = "vindaloo";
      };
    };

    # The option declarations, i.e., option names with defaults and
    # documentation.
    declarations = import ./options.nix;

    # Get the option named `name' from the user configuration, using
    # its default value if it's not defined.
    get = name:
      let
        sameName = lib.filter (opt: lib.eqLists opt.name name) declarations;
        default =
          if sameName == []
          then abort ("Undeclared option `" + printName name + "'.")
          else if !builtins.head sameName ? default
          then abort ("Option `" + printName name + "' has no default.")
          else (builtins.head sameName).default;
      in lib.getAttr name default config;
  
    printName = name: lib.concatStrings (lib.intersperse "." name);

  };


}
