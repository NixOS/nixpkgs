# This module exposes options to build a disk image with a GUID Partition Table
# (GPT). It uses systemd-repart to build the image.

{ config, pkgs, lib, utils, ... }:

let
  cfg = config.image.repart;

  partitionOptions = {
    options = {
      storePaths = lib.mkOption {
        type = with lib.types; listOf path;
        default = [ ];
        description = lib.mdDoc "The store paths to include in the partition.";
      };

      stripNixStorePrefix = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to strip `/nix/store/` from the store paths. This is useful
          when you want to build a partition that only contains store paths and
          is mounted under `/nix/store`.
        '';
      };

      contents = lib.mkOption {
        type = with lib.types; attrsOf (submodule {
          options = {
            source = lib.mkOption {
              type = types.path;
              description = lib.mdDoc "Path of the source file.";
            };
          };
        });
        default = { };
        example = lib.literalExpression ''
          {
            "/EFI/BOOT/BOOTX64.EFI".source =
              "''${pkgs.systemd}/lib/systemd/boot/efi/systemd-bootx64.efi";

            "/loader/entries/nixos.conf".source = systemdBootEntry;
          }
        '';
        description = lib.mdDoc "The contents to end up in the filesystem image.";
      };

      repartConfig = lib.mkOption {
        type = with lib.types; attrsOf (oneOf [ str int bool ]);
        example = {
          Type = "home";
          SizeMinBytes = "512M";
          SizeMaxBytes = "2G";
        };
        description = lib.mdDoc ''
          Specify the repart options for a partiton as a structural setting.
          See <https://www.freedesktop.org/software/systemd/man/repart.d.html>
          for all available options.
        '';
      };
    };
  };

  mkfsOptionsToEnv = opts: lib.mapAttrs' (fsType: options: {
    name = "SYSTEMD_REPART_MKFS_OPTIONS_${lib.toUpper fsType}";
    value = builtins.concatStringsSep " " options;
  }) opts;
