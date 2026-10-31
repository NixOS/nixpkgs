# This module builds the initial ramdisk, which contains an init
# script that performs the first stage of booting the system: it loads
# the modules necessary to mount the root file system, then calls the
# init in the root file system to start the second boot stage.

{
  config,
  options,
  lib,
  utils,
  pkgs,
  ...
}:

let

  inherit (lib)
    all
    attrValues
    concatStringsSep
    filter
    forEach
    hasPrefix
    literalExpression
    literalMD
    mapAttrsToList
    mkIf
    mkMerge
    mkOption
    mkRemovedOptionModule
    types
    ;

  # Determine the set of modules that we need to mount the root FS.
  modulesClosure = pkgs.makeModulesClosure {
    rootModules = config.boot.initrd.availableKernelModules ++ config.boot.initrd.kernelModules;
    kernel = config.system.modulesTree;
    firmware = config.hardware.firmware;
    allowMissing = config.boot.initrd.allowMissingModules;
    inherit (config.boot.initrd) extraFirmwarePaths;
  };

  # The initrd only has to mount `/` or any FS marked as necessary for
  # booting (such as the FS containing `/nix/store`, or an FS needed for
  # mounting `/`, like `/` on a loopback).
  fileSystems = filter utils.fsNeededForBoot config.system.build.fileSystems;

  # Script to add secret files to the initrd at bootloader update time
  initialRamdiskSecretAppender =
    let
      compressorExe = config.system.build.initialRamdisk.compressorExecutableFunction pkgs;
    in
    pkgs.writeScriptBin "append-initrd-secrets" ''
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

      ${lib.optionalString (config.boot.initrd.secrets == { }) "exit 0"}

      export PATH=${pkgs.coreutils}/bin:${pkgs.cpio}/bin:${pkgs.gzip}/bin:${pkgs.findutils}/bin

      function cleanup {
        if [ -n "$tmp" -a -d "$tmp" ]; then
          rm -fR "$tmp"
        fi
      }
      trap cleanup EXIT

      tmp=$(mktemp -d ''${TMPDIR:-/tmp}/initrd-secrets.XXXXXXXXXX)

      ${lib.concatStringsSep "\n" (
        mapAttrsToList (
          dest: source:
          let
            source' = if source == null then dest else toString source;
          in
          ''
            mkdir -p $(dirname "$tmp/.initrd-secrets/${dest}")
            cp -a ${source'} "$tmp/.initrd-secrets/${dest}"
          ''
        ) config.boot.initrd.secrets
      )}

      # mindepth 1 so that we don't change the mode of /
      (cd "$tmp" && find . -mindepth 1 | xargs touch -amt 197001010000 && find . -mindepth 1 -print0 | sort -z | cpio --quiet -o -H newc -R +0:+0 --reproducible --null) | \
        ${compressorExe} ${lib.escapeShellArgs config.system.build.initialRamdisk.compressorArgs} >> "$1"
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
        Specify here the device where the file resides.  If
        `boot.initrd.systemd.enable = true`, then a device needs to be specified for
        hibernation to work, even if a swap partition is used.
        You should also use {var}`boot.kernelParams` to specify
        `«resume_offset»`.
      '';
    };

    boot.initrd.enable = mkOption {
      type = types.bool;
      default = !config.boot.isContainer;
      defaultText = literalExpression "!config.boot.isContainer";
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

    boot.initrd.extraFirmwarePaths = mkOption {
      default = [ ];
      type = types.listOf types.str;
      description = ''
        Other firmware files (relative to `"''${config.hardware.firmware}/lib/firmware"`) to include in the final initrd we are building.
      '';
    };

    boot.initrd.checkJournalingFS = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Whether to run {command}`fsck` on journaling filesystems such as ext3.
      '';
    };

    boot.initrd.compressor = mkOption {
      default = (
        if lib.versionAtLeast config.boot.kernelPackages.kernel.version "5.9" then "zstd" else "gzip"
      );
      defaultText = literalMD "`zstd` if the kernel supports it (5.9+), `gzip` if not";
      type = types.either types.str (types.functionTo types.str);
      description = ''
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
      description = "Arguments to pass to the compressor for the initrd image, or null to use the compressor's defaults.";
    };

    boot.initrd.secrets = mkOption {
      default = { };
      type = types.attrsOf (types.nullOr types.path);
      description = ''
        Secrets to append to the initrd. The attribute name is the
        path the secret should have inside the initrd, the value
        is the path it should be copied from (or null for the same
        path inside and out).

        Note that `nixos-rebuild switch` will generate the initrd
        also for past generations, so if secrets are moved or deleted
        you will also have to garbage collect the generations that
        use those secrets.
      '';
      example = literalExpression ''
        { "/etc/dropbear/dropbear_rsa_host_key" =
            ./secret-dropbear-key;
        }
      '';
    };

    boot.initrd.supportedFilesystems = mkOption {
      default = { };
      inherit (options.boot.supportedFilesystems) example type description;
    };

    boot.loader.supportsInitrdSecrets = mkOption {
      internal = true;
      default = false;
      type = types.bool;
      description = ''
        Whether the bootloader setup runs append-initrd-secrets.
        If not, any needed secrets must be copied into the initrd
        and thus added to the store.
      '';
    };

    fileSystems = mkOption {
      type =
        with lib.types;
        attrsOf (submodule {
          options.neededForBoot = mkOption {
            default = false;
            type = types.bool;
            description = ''
              If set, this file system will be mounted in the initial ramdisk.
              Note that the file system will always be mounted in the initial
              ramdisk if its mount point is one of the following:
              ${concatStringsSep ", " (forEach utils.pathsNeededForBoot (i: "{file}`${i}`"))}.
            '';
          };
        });
    };

  };

  config = mkIf config.boot.initrd.enable {
    assertions = [
      {
        assertion =
          let
            inherit (config.boot) resumeDevice;
          in
          resumeDevice == "" || builtins.substring 0 1 resumeDevice == "/";
        message =
          "boot.resumeDevice has to be an absolute path." + " Old \"x:y\" style is no longer supported.";
      }
      # TODO: remove when #85000 is fixed
      {
        assertion =
          !config.boot.loader.supportsInitrdSecrets
          -> all (
            source: builtins.isPath source || (builtins.isString source && hasPrefix builtins.storeDir source)
          ) (attrValues config.boot.initrd.secrets);
        message = ''
          boot.initrd.secrets values must be unquoted paths when
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
      {
        inherit
          initialRamdiskSecretAppender
          modulesClosure
          ;
      }
    ];

    system.requiredKernelConfig = with config.lib.kernelConfig; [
      (isYes "TMPFS")
      (isYes "BLK_DEV_INITRD")
    ];

    boot.initrd.supportedFilesystems = map (fs: fs.fsType) fileSystems;
  };

  imports = [
    (mkRemovedOptionModule [ "boot" "initrd" "extraFiles" ] "Scripted stage 1 has been removed.")
    (mkRemovedOptionModule [ "boot" "initrd" "verbose" ] "Scripted stage 1 has been removed.")
    (mkRemovedOptionModule [ "boot" "initrd" "stage1Greeting" ] "Scripted stage 1 has been removed.")
  ];
}
