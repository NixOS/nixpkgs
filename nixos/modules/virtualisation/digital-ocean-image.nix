{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.virtualisation.digitalOceanImage;
in
{

  imports = [
    ./digital-ocean-config.nix
    ../image/config-file-option.nix
    ./disk-size-option.nix
    ../image/file-options.nix
    (lib.mkRenamedOptionModuleWith {
      sinceRelease = 2411;
      from = [
        "virtualisation"
        "digitalOceanImage"
        "diskSize"
      ];
      to = [
        "virtualisation"
        "diskSize"
      ];
    })
  ];

  options = {
    virtualisation.digitalOceanImage.configFile = mkOption {
      type = with types; nullOr path;
      default = null;
      description = ''
        A path to a configuration file which will be placed at
        `/etc/nixos/configuration.nix` and be used when switching
        to a new configuration. Prefer setting
        `virtualisation.configFile` for image-builder-agnostic
        configurations. If set to `null`, `virtualisation.configFile`
        is used.
      '';
    };

    virtualisation.digitalOceanImage.compressionMethod = mkOption {
      type = types.enum [
        "gzip"
        "bzip2"
      ];
      default = "gzip";
      example = "bzip2";
      description = ''
        Disk image compression method. Choose bzip2 to generate smaller images that
        take longer to generate but will consume less metered storage space on your
        Digital Ocean account.
      '';
    };
  };

  #### implementation
  config =
    let
      format = "qcow2";
    in
    {
      image.extension = lib.concatStringsSep "." [
        format
        (
          {
            "gzip" = "gz";
            "bzip2" = "bz2";
          }
          .${cfg.compressionMethod}
        )
      ];
      virtualisation.configFile = mkMerge [
        (mkDefault config.virtualisation.digitalOcean.defaultConfigFile)
        (mkIf (cfg.configFile != null) cfg.configFile)
      ];

      system.nixos.tags = [ "digital-ocean" ];
      system.build.image = config.system.build.digitalOceanImage;
      system.build.digitalOceanImage = import ../../lib/make-disk-image.nix {
        name = "digital-ocean-image";
        inherit (config.image) baseName;
        inherit (config.virtualisation) diskSize;
        inherit
          config
          lib
          pkgs
          format
          ;
        postVM =
          let
            compress =
              {
                "gzip" = "${pkgs.gzip}/bin/gzip";
                "bzip2" = "${pkgs.bzip2}/bin/bzip2";
              }
              .${cfg.compressionMethod};
          in
          ''
            ${compress} $diskImage
          '';
        inherit (config.virtualisation) configFile;
      };

    };

  meta.maintainers = with maintainers; [
    arianvp
    eamsden
  ];

}
