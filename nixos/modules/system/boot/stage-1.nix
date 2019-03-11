# This module builds the initial ramdisk, which contains an init
# script that performs the first stage of booting the system: it loads
# the modules necessary to mount the root file system, then calls the
# init in the root file system to start the second boot stage.

{ config, lib, utils, pkgs, ... }:

with lib;

let

  udev = config.systemd.package;

  modulesTree = config.system.modulesTree;
  firmware = config.hardware.firmware;


  # Determine the set of modules that we need to mount the root FS.
  modulesClosure = pkgs.makeModulesClosure {
    rootModules = config.boot.initrd.availableKernelModules ++ config.boot.initrd.kernelModules;
    kernel = modulesTree;
    firmware = firmware;
    allowMissing = true;
  };


  # The initrd only has to mount `/` or any FS marked as necessary for
  # booting (such as the FS containing `/nix/store`, or an FS needed for
  # mounting `/`, like `/` on a loopback).
  fileSystems = filter utils.fsNeededForBoot config.system.build.fileSystems;

  # A utility for enumerating the shared-library dependencies of a program
  findLibs = pkgs.writeShellScriptBin "find-libs" ''
    set -euo pipefail

    declare -A seen
    declare -a left

    patchelf="${pkgs.buildPackages.patchelf}/bin/patchelf"

    function add_needed {
      rpath="$($patchelf --print-rpath $1)"
      dir="$(dirname $1)"
      for lib in $($patchelf --print-needed $1); do
        left+=("$lib" "$rpath" "$dir")
      done
    }

    add_needed $1

    while [ ''${#left[@]} -ne 0 ]; do
      next=''${left[0]}
      rpath=''${left[1]}
      ORIGIN=''${left[2]}
      left=("''${left[@]:3}")
      if [ -z ''${seen[$next]+x} ]; then
        seen[$next]=1

        # Ignore the dynamic linker which for some reason appears as a DT_NEEDED of glibc but isn't in glibc's RPATH.
        case "$next" in
          ld*.so.?) continue;;
        esac

        IFS=: read -ra paths <<< $rpath
        res=
        for path in "''${paths[@]}"; do
          path=$(eval "echo $path")
          if [ -f "$path/$next" ]; then
              res="$path/$next"
              echo "$res"
              add_needed "$res"
              break
          fi
        done
        if [ -z "$res" ]; then
          echo "Couldn't satisfy dependency $next" >&2
          exit 1
        fi
      fi
    done
  '';

  # Some additional utilities needed in stage 1, like mount, lvm, fsck
  # etc.  We don't want to bring in all of those packages, so we just
  # copy what we need.  Instead of using statically linked binaries,
  # we just copy what we need from Glibc and use patchelf to make it
  # work.
  extraUtils = pkgs.runCommandCC "extra-utils"
    { nativeBuildInputs = [pkgs.buildPackages.nukeReferences];
      allowedReferences = [ "out" ]; # prevent accidents like glibc being included in the initrd
    }
    ''
      set +o pipefail

      mkdir -p $out/bin $out/lib
      ln -s $out/bin $out/sbin

      copy_bin_and_libs () {
        [ -f "$out/bin/$(basename $1)" ] && rm "$out/bin/$(basename $1)"
        cp -pdv $1 $out/bin
      }

      # Copy BusyBox.
      for BIN in ${pkgs.busybox}/{s,}bin/*; do
        copy_bin_and_libs $BIN
      done

      # Copy some utillinux stuff.
      copy_bin_and_libs ${pkgs.utillinux}/sbin/blkid

      # Copy dmsetup and lvm.
      copy_bin_and_libs ${pkgs.lvm2}/sbin/dmsetup
      copy_bin_and_libs ${pkgs.lvm2}/sbin/lvm

      # Add RAID mdadm tool.
      copy_bin_and_libs ${pkgs.mdadm}/sbin/mdadm
      copy_bin_and_libs ${pkgs.mdadm}/sbin/mdmon

      # Copy udev.
      copy_bin_and_libs ${udev}/lib/systemd/systemd-udevd
      copy_bin_and_libs ${udev}/bin/udevadm
      for BIN in ${udev}/lib/udev/*_id; do
        copy_bin_and_libs $BIN
      done

      # Copy modprobe.
      copy_bin_and_libs ${pkgs.kmod}/bin/kmod
      ln -sf kmod $out/bin/modprobe

      # Copy resize2fs if any ext* filesystems are to be resized
      ${optionalString (any (fs: fs.autoResize && (lib.hasPrefix "ext" fs.fsType)) fileSystems) ''
        # We need mke2fs in the initrd.
        copy_bin_and_libs ${pkgs.e2fsprogs}/sbin/resize2fs
      ''}

      # Copy secrets if needed.
      ${optionalString (!config.boot.loader.supportsInitrdSecrets)
          (concatStringsSep "\n" (mapAttrsToList (dest: source:
             let source' = if source == null then dest else source; in
               ''
                  mkdir -p $(dirname "$out/secrets/${dest}")
                  cp -a ${source'} "$out/secrets/${dest}"
                ''
          ) config.boot.initrd.secrets))
       }

      ${config.boot.initrd.extraUtilsCommands}

      # Copy ld manually since it isn't detected correctly
      cp -pv ${pkgs.stdenv.cc.libc.out}/lib/ld*.so.? $out/lib

      # Copy all of the needed libraries
      find $out/bin $out/lib -type f | while read BIN; do
        echo "Copying libs for executable $BIN"
        for LIB in $(${findLibs}/bin/find-libs $BIN); do
          TGT="$out/lib/$(basename $LIB)"
          if [ ! -f "$TGT" ]; then
            SRC="$(readlink -e $LIB)"
            cp -pdv "$SRC" "$TGT"
          fi
        done
      done

      # Strip binaries further than normal.
      chmod -R u+w $out
      stripDirs "$STRIP" "lib bin" "-s"

      # Run patchelf to make the programs refer to the copied libraries.
      find $out/bin $out/lib -type f | while read i; do
        if ! test -L $i; then
          nuke-refs -e $out $i
        fi
      done

      find $out/bin -type f | while read i; do
        if ! test -L $i; then
          echo "patching $i..."
          patchelf --set-interpreter $out/lib/ld*.so.? --set-rpath $out/lib $i || true
        fi
      done

      if [ -z "${toString (pkgs.stdenv.hostPlatform != pkgs.stdenv.buildPlatform)}" ]; then
      # Make sure that the patchelf'ed binaries still work.
      echo "testing patched programs..."
      $out/bin/ash -c 'echo hello world' | grep "hello world"
      export LD_LIBRARY_PATH=$out/lib
      $out/bin/mount --help 2>&1 | grep -q "BusyBox"
      $out/bin/blkid -V 2>&1 | grep -q 'libblkid'
      $out/bin/udevadm --version
      $out/bin/dmsetup --version 2>&1 | tee -a log | grep -q "version:"
      LVM_SYSTEM_DIR=$out $out/bin/lvm version 2>&1 | tee -a log | grep -q "LVM"
      $out/bin/mdadm --version

      ${config.boot.initrd.extraUtilsCommandsTest}
      fi
    ''; # */


  udevRules = pkgs.runCommand "udev-rules" {
      allowedReferences = [ extraUtils ];
      preferLocalBuild = true;
    } ''
      mkdir -p $out

      echo 'ENV{LD_LIBRARY_PATH}="${extraUtils}/lib"' > $out/00-env.rules

      cp -v ${udev}/lib/udev/rules.d/60-cdrom_id.rules $out/
      cp -v ${udev}/lib/udev/rules.d/60-persistent-storage.rules $out/
      cp -v ${udev}/lib/udev/rules.d/80-drivers.rules $out/
      cp -v ${pkgs.lvm2}/lib/udev/rules.d/*.rules $out/
      ${config.boot.initrd.extraUdevRulesCommands}

      for i in $out/*.rules; do
          substituteInPlace $i \
            --replace ata_id ${extraUtils}/bin/ata_id \
            --replace scsi_id ${extraUtils}/bin/scsi_id \
            --replace cdrom_id ${extraUtils}/bin/cdrom_id \
            --replace ${pkgs.utillinux}/sbin/blkid ${extraUtils}/bin/blkid \
            --replace /sbin/blkid ${extraUtils}/bin/blkid \
            --replace ${pkgs.lvm2}/sbin ${extraUtils}/bin \
            --replace /sbin/mdadm ${extraUtils}/bin/mdadm \
            --replace ${pkgs.bash}/bin/sh ${extraUtils}/bin/sh \
            --replace /usr/bin/readlink ${extraUtils}/bin/readlink \
            --replace /usr/bin/basename ${extraUtils}/bin/basename \
            --replace ${udev}/bin/udevadm ${extraUtils}/bin/udevadm
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


  # The init script of boot stage 1 (loading kernel modules for
  # mounting the root FS).
  bootStage1 = pkgs.substituteAll {
    src = ./stage-1-init.sh;

    shell = "${extraUtils}/bin/ash";

    isExecutable = true;

    postInstall = ''
      echo checking syntax
      # check both with bash
      ${pkgs.buildPackages.bash}/bin/sh -n $target
      # and with ash shell, just in case
      ${pkgs.buildPackages.busybox}/bin/ash -n $target
    '';

    inherit udevRules extraUtils modulesClosure;

    inherit (config.boot) resumeDevice;

    inherit (config.system.build) earlyMountScript;

    inherit (config.boot.initrd) checkJournalingFS
      preLVMCommands preDeviceCommands postDeviceCommands postMountCommands preFailCommands kernelModules;

    resumeDevices = map (sd: if sd ? device then sd.device else "/dev/disk/by-label/${sd.label}")
                    (filter (sd: hasPrefix "/dev/" sd.device && !sd.randomEncryption.enable
                             # Don't include zram devices
                             && !(hasPrefix "/dev/zram" sd.device)
                            ) config.swapDevices);

    fsInfo =
      let f = fs: [ fs.mountPoint (if fs.device != null then fs.device else "/dev/disk/by-label/${fs.label}") fs.fsType (builtins.concatStringsSep "," fs.options) ];
      in pkgs.writeText "initrd-fsinfo" (concatStringsSep "\n" (concatMap f fileSystems));

    setHostId = optionalString (config.networking.hostId != null) ''
      hi="${config.networking.hostId}"
      ${if pkgs.stdenv.isBigEndian then ''
        echo -ne "\x''${hi:0:2}\x''${hi:2:2}\x''${hi:4:2}\x''${hi:6:2}" > /etc/hostid
      '' else ''
        echo -ne "\x''${hi:6:2}\x''${hi:4:2}\x''${hi:2:2}\x''${hi:0:2}" > /etc/hostid
      ''}
    '';
  };


  # The closure of the init script of boot stage 1 is what we put in
  # the initial RAM disk.
  initialRamdisk = pkgs.makeInitrd {
    inherit (config.boot.initrd) compressor prepend;

    contents =
      [ { object = bootStage1;
          symlink = "/init";
        }
        { object = pkgs.writeText "mdadm.conf" config.boot.initrd.mdadmConf;
          symlink = "/etc/mdadm.conf";
        }
        { object = pkgs.runCommand "initrd-kmod-blacklist-ubuntu" {
              src = "${pkgs.kmod-blacklist-ubuntu}/modprobe.conf";
              preferLocalBuild = true;
            } ''
              target=$out
              ${pkgs.buildPackages.perl}/bin/perl -0pe 's/## file: iwlwifi.conf(.+?)##/##/s;' $src > $out
            '';
          symlink = "/etc/modprobe.d/ubuntu.conf";
        }
        { object = pkgs.kmod-debian-aliases;
          symlink = "/etc/modprobe.d/debian.conf";
        }
      ];
  };

  # Script to add secret files to the initrd at bootloader update time
  initialRamdiskSecretAppender =
    pkgs.writeScriptBin "append-initrd-secrets"
      ''
        #!${pkgs.bash}/bin/bash -e
        function usage {
          echo "USAGE: $0 INITRD_FILE" >&2
          echo "Appends this configuration's secrets to INITRD_FILE" >&2
        }

        if [ $# -ne 1 ]; then
          usage
          exit 1
        fi

        if [ "$1"x = "--helpx" ]; then
          usage
          exit 0
        fi

        ${lib.optionalString (config.boot.initrd.secrets == {})
            "exit 0"}

        export PATH=${pkgs.coreutils}/bin:${pkgs.cpio}/bin:${pkgs.gzip}/bin:${pkgs.findutils}/bin

        function cleanup {
          if [ -n "$tmp" -a -d "$tmp" ]; then
            rm -fR "$tmp"
          fi
        }
        trap cleanup EXIT

        tmp=$(mktemp -d initrd-secrets.XXXXXXXXXX)

        ${lib.concatStringsSep "\n" (mapAttrsToList (dest: source:
            let source' = if source == null then dest else toString source; in
              ''
                mkdir -p $(dirname "$tmp/${dest}")
                cp -a ${source'} "$tmp/${dest}"
              ''
          ) config.boot.initrd.secrets)
         }

        (cd "$tmp" && find . | cpio -H newc -o) | gzip >>"$1"
      '';

in

{
  options = {

    boot.resumeDevice = mkOption {
      type = types.str;
      default = "";
      example = "/dev/sda3";
      description = ''
        Device for manual resume attempt during boot. This should be used primarily
        if you want to resume from file. If left empty, the swap partitions are used.
        Specify here the device where the file resides.
        You should also use <varname>boot.kernelParams</varname> to specify
        <literal><replaceable>resume_offset</replaceable></literal>.
      '';
    };

    boot.initrd.prepend = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = ''
        Other initrd files to prepend to the final initrd we are building.
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

    boot.initrd.preDeviceCommands = mkOption {
      default = "";
      type = types.lines;
      description = ''
        Shell commands to be executed before udev is started to create
        device nodes.
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

    boot.initrd.preFailCommands = mkOption {
      default = "";
      type = types.lines;
      description = ''
        Shell commands to be executed before the failure prompt is shown.
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

    boot.initrd.extraUdevRulesCommands = mkOption {
      internal = true;
      default = "";
      type = types.lines;
      description = ''
        Shell commands to be executed in the builder of the
        udev-rules derivation.  This can be used to add
        additional udev rules in the initial ramdisk.
      '';
    };

    boot.initrd.compressor = mkOption {
      internal = true;
      default = "gzip -9n";
      type = types.str;
      description = "The compressor to use on the initrd image.";
      example = "xz";
    };

    boot.initrd.secrets = mkOption
      { internal = true;
        default = {};
        type = types.attrsOf (types.nullOr types.path);
        description =
          ''
            Secrets to append to the initrd. The attribute name is the
            path the secret should have inside the initrd, the value
            is the path it should be copied from (or null for the same
            path inside and out).
          '';
        example = literalExample
          ''
            { "/etc/dropbear/dropbear_rsa_host_key" =
                ./secret-dropbear-key;
            }
          '';
      };

    boot.initrd.supportedFilesystems = mkOption {
      default = [ ];
      example = [ "btrfs" ];
      type = types.listOf types.str;
      description = "Names of supported filesystem types in the initial ramdisk.";
    };

    boot.loader.supportsInitrdSecrets = mkOption
      { internal = true;
        default = false;
        type = types.bool;
        description =
          ''
            Whether the bootloader setup runs append-initrd-secrets.
            If not, any needed secrets must be copied into the initrd
            and thus added to the store.
          '';
      };

    fileSystems = mkOption {
      type = with lib.types; loaOf (submodule {
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
      });
    };

  };

  config = mkIf (!config.boot.isContainer) {
    assertions = [
      { assertion = any (fs: fs.mountPoint == "/") fileSystems;
        message = "The ‘fileSystems’ option does not specify your root file system.";
      }
      { assertion = let inherit (config.boot) resumeDevice; in
          resumeDevice == "" || builtins.substring 0 1 resumeDevice == "/";
        message = "boot.resumeDevice has to be an absolute path."
          + " Old \"x:y\" style is no longer supported.";
      }
    ];

    system.build =
      { inherit bootStage1 initialRamdisk initialRamdiskSecretAppender extraUtils; };

    system.requiredKernelConfig = with config.lib.kernelConfig; [
      (isYes "TMPFS")
      (isYes "BLK_DEV_INITRD")
    ];

    boot.initrd.supportedFilesystems = map (fs: fs.fsType) fileSystems;

  };
}
