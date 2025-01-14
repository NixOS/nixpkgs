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
        to a new configuration. If set to `null`, a default
        configuration is used that imports
        `(modulesPath + "/virtualisation/digital-ocean-config.nix")`.
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
        configFile =
          if cfg.configFile == null then
            config.virtualisation.digitalOcean.defaultConfigFile
          else
            cfg.configFile;
      };

    };

  meta.maintainers = with maintainers; [
    arianvp
    eamsden
  ];

}
