{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

with lib;
let
  cfg = config.virtualisation.googleComputeImage;
  defaultConfigFile = pkgs.writeText "configuration.nix" ''
    { ... }:
    {
      imports = [
        <nixpkgs/nixos/modules/virtualisation/google-compute-image.nix>
      ];
    }
  '';
  configFile = if cfg.configFile == null then defaultConfigFile else cfg.configFile;

  contentsToRepart =
    contents:
    lib.listToAttrs (
      lib.map (
        entry:
        if (entry ? "user" || entry ? "group" || entry ? "mode") then
          throw ''
            virtualisation.googleComputeImage.contents: systemd-repart does not support setting user, group & mode.
            If you need them, please use systemd.tmpfiles.rules instead.
          ''
        else
          {
            name = entry.target;
            value.source = entry.source;
          }
      ) contents
    );
in
{

  imports = [
    ./google-compute-config.nix
    ./disk-size-option.nix
    ../image/file-options.nix
    ../image/repart.nix
    (lib.mkRenamedOptionModuleWith {
      sinceRelease = 2411;
      from = [
        "virtualisation"
        "googleComputeImage"
        "diskSize"
      ];
      to = [
        "virtualisation"
        "diskSize"
      ];
    })
  ];

  options = {
    virtualisation.googleComputeImage.configFile = mkOption {
      type = with types; nullOr str;
      default = null;
      description = ''
          A path to a configuration file which will be placed at `/etc/nixos/configuration.nix`
        and be used when switching to a new configuration.
        If set to `null`, a default configuration is used, where the only import is
        `<nixpkgs/nixos/modules/virtualisation/google-compute-image.nix>`.
      '';
    };

    virtualisation.googleComputeImage.compressionLevel = mkOption {
      type = types.int;
      default = 6;
      description = ''
        GZIP compression level of the resulting disk image (1-9).
      '';
    };

    virtualisation.googleComputeImage.buildMemSize = mkOption {
      type = types.int;
      default = 1024;
      description = "Memory size (in MiB) for the temporary VM used to build the image.";
    };

    virtualisation.googleComputeImage.contents = mkOption {
      type = with types; listOf attrs;
      default = [ ];
      description = ''
          The files and directories to be placed in the image.
        This is a list of attribute sets {source, target, mode, user, group} where
        `source' is the file system object (regular file or directory) to be
        grafted in the file system at path `target', `mode' is a string containing
        the permissions that will be set (ex. "755"), `user' and `group' are the
        user and group name that will be set as owner of the files.
        `mode', `user', and `group' are optional.
        When setting one of `user' or `group', the other needs to be set too.
      '';
      example = literalExpression ''
          [
          {
            source = ./default.nix;
            target = "/etc/nixos/default.nix";
            mode = "0644";
            user = "root";
            group = "root";
          }
        ];
      '';
    };

    virtualisation.googleComputeImage.efi = mkEnableOption "EFI booting";
  };

  #### implementation
  config = lib.mkMerge [
    {
      boot.initrd.availableKernelModules = [ "nvme" ];
      boot.loader.grub = mkIf cfg.efi {
        device = mkForce "nodev";
        efiSupport = true;
        efiInstallAsRemovable = true;
      };

      fileSystems."/boot" = mkIf cfg.efi {
        device = "/dev/disk/by-label/ESP";
        fsType = "vfat";
      };

      system.nixos.tags = [ "google-compute" ];
      image.extension = lib.mkForce "raw.tar.gz";
      image.repart.name =
        if config.system.name == "unnamed" then "google-compute-image" else config.system.name;
    }
    (lib.mkIf (!cfg.efi) {
      warnings = [
        ''
          virtualisation.googleComputeImage: Support for legacy boot is scheduled for removal in NixOS 26.05.
          Let us know if you need it in [github issue]
        ''
      ];

      system.build.image = config.system.build.googleComputeImage;
      system.build.googleComputeImage = import ../../lib/make-disk-image.nix {
        name = "google-compute-image";
        inherit (config.image) baseName;
        postVM = ''
              PATH=$PATH:${
                with pkgs;
                lib.makeBinPath [
                  gnutar
                  gzip
                ]
              }
          pushd $out
          # RTFM:
          # https://cloud.google.com/compute/docs/images/create-custom
          # https://cloud.google.com/compute/docs/import/import-existing-image
          mv $diskImage disk.raw
          tar -Sc disk.raw | gzip -${toString cfg.compressionLevel} > \
            ${config.image.fileName}
          rm disk.raw
          popd
        '';
        format = "raw";
        inherit configFile;
        inherit (cfg) contents;
        partitionTableType = "legacy";
        inherit (config.virtualisation) diskSize;
        memSize = cfg.buildMemSize;
        inherit config lib pkgs;
      };
    })
    (lib.mkIf cfg.efi {
      assertions = [
        {
          assertion = config.boot.loader.systemd-boot.enable;
          message = "virtualisation.googleComputeImage.efi only supports systemd-boot";
        }
      ];

      boot.loader.systemd-boot.enable = true;
      system.build.googleComputeImage = config.system.build.image;

      # TODO: This hack just vendors this system.build.image from image/repart.nix
      # for the moment, as the latter does not give us a nice way to call overrideAttrs
      # on system.build.image.
      system.build.image = lib.mkForce (
        let
          cfg = config.image.repart;
          mkfsOptionsToEnv =
            opts:
            lib.mapAttrs' (fsType: options: {
              name = "SYSTEMD_REPART_MKFS_OPTIONS_${lib.toUpper fsType}";
              value = builtins.concatStringsSep " " options;
            }) opts;

          fileSystems = lib.filter (f: f != null) (
            lib.mapAttrsToList (_n: v: v.repartConfig.Format or null) cfg.partitions
          );

          format = pkgs.formats.ini { listsAsDuplicateKeys = true; };

          definitionsDirectory = utils.systemdUtils.lib.definitions "repart.d" format (
            lib.mapAttrs (_n: v: { Partition = v.repartConfig; }) cfg.finalPartitions
          );

          mkfsEnv = mkfsOptionsToEnv cfg.mkfsOptions;
          val = pkgs.callPackage ../image/repart-image.nix {
            systemd = cfg.package;
            inherit (config.image) baseName;
            inherit (cfg)
              name
              version
              compression
              split
              seed
              sectorSize
              finalPartitions
              ;
            inherit fileSystems definitionsDirectory mkfsEnv;
          };
        in
        lib.asserts.checkAssertWarn cfg.assertions cfg.warnings (
          val.overrideAttrs (old: {
            postInstall = ''
              mv $out/${old.name}.raw disk.raw
              tar -Sczf $out/${old.name}.tar.gz disk.raw
            '';
          })
        )
      );

      image = {
        repart = {
          # OVMF does not work with the default repart sector size of 4096
          sectorSize = 512;

          partitions = {
            "esp" = {
              contents =
                let
                  efiArch = pkgs.stdenv.hostPlatform.efiArch;
                in
                {
                  "/EFI/BOOT/BOOT${lib.toUpper efiArch}.EFI".source =
                    "${pkgs.systemd}/lib/systemd/boot/efi/systemd-boot${efiArch}.efi";

                  "/EFI/Linux/${config.system.boot.loader.ukiFile}".source =
                    "${config.system.build.uki}/${config.system.boot.loader.ukiFile}";
                };
              repartConfig = {
                Type = "esp";
                Format = "vfat";
                SizeMinBytes = "128M";
              };
            };

            "nixos" = {
              storePaths = [ config.system.build.toplevel ];
              contents = (contentsToRepart cfg.contents) // {
                "/etc/nixos/configuration.nix".source = configFile;
              };
              repartConfig = {
                Type = "root";
                Format = config.fileSystems."/".fsType;
                Label = "nixos";
              }
              // (
                if config.virtualisation.diskSize == "auto" then
                  {
                    Minimize = "guess";
                  }
                else
                  {
                    SizeMinBytes = "${toString config.virtualisation.diskSize}M";
                  }
              );
            };
          };
        };
      };

    })
  ];
}