in
{
  options.image.repart = {

    name = lib.mkOption {
      type = lib.types.str;
      description = lib.mdDoc ''
        Name of the image.

        If this option is unset but config.system.image.id is set,
        config.system.image.id is used as the default value.
      '';
    };

    version = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = config.system.image.version;
      defaultText = lib.literalExpression "config.system.image.version";
      description = lib.mdDoc "Version of the image";
    };

    imageFileBasename = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      description = lib.mdDoc ''
        Basename of the image filename without any extension (e.g. `image_1`).
      '';
    };

    imageFile = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      description = lib.mdDoc ''
        Filename of the image including all extensions (e.g `image_1.raw` or
        `image_1.raw.zst`).
      '';
    };

    compression = {
      enable = lib.mkEnableOption (lib.mdDoc "Image compression");

      algorithm = lib.mkOption {
        type = lib.types.enum [ "zstd" "xz" ];
        default = "zstd";
        description = lib.mdDoc "Compression algorithm";
      };

      level = lib.mkOption {
        type = lib.types.int;
        description = lib.mdDoc ''
          Compression level. The available range depends on the used algorithm.
        '';
      };
    };

    seed = lib.mkOption {
      type = with lib.types; nullOr str;
      # Generated with `uuidgen`. Random but fixed to improve reproducibility.
      default = "0867da16-f251-457d-a9e8-c31f9a3c220b";
      description = lib.mdDoc ''
        A UUID to use as a seed. You can set this to `null` to explicitly
        randomize the partition UUIDs.
      '';
    };

    split = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = lib.mdDoc ''
        Enables generation of split artifacts from partitions. If enabled, for
        each partition with SplitName= set, a separate output file containing
        just the contents of that partition is generated.
      '';
    };

    sectorSize = lib.mkOption {
      type = with lib.types; nullOr int;
      default = 512;
      example = lib.literalExpression "4096";
      description = lib.mdDoc ''
        The sector size of the disk image produced by systemd-repart. This
        value must be a power of 2 between 512 and 4096.
      '';
    };

    package = lib.mkPackageOption pkgs "systemd-repart" {
      # We use buildPackages so that repart images are built with the build
      # platform's systemd, allowing for cross-compiled systems to work.
      default = [ "buildPackages" "systemd" ];
      example = "pkgs.buildPackages.systemdMinimal.override { withCryptsetup = true; }";
    };

    partitions = lib.mkOption {
      type = with lib.types; attrsOf (submodule partitionOptions);
      default = { };
      example = lib.literalExpression ''
        {
          "10-esp" = {
            contents = {
              "/EFI/BOOT/BOOTX64.EFI".source =
                "''${pkgs.systemd}/lib/systemd/boot/efi/systemd-bootx64.efi";
            }
            repartConfig = {
              Type = "esp";
              Format = "fat";
            };
          };
          "20-root" = {
            storePaths = [ config.system.build.toplevel ];
            repartConfig = {
              Type = "root";
              Format = "ext4";
              Minimize = "guess";
            };
          };
        };
      '';
      description = lib.mdDoc ''
        Specify partitions as a set of the names of the partitions with their
        configuration as the key.
      '';
    };

    mkfsOptions = lib.mkOption {
      type = with lib.types; attrsOf (listOf str);
      default = {};
      example = lib.literalExpression ''
        {
          vfat = [ "-S 512" "-c" ];
        }
      '';
      description = lib.mdDoc ''
        Specify extra options for created file systems. The specified options
        are converted to individual environment variables of the format
        `SYSTEMD_REPART_MKFS_OPTIONS_<FSTYPE>`.

        See [upstream systemd documentation](https://github.com/systemd/systemd/blob/v255/docs/ENVIRONMENT.md?plain=1#L575-L577)
        for information about the usage of these environment variables.

        The example would produce the following environment variable:
        ```
        SYSTEMD_REPART_MKFS_OPTIONS_VFAT="-S 512 -c"
        ```
      '';
    };

    finalPartitions = lib.mkOption {
      type = lib.types.attrs;
      internal = true;
      readOnly = true;
      description = lib.mdDoc ''
        Convenience option to access partitions with added closures.
      '';
    };

  };

  config = {

    image.repart =
      let
        version = config.image.repart.version;
        versionInfix = if version != null then "_${version}" else "";
        compressionSuffix = lib.optionalString cfg.compression.enable
          {
            "zstd" = ".zst";
            "xz" = ".xz";
          }."${cfg.compression.algorithm}";

        makeClosure = paths: pkgs.closureInfo { rootPaths = paths; };

        # Add the closure of the provided Nix store paths to cfg.partitions so
        # that amend-repart-definitions.py can read it.
        addClosure = _name: partitionConfig: partitionConfig // (
          lib.optionalAttrs
            (partitionConfig.storePaths or [ ] != [ ])
            { closure = "${makeClosure partitionConfig.storePaths}/store-paths"; }
        );
      in
      {
        name = lib.mkIf (config.system.image.id != null) (lib.mkOptionDefault config.system.image.id);
        imageFileBasename = cfg.name + versionInfix;
        imageFile = cfg.imageFileBasename + ".raw" + compressionSuffix;

        compression = {
          # Generally default to slightly faster than default compression
          # levels under the assumption that most of the building will be done
          # for development and release builds will be customized.
          level = lib.mkOptionDefault {
            "zstd" = 3;
            "xz" = 3;
          }."${cfg.compression.algorithm}";
        };

        finalPartitions = lib.mapAttrs addClosure cfg.partitions;
      };

    system.build.image =
      let
        fileSystems = lib.filter
          (f: f != null)
          (lib.mapAttrsToList (_n: v: v.repartConfig.Format or null) cfg.partitions);


        format = pkgs.formats.ini { };

        definitionsDirectory = utils.systemdUtils.lib.definitions
          "repart.d"
          format
          (lib.mapAttrs (_n: v: { Partition = v.repartConfig; }) cfg.finalPartitions);

        partitionsJSON = pkgs.writeText "partitions.json" (builtins.toJSON cfg.finalPartitions);

        mkfsEnv = mkfsOptionsToEnv cfg.mkfsOptions;
      in
      pkgs.callPackage ./repart-image.nix {
        systemd = cfg.package;
        inherit (cfg) name version imageFileBasename compression split seed sectorSize;
        inherit fileSystems definitionsDirectory partitionsJSON mkfsEnv;
      };

    meta.maintainers = with lib.maintainers; [ nikstur willibutz ];

  };
}
