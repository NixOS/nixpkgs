# This module builds the initial ramdisk, which contains an init
# script that performs the first stage of booting the system: it loads
# the modules necessary to mount the root file system, then calls the
# init in the root file system to start the second boot stage.

{ config, lib, utils, pkgs, ... }:

with lib;

let

  udev = config.systemd.package;

  kernel-name = config.boot.kernelPackages.kernel.name or "kernel";

  modulesTree = config.system.modulesTree.override { name = kernel-name + "-modules"; };
  firmware = config.hardware.firmware;


  # Determine the set of modules that we need to mount the root FS.
  modulesClosure = pkgs.makeModulesClosure {
    rootModules = config.boot.initrd.availableKernelModules ++ config.boot.initrd.kernelModules;
    kernel = modulesTree;
    firmware = firmware;
    allowMissing = false;
  };


  # The initrd only has to mount `/` or any FS marked as necessary for
  # booting (such as the FS containing `/nix/store`, or an FS needed for
  # mounting `/`, like `/` on a loopback).
  fileSystems = filter utils.fsNeededForBoot config.system.build.fileSystems;

  # Determine whether zfs-mount(8) is needed.
  zfsRequiresMountHelper = any (fs: lib.elem "zfsutil" fs.options) fileSystems;

  # A utility for enumerating the shared-library dependencies of a program
  findLibs = pkgs.buildPackages.writeShellScriptBin "find-libs" ''
    set -euo pipefail

    declare -A seen
    left=()

    patchelf="${pkgs.buildPackages.patchelf}/bin/patchelf"

    function add_needed {
      rpath="$($patchelf --print-rpath $1)"
      dir="$(dirname $1)"
      for lib in $($patchelf --print-needed $1); do
        left+=("$lib" "$rpath" "$dir")
      done
    }

    add_needed "$1"

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
  extraUtils = pkgs.runCommand "extra-utils"
    { nativeBuildInputs = with pkgs.buildPackages; [ nukeReferences bintools ];
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

      ${optionalString zfsRequiresMountHelper ''
        # Filesystems using the "zfsutil" option are mounted regardless of the
        # mount.zfs(8) helper, but it is required to ensure that ZFS properties
        # are used as mount options.
        #
        # BusyBox does not use the ZFS helper in the first place.
        # util-linux searches /sbin/ as last path for helpers (stage-1-init.sh
        # must symlink it to the store PATH).
        # Without helper program, both `mount`s silently fails back to internal
        # code, using default options and effectively ignore security relevant
        # ZFS properties such as `setuid=off` and `exec=off` (unless manually
        # duplicated in `fileSystems.*.options`, defeating "zfsutil"'s purpose).
        copy_bin_and_libs ${lib.getOutput "mount" pkgs.util-linux}/bin/mount
        copy_bin_and_libs ${config.boot.zfs.package}/bin/mount.zfs
      ''}

      # Copy some util-linux stuff.
      copy_bin_and_libs ${pkgs.util-linux}/sbin/blkid

      # Copy dmsetup and lvm.
      copy_bin_and_libs ${getBin pkgs.lvm2}/bin/dmsetup
      copy_bin_and_libs ${getBin pkgs.lvm2}/bin/lvm

      # Copy udev.
      copy_bin_and_libs ${udev}/bin/udevadm
      copy_bin_and_libs ${udev}/lib/systemd/systemd-sysctl
      for BIN in ${udev}/lib/udev/*_id; do
        copy_bin_and_libs $BIN
      done
      # systemd-udevd is only a symlink to udevadm these days
      ln -sf udevadm $out/bin/systemd-udevd

      # Copy modprobe.
      copy_bin_and_libs ${pkgs.kmod}/bin/kmod
      ln -sf kmod $out/bin/modprobe

      # Copy multipath.
      ${optionalString config.services.multipath.enable ''
        copy_bin_and_libs ${config.services.multipath.package}/bin/multipath
        copy_bin_and_libs ${config.services.multipath.package}/bin/multipathd
        # Copy lib/multipath manually.
        cp -rpv ${config.services.multipath.package}/lib/multipath $out/lib
      ''}

      # Copy secrets if needed.
      #
      # TODO: move out to a separate script; see #85000.
      ${optionalString (!config.boot.loader.supportsInitrdSecrets)
          (concatStringsSep "\n" (mapAttrsToList (dest: source:
             let source' = if source == null then dest else source; in
               ''
                  mkdir -p $(dirname "$out/secrets/${dest}")
                  # Some programs (e.g. ssh) doesn't like secrets to be
                  # symlinks, so we use `cp -L` here to match the
                  # behaviour when secrets are natively supported.
                  cp -Lr ${source'} "$out/secrets/${dest}"
                ''
          ) config.boot.initrd.secrets))
       }

      ${config.boot.initrd.extraUtilsCommands}

      # Copy ld manually since it isn't detected correctly
      cp -pv ${pkgs.stdenv.cc.libc.out}/lib/ld*.so.? $out/lib

      # Copy all of the needed libraries in a consistent order so
      # duplicates are resolved the same way.
      find $out/bin $out/lib -type f | sort | while read BIN; do
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
      stripDirs "$STRIP" "$RANLIB" "lib bin" "-s"

      # Run patchelf to make the programs refer to the copied libraries.
      find $out/bin $out/lib -type f | while read i; do
        nuke-refs -e $out $i
      done

      find $out/bin -type f | while read i; do
        echo "patching $i..."
        patchelf --set-interpreter $out/lib/ld*.so.? --set-rpath $out/lib $i || true
      done

      find $out/lib -type f \! -name 'ld*.so.?' | while read i; do
        echo "patching $i..."
        patchelf --set-rpath $out/lib $i
      done

      if [ -z "${toString (pkgs.stdenv.hostPlatform != pkgs.stdenv.buildPlatform)}" ]; then
      # Make sure that the patchelf'ed binaries still work.
      echo "testing patched programs..."
      $out/bin/ash -c 'echo hello world' | grep "hello world"
      ${if zfsRequiresMountHelper then ''
        $out/bin/mount -V 1>&1 | grep -q "mount from util-linux"
        $out/bin/mount.zfs -h 2>&1 | grep -q "Usage: mount.zfs"
      '' else ''
        $out/bin/mount --help 2>&1 | grep -q "BusyBox"
      ''}
      $out/bin/blkid -V 2>&1 | grep -q 'libblkid'
      $out/bin/udevadm --version
      $out/bin/dmsetup --version 2>&1 | tee -a log | grep -q "version:"
      LVM_SYSTEM_DIR=$out $out/bin/lvm version 2>&1 | tee -a log | grep -q "LVM"
      ${optionalString config.services.multipath.enable ''
        ($out/bin/multipath || true) 2>&1 | grep -q 'need to be root'
        ($out/bin/multipathd || true) 2>&1 | grep -q 'need to be root'
      ''}

      ${config.boot.initrd.extraUtilsCommandsTest}
      fi
    ''; # */


  # Networkd link files are used early by udev to set up interfaces early.
  # This must be done in stage 1 to avoid race conditions between udev and
  # network daemons.
  linkUnits = pkgs.runCommand "link-units" {
      allowedReferences = [ extraUtils ];
      preferLocalBuild = true;
    } (''
      mkdir -p $out
      cp -v ${udev}/lib/systemd/network/*.link $out/
      '' + (
      let
        links = filterAttrs (n: v: hasSuffix ".link" n) config.systemd.network.units;
        files = mapAttrsToList (n: v: "${v.unit}/${n}") links;
      in
        concatMapStringsSep "\n" (file: "cp -v ${file} $out/") files
      ));

  udevRules = pkgs.runCommand "udev-rules" {
      allowedReferences = [ extraUtils ];
      preferLocalBuild = true;
    } ''
      mkdir -p $out

      cp -v ${udev}/lib/udev/rules.d/60-cdrom_id.rules $out/
      cp -v ${udev}/lib/udev/rules.d/60-persistent-storage.rules $out/
      cp -v ${udev}/lib/udev/rules.d/75-net-description.rules $out/
      cp -v ${udev}/lib/udev/rules.d/80-drivers.rules $out/
      cp -v ${udev}/lib/udev/rules.d/80-net-setup-link.rules $out/
      cp -v ${pkgs.lvm2}/lib/udev/rules.d/*.rules $out/
      ${config.boot.initrd.extraUdevRulesCommands}

      for i in $out/*.rules; do
          substituteInPlace $i \
            --replace ata_id ${extraUtils}/bin/ata_id \
            --replace scsi_id ${extraUtils}/bin/scsi_id \
            --replace cdrom_id ${extraUtils}/bin/cdrom_id \
            --replace ${pkgs.coreutils}/bin/basename ${extraUtils}/bin/basename \
            --replace ${pkgs.util-linux}/bin/blkid ${extraUtils}/bin/blkid \
            --replace ${getBin pkgs.lvm2}/bin ${extraUtils}/bin \
            --replace ${pkgs.mdadm}/sbin ${extraUtils}/sbin \
            --replace ${pkgs.bash}/bin/sh ${extraUtils}/bin/sh \
            --replace ${udev} ${extraUtils}
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
      #   https://www.spinics.net/lists/hotplug/msg03935.html
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

    inherit linkUnits udevRules extraUtils;

    inherit (config.boot) resumeDevice;

    inherit (config.system.nixos) distroName;

    inherit (config.system.build) earlyMountScript;

    inherit (config.boot.initrd) checkJournalingFS verbose
      preLVMCommands preDeviceCommands postDeviceCommands postResumeCommands postMountCommands preFailCommands kernelModules;

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
    name = "initrd-${kernel-name}";
    inherit (config.boot.initrd) compressor compressorArgs prepend;

    contents =
      [ { object = bootStage1;
          symlink = "/init";
        }
        { object = "${modulesClosure}/lib";
          symlink = "/lib";
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
        { object = config.environment.etc."modprobe.d/nixos.conf".source;
          symlink = "/etc/modprobe.d/nixos.conf";
        }
        { object = pkgs.kmod-debian-aliases;
          symlink = "/etc/modprobe.d/debian.conf";
        }
      ] ++ lib.optionals config.services.multipath.enable [
        { object = pkgs.runCommand "multipath.conf" {
              src = config.environment.etc."multipath.conf".text;
              preferLocalBuild = true;
            } ''
              target=$out
              printf "$src" > $out
              substituteInPlace $out \
                --replace ${config.services.multipath.package}/lib ${extraUtils}/lib
            '';
          symlink = "/etc/multipath.conf";
        }
      ] ++ (lib.mapAttrsToList
        (symlink: options:
          {
            inherit symlink;
            object = options.source;
          }
        )
        config.boot.initrd.extraFiles);
  };

  # Script to add secret files to the initrd at bootloader update time
  initialRamdiskSecretAppender =
    let
      compressorExe = initialRamdisk.compressorExecutableFunction pkgs;
    in pkgs.writeScriptBin "append-initrd-secrets"
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

        export PATH=${pkgs.coreutils}/bin:${pkgs.libarchive}/bin:${pkgs.gzip}/bin:${pkgs.findutils}/bin

        function cleanup {
          if [ -n "$tmp" -a -d "$tmp" ]; then
            rm -fR "$tmp"
          fi
        }
        trap cleanup EXIT

        tmp=$(mktemp -d ''${TMPDIR:-/tmp}/initrd-secrets.XXXXXXXXXX)

        ${lib.concatStringsSep "\n" (mapAttrsToList (dest: source:
            let source' = if source == null then dest else toString source; in
              ''
                mkdir -p $(dirname "$tmp/.initrd-secrets/${dest}")
                cp -a ${source'} "$tmp/.initrd-secrets/${dest}"
              ''
          ) config.boot.initrd.secrets)
         }

        # mindepth 1 so that we don't change the mode of /
        (cd "$tmp" && find . -mindepth 1 | xargs touch -amt 197001010000 && find . -mindepth 1 -print0 | sort -z | bsdtar --uid 0 --gid 0 -cnf - -T - | bsdtar --null -cf - --format=newc @-) | \
          ${compressorExe} ${lib.escapeShellArgs initialRamdisk.compressorArgs} >> "$1"
      '';

in

{
  options = {

    boot.resumeDevice = mkOption {
      type = types.str;
      default = "";
      example = "/dev/sda3";
      description = lib.mdDoc ''
        Device for manual resume attempt during boot. This should be used primarily
        if you want to resume from file. If left empty, the swap partitions are used.
        Specify here the device where the file resides.
        You should also use {var}`boot.kernelParams` to specify
        `«resume_offset»`.
      '';
    };

    boot.initrd.enable = mkOption {
      type = types.bool;
      default = !config.boot.isContainer;
      defaultText = literalExpression "!config.boot.isContainer";
      description = lib.mdDoc ''
        Whether to enable the NixOS initial RAM disk (initrd). This may be
        needed to perform some initialisation tasks (like mounting
        network/encrypted file systems) before continuing the boot process.
      '';
    };

    boot.initrd.extraFiles = mkOption {
      default = { };
      type = types.attrsOf
        (types.submodule {
          options = {
            source = mkOption {
              type = types.package;
              description = lib.mdDoc "The object to make available inside the initrd.";
            };
          };
        });
      description = lib.mdDoc ''
        Extra files to link and copy in to the initrd.
      '';
    };

    boot.initrd.prepend = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = lib.mdDoc ''
        Other initrd files to prepend to the final initrd we are building.
      '';
    };

    boot.initrd.checkJournalingFS = mkOption {
      default = true;
      type = types.bool;
      description = lib.mdDoc ''
        Whether to run {command}`fsck` on journaling filesystems such as ext3.
      '';
    };

    boot.initrd.preLVMCommands = mkOption {
      default = "";
      type = types.lines;
      description = lib.mdDoc ''
        Shell commands to be executed immediately before LVM discovery.
      '';
    };

    boot.initrd.preDeviceCommands = mkOption {
      default = "";
      type = types.lines;
      description = lib.mdDoc ''
        Shell commands to be executed before udev is started to create
        device nodes.
      '';
    };

    boot.initrd.postDeviceCommands = mkOption {
      default = "";
      type = types.lines;
      description = lib.mdDoc ''
        Shell commands to be executed immediately after stage 1 of the
        boot has loaded kernel modules and created device nodes in
        {file}`/dev`.
      '';
    };

    boot.initrd.postResumeCommands = mkOption {
      default = "";
      type = types.lines;
      description = lib.mdDoc ''
        Shell commands to be executed immediately after attempting to resume.
      '';
    };

    boot.initrd.postMountCommands = mkOption {
      default = "";
      type = types.lines;
      description = lib.mdDoc ''
        Shell commands to be executed immediately after the stage 1
        filesystems have been mounted.
      '';
    };

    boot.initrd.preFailCommands = mkOption {
      default = "";
      type = types.lines;
      description = lib.mdDoc ''
        Shell commands to be executed before the failure prompt is shown.
      '';
    };

    boot.initrd.extraUtilsCommands = mkOption {
      internal = true;
      default = "";
      type = types.lines;
      description = lib.mdDoc ''
        Shell commands to be executed in the builder of the
        extra-utils derivation.  This can be used to provide
        additional utilities in the initial ramdisk.
      '';
    };

    boot.initrd.extraUtilsCommandsTest = mkOption {
      internal = true;
      default = "";
      type = types.lines;
      description = lib.mdDoc ''
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
      description = lib.mdDoc ''
        Shell commands to be executed in the builder of the
        udev-rules derivation.  This can be used to add
        additional udev rules in the initial ramdisk.
      '';
    };

    boot.initrd.compressor = mkOption {
      default = (
        if lib.versionAtLeast config.boot.kernelPackages.kernel.version "5.9"
        then "zstd"
        else "gzip"
      );
      defaultText = literalMD "`zstd` if the kernel supports it (5.9+), `gzip` if not";
      type = types.either types.str (types.functionTo types.str);
      description = lib.mdDoc ''
        The compressor to use on the initrd image. May be any of:

        - The name of one of the predefined compressors, see {file}`pkgs/build-support/kernel/initrd-compressor-meta.nix` for the definitions.
        - A function which, given the nixpkgs package set, returns the path to a compressor tool, e.g. `pkgs: "''${pkgs.pigz}/bin/pigz"`
        - (not recommended, because it does not work when cross-compiling) the full path to a compressor tool, e.g. `"''${pkgs.pigz}/bin/pigz"`

        The given program should read data from stdin and write it to stdout compressed.
      '';
      example = "xz";
    };

    boot.initrd.compressorArgs = mkOption {
      default = null;
      type = types.nullOr (types.listOf types.str);
      description = lib.mdDoc "Arguments to pass to the compressor for the initrd image, or null to use the compressor's defaults.";
    };

    boot.initrd.secrets = mkOption
      { default = {};
        type = types.attrsOf (types.nullOr types.path);
        description =
          lib.mdDoc ''
            Secrets to append to the initrd. The attribute name is the
            path the secret should have inside the initrd, the value
            is the path it should be copied from (or null for the same
            path inside and out).
          '';
        example = literalExpression
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
      description = lib.mdDoc "Names of supported filesystem types in the initial ramdisk.";
    };

    boot.initrd.verbose = mkOption {
      default = true;
      type = types.bool;
      description =
        lib.mdDoc ''
          Verbosity of the initrd. Please note that disabling verbosity removes
          only the mandatory messages generated by the NixOS scripts. For a
          completely silent boot, you might also want to set the two following
          configuration options:

          - `boot.consoleLogLevel = 0;`
          - `boot.kernelParams = [ "quiet" "udev.log_level=3" ];`
        '';
    };

    boot.loader.supportsInitrdSecrets = mkOption
      { internal = true;
        default = false;
        type = types.bool;
        description =
          lib.mdDoc ''
            Whether the bootloader setup runs append-initrd-secrets.
            If not, any needed secrets must be copied into the initrd
            and thus added to the store.
          '';
      };

    fileSystems = mkOption {
      type = with lib.types; attrsOf (submodule {
        options.neededForBoot = mkOption {
          default = false;
          type = types.bool;
          description = lib.mdDoc ''
            If set, this file system will be mounted in the initial ramdisk.
            Note that the file system will always be mounted in the initial
            ramdisk if its mount point is one of the following:
            ${concatStringsSep ", " (
              forEach utils.pathsNeededForBoot (i: "{file}`${i}`")
            )}.
          '';
        };
      });
    };

  };

  config = mkIf config.boot.initrd.enable {
    assertions = [
      { assertion = any (fs: fs.mountPoint == "/") fileSystems;
        message = "The ‘fileSystems’ option does not specify your root file system.";
      }
      { assertion = let inherit (config.boot) resumeDevice; in
          resumeDevice == "" || builtins.substring 0 1 resumeDevice == "/";
        message = "boot.resumeDevice has to be an absolute path."
          + " Old \"x:y\" style is no longer supported.";
      }
      # TODO: remove when #85000 is fixed
      { assertion = !config.boot.loader.supportsInitrdSecrets ->
          all (source:
            builtins.isPath source ||
            (builtins.isString source && hasPrefix builtins.storeDir source))
          (attrValues config.boot.initrd.secrets);
        message = ''
          boot.loader.initrd.secrets values must be unquoted paths when
          using a bootloader that doesn't natively support initrd
          secrets, e.g.:

            boot.initrd.secrets = {
              "/etc/secret" = /path/to/secret;
            };

          Note that this will result in all secrets being stored
          world-readable in the Nix store!
        '';
      }
    ];

    system.build = mkMerge [
      { inherit bootStage1 initialRamdiskSecretAppender extraUtils; }

      # generated in nixos/modules/system/boot/systemd/initrd.nix
      (mkIf (!config.boot.initrd.systemd.enable) { inherit initialRamdisk; })
    ];

    system.requiredKernelConfig = with config.lib.kernelConfig; [
      (isYes "TMPFS")
      (isYes "BLK_DEV_INITRD")
    ];

    boot.initrd.supportedFilesystems = map (fs: fs.fsType) fileSystems;
  };

  imports = [
    (mkRenamedOptionModule [ "boot" "initrd" "mdadmConf" ] [ "boot" "swraid" "mdadmConf" ])
  ];
}
