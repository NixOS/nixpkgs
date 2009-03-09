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


  # Determine the set of modules that we need to mount the root FS.
  modulesClosure = pkgs.makeModulesClosure {
    rootModules =
      config.boot.initrd.extraKernelModules ++
      config.boot.initrd.kernelModules;
    kernel = modulesTree;
    allowMissing = config.boot.initrd.allowMissing;
  };


  # Some additional utilities needed in stage 1, like mount, lvm, fsck
  # etc.  We don't want to bring in all of those packages, so we just
  # copy what we need.  Instead of using statically linked binaries,
  # we just copy what we need from Glibc and use patchelf to make it
  # work.
  extraUtils = pkgs.runCommand "extra-utils"
    { buildInputs = [pkgs.nukeReferences];
      devicemapper = if config.boot.initrd.lvm then pkgs.devicemapper else null;
      lvm2 = if config.boot.initrd.lvm then pkgs.lvm2 else null;
      allowedReferences = ["out"]; # prevent accidents like glibc being included in the initrd
    }
    ''
      ensureDir $out/bin
      ensureDir $out/lib
      
      # Copy what we need from Glibc.
      cp -p ${pkgs.glibc}/lib/ld-linux*.so.2 $out/lib
      cp -p ${pkgs.glibc}/lib/libc.so.* $out/lib
      cp -p ${pkgs.glibc}/lib/libpthread.so.* $out/lib
      cp -p ${pkgs.glibc}/lib/librt.so.* $out/lib
      cp -p ${pkgs.glibc}/lib/libdl.so.* $out/lib

      # Copy some utillinux stuff.
      cp ${pkgs.utillinux}/bin/mount ${pkgs.utillinux}/bin/umount ${pkgs.utillinux}/sbin/pivot_root $out/bin

      # Copy e2fsck and friends.      
      cp ${pkgs.e2fsprogs}/sbin/e2fsck $out/bin
      cp ${pkgs.e2fsprogs}/sbin/tune2fs $out/bin
      cp ${pkgs.e2fsprogs}/sbin/fsck $out/bin
      ln -s e2fsck $out/bin/fsck.ext2
      ln -s e2fsck $out/bin/fsck.ext3
      ln -s e2fsck $out/bin/fsck.ext4

      cp -pd ${pkgs.e2fsprogs}/lib/lib*.so.* $out/lib

      # Copy devicemapper and lvm, if we need it.
      if test -n "$devicemapper"; then
        cp $devicemapper/sbin/dmsetup $out/bin/dmsetup
        cp $devicemapper/lib/libdevmapper.so.*.* $out/lib
        cp $lvm2/sbin/lvm $out/bin/lvm
      fi

      # Copy udev.
      cp ${pkgs.udev}/sbin/udevd ${pkgs.udev}/sbin/udevadm $out/bin
      cp ${pkgs.udev}/lib/udev/*_id $out/bin
      cp ${pkgs.udev}/lib/libvolume_id.so.* $out/lib
      
      # Copy bash.
      cp ${pkgs.bash}/bin/bash $out/bin
      ln -s bash $out/bin/sh

      # Run patchelf to make the programs refer to the copied libraries.
      for i in $out/bin/* $out/lib/*; do if ! test -L $i; then nuke-refs $i; fi; done

      for i in $out/bin/*; do
          if ! test -L $i; then
              echo "patching $i..."
              patchelf --set-interpreter $out/lib/ld-linux*.so.2 --set-rpath $out/lib $i || true
          fi
      done

      # Make sure that the patchelf'ed binaries still work.
      echo "testing patched programs..."
      $out/bin/bash --version
      export LD_LIBRARY_PATH=$out/lib
      $out/bin/mount --version
      $out/bin/umount --version
      $out/bin/e2fsck -V
      $out/bin/tune2fs 2> /dev/null | grep "tune2fs "
      $out/bin/fsck -N
      $out/bin/udevadm --version
      $out/bin/vol_id 2>&1 | grep "no device"
      if test -n "$devicemapper"; then
          $out/bin/dmsetup --version | grep "version:"
          LVM_SYSTEM_DIR=$out $out/bin/lvm 2>&1 | grep "LVM"
      fi
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
      cp ${pkgs.udev}/*/udev/rules.d/60-persistent-storage.rules $out/
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

    shell = "${extraUtils}/bin/bash";

    isExecutable = true;

    inherit modulesClosure udevConf extraUtils;
    
    inherit (config.boot) isLiveCD resumeDevice;

    # !!! copy&pasted from upstart-jobs/filesystems.nix.
    mountPoints =
      if fileSystems == null
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
      pkgs.klibcShrunk
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
