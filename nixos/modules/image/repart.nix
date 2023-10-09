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
        example = lib.literalExpression '' {
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
in
{
  options.image.repart = {

    name = lib.mkOption {
      type = lib.types.str;
      description = lib.mdDoc "The name of the image.";
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

    package = lib.mkPackageOption pkgs "systemd-repart" {
      default = "systemd";
      example = lib.literalExpression ''
        pkgs.systemdMinimal.override { withCryptsetup = true; }
      '';
    };

    partitions = lib.mkOption {
      type = with lib.types; attrsOf (submodule partitionOptions);
      default = { };
      example = lib.literalExpression '' {
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

  };

  config = {

    system.build.image =
      let
        fileSystemToolMapping = with pkgs; {
          "vfat" = [ dosfstools mtools ];
          "ext4" = [ e2fsprogs.bin ];
          "squashfs" = [ squashfsTools ];
          "erofs" = [ erofs-utils ];
          "btrfs" = [ btrfs-progs ];
          "xfs" = [ xfsprogs ];
        };

        fileSystems = lib.filter
          (f: f != null)
          (lib.mapAttrsToList (_n: v: v.repartConfig.Format or null) cfg.partitions);

        fileSystemTools = builtins.concatMap (f: fileSystemToolMapping."${f}") fileSystems;


        makeClosure = paths: pkgs.closureInfo { rootPaths = paths; };

        # Add the closure of the provided Nix store paths to cfg.partitions so
        # that amend-repart-definitions.py can read it.
        addClosure = _name: partitionConfig: partitionConfig // (
          lib.optionalAttrs
            (partitionConfig.storePaths or [ ] != [ ])
            { closure = "${makeClosure partitionConfig.storePaths}/store-paths"; }
        );


        finalPartitions = lib.mapAttrs addClosure cfg.partitions;


        amendRepartDefinitions = pkgs.runCommand "amend-repart-definitions.py"
          {
            nativeBuildInputs = with pkgs; [ black ruff mypy ];
            buildInputs = [ pkgs.python3 ];
          } ''
          install ${./amend-repart-definitions.py} $out
          patchShebangs --host $out

          black --check --diff $out
          ruff --line-length 88 $out
          mypy --strict $out
        '';

        format = pkgs.formats.ini { };

        definitionsDirectory = utils.systemdUtils.lib.definitions
          "repart.d"
          format
          (lib.mapAttrs (_n: v: { Partition = v.repartConfig; }) finalPartitions);

        partitions = pkgs.writeText "partitions.json" (builtins.toJSON finalPartitions);
      in
      pkgs.runCommand cfg.name
        {
          nativeBuildInputs = [
            cfg.package
            pkgs.fakeroot
            pkgs.util-linux
          ] ++ fileSystemTools;
        } ''
        amendedRepartDefinitions=$(${amendRepartDefinitions} ${partitions} ${definitionsDirectory})

        mkdir -p $out
        cd $out

        unshare --map-root-user fakeroot systemd-repart \
          --dry-run=no \
          --empty=create \
          --size=auto \
          --seed="${cfg.seed}" \
          --definitions="$amendedRepartDefinitions" \
          --split="${lib.boolToString cfg.split}" \
          --json=pretty \
          image.raw \
          | tee repart-output.json
      '';

    meta = {
      maintainers = with lib.maintainers; [ nikstur ];
      doc = ./repart.md;
    };

  };
}
