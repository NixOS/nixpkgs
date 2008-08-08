# This Nix expression builds the initial ramdisk, which contains an
# init script that performs the first stage of booting the system: it
# loads the modules necessary to mount the root file system, then
# calls the init in the root file system to start the second boot
# stage.

{ pkgs, config, nixpkgsPath, kernelPackages, modulesTree }:

rec {

  pkgsDiet = import "${nixpkgsPath}/pkgs/top-level/all-packages.nix" {
    system = pkgs.stdenv.system;
    bootStdenv = pkgs.useDietLibC pkgs.stdenv;
  };

  pkgsStatic = import "${nixpkgsPath}/pkgs/top-level/all-packages.nix" {
    system = pkgs.stdenv.system;
    bootStdenv = pkgs.makeStaticBinaries pkgs.stdenv;
  };

  stdenvLinuxStuff = import "${nixpkgsPath}/pkgs/stdenv/linux" {
    system = pkgs.stdenv.system;
    allPackages = import "${nixpkgsPath}/pkgs/top-level/all-packages.nix";
  };
  

  # Determine the set of modules that we need to mount the root FS.
  modulesClosure = pkgs.makeModulesClosure {
    rootModules =
      config.boot.initrd.extraKernelModules ++
      config.boot.initrd.kernelModules;
    kernel = modulesTree;
    allowMissing = config.boot.initrd.allowMissing;
  };


  # Some additional utilities needed in stage 1, notably mount.  We
  # don't want to bring in all of util-linux, so we just copy what we
  # need.
  extraUtils = pkgs.runCommand "extra-utils"
    { buildInputs = [pkgs.nukeReferences];
      inherit (pkgsStatic) utillinux;
      inherit (pkgsDiet) udev;
      e2fsprogs = pkgs.e2fsprogsDiet;
      devicemapper = if config.boot.initrd.lvm then pkgs.devicemapperStatic else null;
      lvm2 = if config.boot.initrd.lvm then pkgs.lvm2Static else null;
      allowedReferences = []; # prevent accidents like glibc being included in the initrd
    }
    ''
      ensureDir $out/bin
      if test -n "$devicemapper"; then
        cp $devicemapper/sbin/dmsetup.static $out/bin/dmsetup
        cp $lvm2/sbin/lvm.static $out/bin/lvm
      fi
      cp $utillinux/bin/mount $utillinux/bin/umount $utillinux/sbin/pivot_root $out/bin
      cp -p $e2fsprogs/sbin/fsck* $e2fsprogs/sbin/e2fsck $out/bin
      cp $udev/sbin/udevd $udev/sbin/udevadm $out/bin
      nuke-refs $out/bin/*
    ''; # */
  

  # The initrd only has to mount / or any FS marked as necessary for
  # booting (such as the FS containing /nix/store, or an FS needed for
  # mounting /, like / on a loopback).
  fileSystems = pkgs.lib.filter
    (fs: fs.mountPoint == "/" || (fs ? neededForBoot && fs.neededForBoot))
    config.fileSystems;

    
  # The init script of boot stage 1 (loading kernel modules for
  # mounting the root FS).
  bootStage1 = pkgs.substituteAll {
    src = ./boot-stage-1-init.sh;

    isExecutable = true;

    staticShell = stdenvLinuxStuff.bootstrapTools.bash;
    
    inherit modulesClosure;
    
    inherit (config.boot) autoDetectRootDevice isLiveCD resumeDevice;

    # !!! copy&pasted from upstart-jobs/filesystems.nix.
    mountPoints =
      if !config.boot.autoDetectRootDevice && fileSystems == []
      then abort "You must specify the fileSystems option!"
      else map (fs: fs.mountPoint) fileSystems;
    devices = map (fs: if fs ? device then fs.device else "LABEL=" + fs.label) fileSystems;
    fsTypes = map (fs: if fs ? fsType then fs.fsType else "auto") fileSystems;
    optionss = map (fs: if fs ? options then fs.options else "defaults") fileSystems;

    rootLabel = if config.boot.autoDetectRootDevice then config.boot.rootLabel else "";

    path = [
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
