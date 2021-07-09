# This module builds the initial ramdisk, which contains an init
# script that performs the first stage of booting the system: it loads
# the modules necessary to mount the root file system, then calls the
# init in the root file system to start the second boot stage.

{ config, lib, utils, pkgs, ... }:

with lib;

let
  systemd = config.systemd.package;

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

  # A utility for enumerating the shared-library dependencies of a program
  findLibs = pkgs.buildPackages.callPackage ./find-libs.nix {};

  extraUnitsObjects = map (u: { object = u; }) (builtins.attrValues config.boot.initrd.extraUnits
    ++ lib.concatLists (lib.mapAttrsToList (_: builtins.attrValues) config.boot.initrd.unitOverrides));
  systemdUnits = pkgs.callPackage ./systemd-units.nix {
    inherit systemd;
    inherit (config.boot.initrd) extraUnits unitOverrides;
  };

  fstab = pkgs.writeText "fstab" (lib.concatMapStringsSep "\n"
    ({ fsType, mountPoint, device, options, ... }:
      "${device} /sysroot${mountPoint} ${fsType} ${lib.concatStringsSep "," options}") fileSystems);

  initrdUdevRules = pkgs.runCommandNoCC "udev-rules" { udevPackages = [ systemd pkgs.lvm2 ]; } ''
    mkdir -p $out/lib/udev
    for p in $udevPackages; do
      cp -r --preserve=all --no-preserve=mode $p/lib/udev $out/lib
    done
  '';

  emergencyEnv = pkgs.buildEnv {
    name = "packages";
    paths = map (p: lib.getBin p) config.boot.initrd.emergencyPackages;
    pathsToLink = [ "/bin" ];
  };

  initialRamdisk = pkgs.makeInitrdNG { contents = config.boot.initrd.objects; };

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

        (cd "$tmp" && find . -print0 | sort -z | cpio --quiet -o -H newc -R +0:+0 --reproducible --null) | \
          ${compressorExe} ${lib.escapeShellArgs initialRamdisk.compressorArgs} >> "$1"
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

    boot.initrd.enable = mkOption {
      type = types.bool;
      default = !config.boot.isContainer;
      defaultText = "!config.boot.isContainer";
      description = ''
        Whether to enable the NixOS initial RAM disk (initrd). This may be
        needed to perform some initialisation tasks (like mounting
        network/encrypted file systems) before continuing the boot process.
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
      default = (
        if lib.versionAtLeast config.boot.kernelPackages.kernel.version "5.9"
        then "zstd"
        else "gzip"
      );
      defaultText = "zstd if the kernel supports it (5.9+), gzip if not.";
      type = types.unspecified; # We don't have a function type...
      description = ''
        The compressor to use on the initrd image. May be any of:

        <itemizedlist>
         <listitem><para>The name of one of the predefined compressors, see <filename>pkgs/build-support/kernel/initrd-compressor-meta.nix</filename> for the definitions.</para></listitem>
         <listitem><para>A function which, given the nixpkgs package set, returns the path to a compressor tool, e.g. <literal>pkgs: "''${pkgs.pigz}/bin/pigz"</literal></para></listitem>
         <listitem><para>(not recommended, because it does not work when cross-compiling) the full path to a compressor tool, e.g. <literal>"''${pkgs.pigz}/bin/pigz"</literal></para></listitem>
        </itemizedlist>

        The given program should read data from stdin and write it to stdout compressed.
      '';
      example = "xz";
    };

    boot.initrd.compressorArgs = mkOption {
      default = null;
      type = types.nullOr (types.listOf types.str);
      description = "Arguments to pass to the compressor for the initrd image, or null to use the compressor's defaults.";
    };

    boot.initrd.secrets = mkOption
      { default = {};
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

    boot.initrd.verbose = mkOption {
      default = true;
      type = types.bool;
      description =
        ''
          Verbosity of the initrd. Please note that disabling verbosity removes
          only the mandatory messages generated by the NixOS scripts. For a
          completely silent boot, you might also want to set the two following
          configuration options:

          <itemizedlist>
            <listitem><para><literal>boot.consoleLogLevel = 0;</literal></para></listitem>
            <listitem><para><literal>boot.kernelParams = [ "quiet" "udev.log_priority=3" ];</literal></para></listitem>
          </itemizedlist>
        '';
    };

    boot.initrd.extraUnits = mkOption { type = types.attrsOf types.path; };

    boot.initrd.unitOverrides = mkOption { type = types.attrsOf (types.attrsOf types.path); };

    boot.initrd.emergencyPackages = mkOption { type = types.listOf types.package; };

    boot.initrd.objects = with types; mkOption {
      type = listOf (submodule {
        options.object = mkOption { type = path; };
        options.symlink = mkOption {
          type = nullOr path;
          default = null;
        };
        options.executable = mkOption {
          type = bool;
          default = false;
        };
      });
    };

    boot.initrd.emergencyHashedPassword = mkOption {
      type = types.nullOr types.str;
      default = "!";
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
      type = with lib.types; attrsOf (submodule {
        options.neededForBoot = mkOption {
          default = false;
          type = types.bool;
          description = ''
            If set, this file system will be mounted in the initial ramdisk.
            Note that the file system will always be mounted in the initial
            ramdisk if its mount point is one of the following:
            ${concatStringsSep ", " (
              forEach utils.pathsNeededForBoot (i: "<filename>${i}</filename>")
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

    system.build =
      { inherit initialRamdisk initialRamdiskSecretAppender; };

    system.requiredKernelConfig = with config.lib.kernelConfig; [
      (isYes "TMPFS")
      (isYes "BLK_DEV_INITRD")
    ];

    boot.initrd.supportedFilesystems = map (fs: fs.fsType) fileSystems;

    boot.initrd.emergencyPackages = [
      pkgs.bash
      pkgs.coreutils
      pkgs.kmod
      systemd
      # TODO: These are actually needed for boot, not just emergency
      pkgs.util-linuxMinimal
    ];

    boot.initrd.objects = extraUnitsObjects ++ [
      {
        object = "${systemd}/lib/systemd/systemd";
        symlink = "/init";
        executable = true;
      }
      {
        object = "${systemdUnits}";
        symlink = "/etc/systemd";
      }
      {
        object = builtins.toFile "passwd" "root:x:0:0:System Administrator:/root:/bin/bash";
        symlink = "/etc/passwd";
      }
      {
        object = builtins.toFile "shadow" "root:${config.boot.initrd.emergencyHashedPassword}:::::::";
        symlink = "/etc/shadow";
      }
      # TODO: These are required for emergency mode; figure out which
      # parts specifically are needed
      {
        object = "${pkgs.glibc}/lib";
        executable = true;
      }
      {
        object = config.environment.etc.os-release.source;
        symlink = "/etc/initrd-release";
      }
      {
        object = config.environment.etc.os-release.source;
        symlink = "/etc/os-release";
      }
      {
        object = fstab;
        symlink = "/etc/fstab";
      }
      {
        symlink = "/etc/modules-load.d/nixos.conf";
        object = pkgs.writeText "nixos.conf"
          (lib.concatStringsSep "\n" config.boot.initrd.kernelModules);
      }
      {
        object = "${initrdUdevRules}/lib/udev";
        symlink = "/usr/lib/udev";
      }
      {
        object = "${modulesClosure}/lib/modules";
        symlink = "/lib/modules";
      }
      {
        object = "${emergencyEnv}/bin/";
        symlink = "/bin";
        executable = true;
      }
      # Put it at /sbin too so we don't have to set /proc/sys/kernel/modprobe
      {
        object = "${emergencyEnv}/bin/";
        symlink = "/sbin";
        executable = true;
      }
      {
        symlink = "/etc/bashrc";
        object = pkgs.writeShellScript "bashrc" ''
          PATH=${emergencyEnv}/bin
        '';
      }
    ] ++ map (p: {
      object = "${systemd}/${p}";
      executable = true;
    }) [
      "lib/systemd/systemd-modules-load"
      "bin/systemctl"
      "lib/systemd/systemd-udevd"
      "bin/udevadm"
      "lib/systemd/systemd-journald"
      "lib/systemd/systemd-sulogin-shell"
      "lib/systemd/system-generators"
      "bin/journalctl"
      "lib/systemd/systemd-vconsole-setup"
      "bin/systemd-tty-ask-password-agent"
      "lib/systemd/systemd-shutdown"
      "lib/systemd/systemd-makefs"
      "lib/systemd/systemd-growfs"
    ] ++ map (p: {
      object = "${lib.getBin pkgs.lvm2}/${p}";
      executable = true;
    }) [ "bin/dmsetup" "bin/lvm" ] ++ map (p: {
      object = "${lib.getBin p}/bin";
      executable = true;
    }) config.boot.initrd.emergencyPackages;

    # TODO: This doesn't seem like it should be necessary.
    # Seems like we're missing some dependency in the default
    # unit files since we aren't copying all the default symlinks
    boot.initrd.unitOverrides."systemd-udevd.service".modules = pkgs.writeText "modules.conf" ''
      [Unit]
      After=systemd-modules-load.service
    '';
  };
}
