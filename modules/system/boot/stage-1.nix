# This module builds the initial ramdisk, which contains an init
# script that performs the first stage of booting the system: it loads
# the modules necessary to mount the root file system, then calls the
# init in the root file system to start the second boot stage.

{ config, pkgs, ... }:

with pkgs.lib;

let

  options = {

    boot.resumeDevice = mkOption {
      default = "";
      example = "0:0";
      description = "
        Device for manual resume attempt during boot. Looks like 
        major:minor. ls -l /dev/SWAP_PARTION shows them.
      ";
    };

    boot.initrd.enableSplashScreen = mkOption {
      default = true;
      description = "
        Whether to show a nice splash screen while booting.
      ";
    };

    boot.initrd.checkJournalingFS = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Whether to run fsck on journaling filesystems such as ext3.
      '';
    };

    boot.initrd.postDeviceCommands = mkOption {
      default = "";
      merge = mergeStringOption;
      description = ''
        Shell commands to be executed immediately after stage 1 of the
        boot has loaded kernel modules and created device nodes in
        /dev.
      '';
    };

    boot.initrd.postMountCommands = mkOption {
      default = "";
      merge = mergeStringOption;
      description = ''
        Shell commands to be executed immediately after the stage 1
        filesystems have been mounted.
      '';
    };

    boot.initrd.extraUtilsCommands = mkOption {
      internal = true;
      default = "";
      merge = mergeStringOption;
      description = ''
        Shell commands to be executed in the builder of the
        extra-utils derivation.  This can be used to provide
        additional utilities in the initial ramdisk.
      '';
    };

    fileSystems = mkOption {
      options.neededForBoot = mkOption {
        default = false;
        type = types.bool;
        description = "
          Mount this file system to boot on NixOS.
        ";
      };
    };
  
  };


  kernelPackages = config.boot.kernelPackages;
  modulesTree = config.system.modulesTree;


  # Determine the set of modules that we need to mount the root FS.
  modulesClosure = pkgs.makeModulesClosure {
    rootModules = config.boot.initrd.availableKernelModules ++ config.boot.initrd.kernelModules;
    kernel = modulesTree;
    allowMissing = true;
  };


  enableSplashScreen =
    config.boot.initrd.enableSplashScreen && kernelPackages.splashutils != null;


  # Some additional utilities needed in stage 1, like mount, lvm, fsck
  # etc.  We don't want to bring in all of those packages, so we just
  # copy what we need.  Instead of using statically linked binaries,
  # we just copy what we need from Glibc and use patchelf to make it
  # work.
  extraUtils = pkgs.runCommand "extra-utils"
    { buildInputs = [pkgs.nukeReferences];
      allowedReferences = [ "out" modulesClosure ]; # prevent accidents like glibc being included in the initrd
      doublePatchelf = (pkgs.stdenv.system == "armv5tel-linux");
    }
    ''
      ensureDir $out/bin
      ensureDir $out/lib
      
      # Copy what we need from Glibc.
      cp -pv ${pkgs.glibc}/lib/ld-linux*.so.? $out/lib
      cp -pv ${pkgs.glibc}/lib/libc.so.* $out/lib
      cp -pv ${pkgs.glibc}/lib/libpthread.so.* $out/lib
      cp -pv ${pkgs.glibc}/lib/librt.so.* $out/lib
      cp -pv ${pkgs.glibc}/lib/libdl.so.* $out/lib
      cp -pv ${pkgs.gcc.gcc}/lib*/libgcc_s.so.* $out/lib

      # Copy some utillinux stuff.
      cp -v ${pkgs.utillinux}/bin/mount ${pkgs.utillinux}/bin/umount \
         ${pkgs.utillinux}/sbin/fsck ${pkgs.utillinux}/sbin/switch_root \
         ${pkgs.utillinux}/sbin/blkid $out/bin
      cp -pdv ${pkgs.utillinux}/lib/libblkid*.so.* $out/lib
      cp -pdv ${pkgs.utillinux}/lib/libuuid*.so.* $out/lib

      # Copy some coreutils.
      cp -v ${pkgs.coreutils}/bin/basename $out/bin
      cp -v ${pkgs.coreutils}/bin/mkdir $out/bin
      cp -v ${pkgs.coreutils}/bin/mknod $out/bin
      cp -v ${pkgs.coreutils}/bin/cat $out/bin
      cp -v ${pkgs.coreutils}/bin/chroot $out/bin
      cp -v ${pkgs.coreutils}/bin/sleep $out/bin

      # Copy e2fsck and friends.      
      cp -v ${pkgs.e2fsprogs}/sbin/e2fsck $out/bin
      cp -v ${pkgs.e2fsprogs}/sbin/tune2fs $out/bin
      cp -v ${pkgs.reiserfsprogs}/sbin/reiserfsck $out/bin
      ln -sv e2fsck $out/bin/fsck.ext2
      ln -sv e2fsck $out/bin/fsck.ext3
      ln -sv e2fsck $out/bin/fsck.ext4
      ln -sv reiserfsck $out/bin/fsck.reiserfs

      cp -pdv ${pkgs.e2fsprogs}/lib/lib*.so.* $out/lib

      # Copy dmsetup and lvm.
      cp -v ${pkgs.lvm2}/sbin/dmsetup $out/bin/dmsetup
      cp -v ${pkgs.lvm2}/sbin/lvm $out/bin/lvm
      cp -v ${pkgs.lvm2}/lib/libdevmapper.so.*.* $out/lib

      # Add RAID mdadm tool.
      cp -v ${pkgs.mdadm}/sbin/mdadm $out/bin/mdadm

      # Copy udev.
      cp -v ${pkgs.udev}/sbin/udevd ${pkgs.udev}/sbin/udevadm $out/bin
      cp -v ${pkgs.udev}/libexec/*_id $out/bin
      cp -pdv ${pkgs.udev}/lib/libudev.so.* $out/lib
      
      # Copy bash.
      cp -v ${pkgs.bash}/bin/bash $out/bin
      ln -sv bash $out/bin/sh

      # Copy modprobe.
      cp -v ${pkgs.module_init_tools}/sbin/modprobe $out/bin/modprobe.real

      # Maybe copy splashutils.
      ${optionalString enableSplashScreen ''
        cp ${kernelPackages.splashutils}/${kernelPackages.splashutils.helperName} $out/bin/splash_helper
      ''}

      ${config.boot.initrd.extraUtilsCommands}

      # Run patchelf to make the programs refer to the copied libraries.
      for i in $out/bin/* $out/lib/*; do if ! test -L $i; then nuke-refs $i; fi; done

      for i in $out/bin/*; do
          if ! test -L $i; then
              echo "patching $i..."
              patchelf --set-interpreter $out/lib/ld-linux*.so.? --set-rpath $out/lib $i || true
              if [ -n "$doublePatchelf" ]; then
                  patchelf --set-interpreter $out/lib/ld-linux*.so.? --set-rpath $out/lib $i || true
              fi
          fi
      done

      # Make the modprobe wrapper that sets $MODULE_DIR.
      cat > $out/bin/modprobe <<EOF
      #! $out/bin/bash
      export MODULE_DIR=${modulesClosure}/lib/modules
      exec $out/bin/modprobe.real "\$@"
      EOF
      chmod u+x $out/bin/modprobe
      
      # Make sure that the patchelf'ed binaries still work.
      echo "testing patched programs..."
      $out/bin/bash --version | grep "bash, version"
      export LD_LIBRARY_PATH=$out/lib
      $out/bin/mount --version | grep "mount from"
      $out/bin/umount --version | grep "umount "
      $out/bin/e2fsck -V 2>&1 | grep "e2fsck "
      $out/bin/tune2fs 2> /dev/null | grep "tune2fs "
      $out/bin/fsck -N | grep "fsck from"
      $out/bin/udevadm --version
      $out/bin/blkid -v 2>&1 | tee -a $out/log | grep "blkid from util-linux-ng"
      $out/bin/dmsetup --version 2>&1 | tee -a $out/log | grep "version:"
      LVM_SYSTEM_DIR=$out $out/bin/lvm 2>&1 | tee -a $out/log | grep "LVM"
      $out/bin/reiserfsck -V
      $out/bin/mdadm --version
      $out/bin/basename --version
      $out/bin/modprobe --version
    ''; # */
  

  # The initrd only has to mount / or any FS marked as necessary for
  # booting (such as the FS containing /nix/store, or an FS needed for
  # mounting /, like / on a loopback).
  fileSystems = filter
    (fs: fs.mountPoint == "/" || fs.neededForBoot)
    config.fileSystems;


  udevRules = pkgs.stdenv.mkDerivation {
    name = "udev-rules";
    buildCommand = ''
      ensureDir $out
      
      cp ${pkgs.udev}/libexec/rules.d/60-cdrom_id.rules $out/
      cp ${pkgs.udev}/libexec/rules.d/60-persistent-storage.rules $out/
      cp ${pkgs.udev}/libexec/rules.d/80-drivers.rules $out/
      cp ${pkgs.lvm2}/lib/udev/rules.d/*.rules $out/
      cp ${pkgs.mdadm}/lib/udev/rules.d/*.rules $out/

      for i in $out/*.rules; do
          substituteInPlace $i \
            --replace ata_id ${extraUtils}/bin/ata_id \
            --replace usb_id ${extraUtils}/bin/usb_id \
            --replace scsi_id ${extraUtils}/bin/scsi_id \
            --replace path_id ${extraUtils}/bin/path_id \
            --replace vol_id ${extraUtils}/bin/vol_id \
            --replace cdrom_id ${extraUtils}/bin/cdrom_id \
            --replace /sbin/blkid ${extraUtils}/bin/blkid \
            --replace /sbin/modprobe ${extraUtils}/bin/modprobe \
            --replace '$env{DM_SBIN_PATH}/blkid' ${extraUtils}/bin/blkid \
            --replace 'ENV{DM_SBIN_PATH}="/sbin"' 'ENV{DM_SBIN_PATH}="${extraUtils}/bin"' \
            --replace /sbin/mdadm ${extraUtils}/bin/mdadm
      done

      # Remove rule preventing creation of a by-label symlink
      # for a CD-ROM if disk removal will not be properly reported.
      # Such a link can get obsolete in a running system, but 
      # during boot stage 1 it is unlikely. We need this change
      # to be able to boot on a wider choice of CD drives.
      sed -e '/^ENV[{]DEVTYPE[}]=="disk", .*GOTO/d' -i $out/60-persistent-storage.rules

      # Work around a bug in QEMU, which doesn't implement the "READ
      # DISC INFORMATION" SCSI command:
      #   https://bugzilla.redhat.com/show_bug.cgi?id=609049
      # As a result, `cdrom_id' doesn't print
      # ID_CDROM_MEDIA_TRACK_COUNT_DATA, which in turn prevents the
      # /dev/disk/by-label symlinks from being created.  We need these
      # in the NixOS installation CD, so use ID_CDROM_MEDIA in the
      # corresponding udev rules for now.  This was the behaviour in
      # udev <= 154.  See also
      #   http://www.spinics.net/lists/hotplug/msg03935.html
      substituteInPlace $out/60-persistent-storage.rules \
        --replace ID_CDROM_MEDIA_TRACK_COUNT_DATA ID_CDROM_MEDIA
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
    src = ./stage-1-init.sh;

    shell = "${extraUtils}/bin/bash";

    isExecutable = true;

    inherit udevConf extraUtils;

    inherit (config.boot) resumeDevice devSize;

    inherit (config.boot.initrd) checkJournalingFS
      postDeviceCommands postMountCommands kernelModules;

    # !!! copy&pasted from upstart-jobs/filesystems.nix.
    mountPoints =
      if fileSystems == null
      then abort "You must specify the fileSystems option!"
      else map (fs: fs.mountPoint) fileSystems;
    devices = map (fs: if fs.device != null then fs.device else "/dev/disk/by-label/${fs.label}") fileSystems;
    fsTypes = map (fs: fs.fsType) fileSystems;
    optionss = map (fs: fs.options) fileSystems;
  };


  # The closure of the init script of boot stage 1 is what we put in
  # the initial RAM disk.
  initialRamdisk = pkgs.makeInitrd {
    contents =
      [ { object = bootStage1;
          symlink = "/init";
        }
      ] ++ optionals enableSplashScreen
        [ { object = extraUtils;
            suffix = "/bin/splash_helper";
            symlink = "/${kernelPackages.splashutils.helperName}";
          }
          { object = import ../../../lib/unpack-theme.nix {
              inherit (pkgs) stdenv;
              theme = config.services.ttyBackgrounds.defaultTheme;
            };
            symlink = "/etc/splash";
          }
        ];
  };
  
in {

  require = [options];

  system.build.bootStage1 = bootStage1;
  system.build.initialRamdisk = initialRamdisk;

}
