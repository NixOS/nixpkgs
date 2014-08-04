# This module builds the initial ramdisk, which contains an init
# script that performs the first stage of booting the system: it loads
# the modules necessary to mount the root file system, then calls the
# init in the root file system to start the second boot stage.

{ config, lib, pkgs, ... }:

with lib;

let

  udev = config.systemd.package;

  kernelPackages = config.boot.kernelPackages;
  modulesTree = config.system.modulesTree;


  # Determine the set of modules that we need to mount the root FS.
  modulesClosure = pkgs.makeModulesClosure {
    rootModules = config.boot.initrd.availableKernelModules ++ config.boot.initrd.kernelModules;
    kernel = modulesTree;
    allowMissing = true;
  };


  # Some additional utilities needed in stage 1, like mount, lvm, fsck
  # etc.  We don't want to bring in all of those packages, so we just
  # copy what we need.  Instead of using statically linked binaries,
  # we just copy what we need from Glibc and use patchelf to make it
  # work.
  extraUtils = pkgs.runCommand "extra-utils"
    { buildInputs = [pkgs.nukeReferences];
      allowedReferences = [ "out" ]; # prevent accidents like glibc being included in the initrd
      doublePatchelf = pkgs.stdenv.isArm;
    }
    ''
      mkdir -p $out/bin $out/lib
      ln -s $out/bin $out/sbin

      # Copy what we need from Glibc.
      cp -pv ${pkgs.glibc}/lib/ld*.so.? $out/lib
      cp -pv ${pkgs.glibc}/lib/libc.so.* $out/lib
      cp -pv ${pkgs.glibc}/lib/libm.so.* $out/lib
      cp -pv ${pkgs.glibc}/lib/libpthread.so.* $out/lib
      cp -pv ${pkgs.glibc}/lib/librt.so.* $out/lib
      cp -pv ${pkgs.glibc}/lib/libdl.so.* $out/lib
      cp -pv ${pkgs.gcc.gcc}/lib*/libgcc_s.so.* $out/lib

      # Copy BusyBox.
      cp -pvd ${pkgs.busybox}/bin/* ${pkgs.busybox}/sbin/* $out/bin/

      # Copy some utillinux stuff.
      cp -vf ${pkgs.utillinux}/sbin/blkid $out/bin
      cp -pdv ${pkgs.utillinux}/lib/libblkid*.so.* $out/lib
      cp -pdv ${pkgs.utillinux}/lib/libuuid*.so.* $out/lib

      # Copy dmsetup and lvm.
      cp -v ${pkgs.lvm2}/sbin/dmsetup $out/bin/dmsetup
      cp -v ${pkgs.lvm2}/sbin/lvm $out/bin/lvm
      cp -v ${pkgs.lvm2}/lib/libdevmapper.so.*.* $out/lib
      cp -v ${pkgs.systemd}/lib/libsystemd.so.* $out/lib

      # Add RAID mdadm tool.
      cp -v ${pkgs.mdadm}/sbin/mdadm $out/bin/mdadm

      # Copy udev.
      cp -v ${udev}/lib/systemd/systemd-udevd ${udev}/bin/udevadm $out/bin
      cp -v ${udev}/lib/udev/*_id $out/bin
      cp -pdv ${udev}/lib/libudev.so.* $out/lib
      cp -v ${pkgs.kmod}/lib/libkmod.so.* $out/lib
      cp -v ${pkgs.acl}/lib/libacl.so.* $out/lib
      cp -v ${pkgs.attr}/lib/libattr.so.* $out/lib

      # Copy modprobe.
      cp -v ${pkgs.kmod}/bin/kmod $out/bin/
      ln -sf kmod $out/bin/modprobe

      ${config.boot.initrd.extraUtilsCommands}

      # Strip binaries further than normal.
      chmod -R u+w $out
      stripDirs "lib bin" "-s"

      # Run patchelf to make the programs refer to the copied libraries.
      for i in $out/bin/* $out/lib/*; do if ! test -L $i; then nuke-refs $i; fi; done

      for i in $out/bin/*; do
          if ! test -L $i; then
              echo "patching $i..."
              patchelf --set-interpreter $out/lib/ld*.so.? --set-rpath $out/lib $i || true
              if [ -n "$doublePatchelf" ]; then
                  patchelf --set-interpreter $out/lib/ld*.so.? --set-rpath $out/lib $i || true
              fi
          fi
      done

      # Make sure that the patchelf'ed binaries still work.
      echo "testing patched programs..."
      $out/bin/ash -c 'echo hello world' | grep "hello world"
      export LD_LIBRARY_PATH=$out/lib
      $out/bin/mount --help 2>&1 | grep "BusyBox"
      $out/bin/udevadm --version
      $out/bin/dmsetup --version 2>&1 | tee -a log | grep "version:"
      LVM_SYSTEM_DIR=$out $out/bin/lvm version 2>&1 | tee -a log | grep "LVM"
      $out/bin/mdadm --version

      ${config.boot.initrd.extraUtilsCommandsTest}
    ''; # */


  # The initrd only has to mount / or any FS marked as necessary for
  # booting (such as the FS containing /nix/store, or an FS needed for
  # mounting /, like / on a loopback).
  fileSystems = filter
    (fs: fs.neededForBoot || elem fs.mountPoint [ "/" "/nix" "/nix/store" "/var" "/var/log" "/var/lib" "/etc" ])
    (attrValues config.fileSystems);


  udevRules = pkgs.stdenv.mkDerivation {
    name = "udev-rules";
    buildCommand = ''
      ensureDir $out

      echo 'ENV{LD_LIBRARY_PATH}="${extraUtils}/lib"' > $out/00-env.rules

      cp -v ${udev}/lib/udev/rules.d/60-cdrom_id.rules $out/
      cp -v ${udev}/lib/udev/rules.d/60-persistent-storage.rules $out/
      cp -v ${udev}/lib/udev/rules.d/80-drivers.rules $out/
      cp -v ${pkgs.lvm2}/lib/udev/rules.d/*.rules $out/
      cp -v ${pkgs.mdadm}/lib/udev/rules.d/*.rules $out/

      for i in $out/*.rules; do
          substituteInPlace $i \
            --replace ata_id ${extraUtils}/bin/ata_id \
            --replace scsi_id ${extraUtils}/bin/scsi_id \
            --replace cdrom_id ${extraUtils}/bin/cdrom_id \
            --replace ${pkgs.utillinux}/sbin/blkid ${extraUtils}/bin/blkid \
            --replace /sbin/blkid ${extraUtils}/bin/blkid \
            --replace ${pkgs.lvm2}/sbin ${extraUtils}/bin \
            --replace /sbin/mdadm ${extraUtils}/bin/mdadm
      done

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


  # The binary keymap for busybox to load at boot.
  busyboxKeymap = pkgs.runCommand "boottime-keymap"
    { preferLocalBuild = true; }
    ''
      ${pkgs.kbd}/bin/loadkeys -qb "${config.i18n.consoleKeyMap}" > $out ||
        ${pkgs.kbd}/bin/loadkeys -qbu "${config.i18n.consoleKeyMap}" > $out
    '';


  # The init script of boot stage 1 (loading kernel modules for
  # mounting the root FS).
  bootStage1 = pkgs.substituteAll {
    src = ./stage-1-init.sh;

    shell = "${extraUtils}/bin/ash";

    isExecutable = true;

    inherit udevRules extraUtils modulesClosure busyboxKeymap;

    inherit (config.boot) resumeDevice devSize runSize;

    inherit (config.boot.initrd) checkJournalingFS
      preLVMCommands postDeviceCommands postMountCommands kernelModules;

    fsInfo =
      let f = fs: [ fs.mountPoint (if fs.device != null then fs.device else "/dev/disk/by-label/${fs.label}") fs.fsType fs.options ];
      in pkgs.writeText "initrd-fsinfo" (concatStringsSep "\n" (concatMap f fileSystems));
  };


  # The closure of the init script of boot stage 1 is what we put in
  # the initial RAM disk.
  initialRamdisk = pkgs.makeInitrd {
    inherit (config.boot.initrd) compressor;

    contents =
      [ { object = bootStage1;
          symlink = "/init";
        }
        { object = pkgs.writeText "mdadm.conf" config.boot.initrd.mdadmConf;
          symlink = "/etc/mdadm.conf";
        }
      ];
  };

in

{
  options = {

    boot.resumeDevice = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "8:2";
      description = ''
        Device for manual resume attempt during boot, specified using
        the device's major and minor number as
        <literal><replaceable>major</replaceable>:<replaceable>minor</replaceable></literal>.
      '';
    };

    boot.initrd.checkJournalingFS = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Whether to run <command>fsck</command> on journaling filesystems such as ext3.
      '';
    };

    boot.initrd.mdadmConf = mkOption {
      default = "";
      type = types.lines;
      description = ''
        Contents of <filename>/etc/mdadm.conf</filename> in stage 1.
      '';
    };

    boot.initrd.preLVMCommands = mkOption {
      default = "";
      type = types.lines;
      description = ''
        Shell commands to be executed immediately before LVM discovery.
      '';
    };

    boot.initrd.postDeviceCommands = mkOption {
      default = "";
      type = types.lines;
      description = ''
        Shell commands to be executed immediately after stage 1 of the
        boot has loaded kernel modules and created device nodes in
        <filename>/dev</filename>.
      '';
    };

    boot.initrd.postMountCommands = mkOption {
      default = "";
      type = types.lines;
      description = ''
        Shell commands to be executed immediately after the stage 1
        filesystems have been mounted.
      '';
    };

    boot.initrd.extraUtilsCommands = mkOption {
      internal = true;
      default = "";
      type = types.lines;
      description = ''
        Shell commands to be executed in the builder of the
        extra-utils derivation.  This can be used to provide
        additional utilities in the initial ramdisk.
      '';
    };

    boot.initrd.extraUtilsCommandsTest = mkOption {
      internal = true;
      default = "";
      type = types.lines;
      description = ''
        Shell commands to be executed in the builder of the
        extra-utils derivation after patchelf has done its
        job.  This can be used to test additional utilities
        copied in extraUtilsCommands.
      '';
    };

    boot.initrd.compressor = mkOption {
      internal = true;
      default = "gzip -9";
      type = types.str;
      description = "The compressor to use on the initrd image.";
      example = "xz";
    };

    boot.initrd.supportedFilesystems = mkOption {
      default = [ ];
      example = [ "btrfs" ];
      type = types.listOf types.string;
      description = "Names of supported filesystem types in the initial ramdisk.";
    };

    fileSystems = mkOption {
      options.neededForBoot = mkOption {
        default = false;
        type = types.bool;
        description = ''
          If set, this file system will be mounted in the initial
          ramdisk.  By default, this applies to the root file system
          and to the file system containing
          <filename>/nix/store</filename>.
        '';
      };
    };

  };

  config = mkIf (!config.boot.isContainer) {

    assertions = singleton
      { assertion = any (fs: fs.mountPoint == "/") (attrValues config.fileSystems);
        message = "The ‘fileSystems’ option does not specify your root file system.";
      };

    system.build.bootStage1 = bootStage1;
    system.build.initialRamdisk = initialRamdisk;
    system.build.extraUtils = extraUtils;

    system.requiredKernelConfig = with config.lib.kernelConfig; [
      (isYes "TMPFS")
      (isYes "BLK_DEV_INITRD")
    ];

    # Prevent systemd from waiting for the /dev/root symlink.
    systemd.units."dev-root.device".text = "";

    boot.initrd.supportedFilesystems = map (fs: fs.fsType) fileSystems;

  };
}
