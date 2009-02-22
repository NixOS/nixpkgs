# This Nix expression builds the initial ramdisk, which contains an
# init script that performs the first stage of booting the system: it
# loads the modules necessary to mount the root file system, then
# calls the init in the root file system to start the second boot
# stage.

{pkgs, config}:

let
  kernelPackages = config.boot.kernelPackages;
  modulesTree = config.system.modulesTree;
in

rec {

  pkgsDiet = import "${pkgs.path}/top-level/all-packages.nix" {
    system = pkgs.stdenv.system;
    bootStdenv = pkgs.useDietLibC pkgs.stdenv;
  };

  pkgsKlibc = import "${pkgs.path}/top-level/all-packages.nix" {
    system = pkgs.stdenv.system;
    bootStdenv = pkgs.useKlibc pkgs.stdenv kernelPackages.klibc;
  };

  pkgsStatic = import "${pkgs.path}/top-level/all-packages.nix" {
    system = pkgs.stdenv.system;
    bootStdenv = pkgs.makeStaticBinaries pkgs.stdenv;
  };

  stdenvLinuxStuff = import "${pkgs.path}/stdenv/linux" {
    system = pkgs.stdenv.system;
    allPackages = import "${pkgs.path}/top-level/all-packages.nix";
  };
  

  # Determine the set of modules that we need to mount the root FS.
  modulesClosure = pkgs.makeModulesClosure {
    rootModules =
      config.boot.initrd.extraKernelModules ++
      config.boot.initrd.kernelModules;
    kernel = modulesTree;
    allowMissing = config.boot.initrd.allowMissing;
  };


  udev = pkgsKlibc.udev;

    
  # Some additional utilities needed in stage 1, notably mount.  We
  # don't want to bring in all of util-linux, so we just copy what we
  # need.
  extraUtils = pkgs.runCommand "extra-utils"
    { buildInputs = [pkgs.nukeReferences];
      inherit (pkgsStatic) utillinux;
      inherit udev;
      e2fsprogs = pkgsDiet.e2fsprogs;
      devicemapper =
        if config.boot.initrd.lvm
        then assert pkgs.devicemapper.enableStatic; pkgs.devicemapper
        else null;
      lvm2 =
        if config.boot.initrd.lvm
        then assert pkgs.lvm2.enableStatic; pkgs.lvm2
        else null;
      allowedReferences = []; # prevent accidents like glibc being included in the initrd
    }
    ''
      ensureDir $out/bin
      if test -n "$devicemapper"; then
        cp $devicemapper/sbin/dmsetup.static $out/bin/dmsetup
        cp $lvm2/sbin/lvm.static $out/bin/lvm
      fi
      cp $utillinux/bin/mount $utillinux/bin/umount $utillinux/sbin/pivot_root $out/bin
      cp -p $e2fsprogs/sbin/fsck* $e2fsprogs/sbin/e2fsck $e2fsprogs/sbin/tune2fs $out/bin
      cp $udev/sbin/udevd $udev/sbin/udevadm $out/bin
      cp $udev/lib/udev/*_id $out/bin
      nuke-refs $out/bin/*
    ''; # */
  

  # The initrd only has to mount / or any FS marked as necessary for
  # booting (such as the FS containing /nix/store, or an FS needed for
  # mounting /, like / on a loopback).
  fileSystems = pkgs.lib.filter
    (fs: fs.mountPoint == "/" || (fs ? neededForBoot && fs.neededForBoot))
    config.fileSystems;


  udevRules = pkgs.stdenv.mkDerivation {
    name = "udev-rules";
    buildCommand = ''
      ensureDir $out
      cp ${udev}/*/udev/rules.d/60-persistent-storage.rules $out/
      substituteInPlace $out/60-persistent-storage.rules \
        --replace ata_id ${extraUtils}/bin/ata_id \
        --replace usb_id ${extraUtils}/bin/usb_id \
        --replace scsi_id ${extraUtils}/bin/scsi_id \
        --replace path_id ${extraUtils}/bin/path_id \
        --replace vol_id ${extraUtils}/bin/vol_id
    ''; # */
  };

  
  # The udev configuration file for in the initrd.
  udevConf = pkgs.writeText "udev-initrd.conf" ''
    udev_rules="${udevRules}"
    #udev_log="debug"
  '';
  

  # The init script of boot stage 1 (loading kernel modules for
  # mounting the root FS).
  bootStage1 = pkgs.substituteAll {
    src = ./boot-stage-1-init.sh;

    isExecutable = true;

    staticShell = stdenvLinuxStuff.bootstrapTools.bash;
    
    inherit modulesClosure udevConf;
    
    inherit (config.boot) isLiveCD resumeDevice;

    # !!! copy&pasted from upstart-jobs/filesystems.nix.
    mountPoints =
      if fileSystems == []
      then abort "You must specify the fileSystems option!"
      else map (fs: fs.mountPoint) fileSystems;
    devices = map (fs: if fs ? device then fs.device else "/dev/disk/by-label/${fs.label}") fileSystems;
    fsTypes = map (fs: if fs ? fsType then fs.fsType else "auto") fileSystems;
    optionss = map (fs: if fs ? options then fs.options else "defaults") fileSystems;

    path = [
      # `extraUtils' comes first because it overrides the `mount'
      # command provided by klibc (which isn't capable of
      # auto-detecting FS types).
      extraUtils
      kernelPackages.klibcShrunk
    ];
  };


  # The closure of the init script of boot stage 1 is what we put in
  # the initial RAM disk.
  initialRamdisk = pkgs.makeInitrd {
    contents = [
      { object = bootStage1;
        symlink = "/init";
      }
    ] ++
      pkgs.lib.optionals
        (config.boot.initrd.enableSplashScreen && kernelPackages.splashutils != null)
        [
          { object = pkgs.runCommand "splashutils" {allowedReferences = []; buildInputs = [pkgs.nukeReferences];} ''
              ensureDir $out/bin
              cp ${kernelPackages.splashutils}/${kernelPackages.splashutils.helperName} $out/bin/splash_helper
              nuke-refs $out/bin/*
            '';
            suffix = "/bin/splash_helper";
            symlink = "/${kernelPackages.splashutils.helperName}";
          } # */
          { object = import ../helpers/unpack-theme.nix {
              inherit (pkgs) stdenv;
              theme = config.services.ttyBackgrounds.defaultTheme;
            };
            symlink = "/etc/splash";
          }
        ];
  };
  
}
