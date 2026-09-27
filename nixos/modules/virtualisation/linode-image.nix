{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.virtualisation.linodeImage;
  defaultConfigFile = pkgs.writeText "configuration.nix" ''
    _: {
      imports = [
        <nixpkgs/nixos/modules/virtualisation/linode-image.nix>
      ];
    }
  '';
in
{
  imports = [
    ./linode-config.nix
    ../image/config-file-option.nix
    ./disk-size-option.nix
    ../image/file-options.nix
    (lib.mkRenamedOptionModuleWith {
      sinceRelease = 2411;
      from = [
        "virtualisation"
        "linodeImage"
        "diskSize"
      ];
      to = [
        "virtualisation"
        "diskSize"
      ];
    })
  ];

  options = {

    virtualisation.linodeImage.configFile = mkOption {
      type = with types; nullOr str;
      default = null;
      description = ''
        A path to a configuration file which will be placed at `/etc/nixos/configuration.nix`
        and be used when switching to a new configuration. Prefer setting
        `virtualisation.configFile` for image-builder-agnostic configurations.
        If set to `null`, `virtualisation.configFile` is used.
      '';
    };

    virtualisation.linodeImage.compressionLevel = mkOption {
      type = types.ints.between 1 9;
      default = 6;
      description = ''
        GZIP compression level of the resulting disk image (1-9).
      '';
    };
  };

  config = {
    warnings =
      optional (cfg.configFile != null)
        "The option `virtualisation.linodeImage.configFile` is deprecated, use `virtualisation.configFile` instead.";

    virtualisation.configFile = mkMerge [
      (mkDefault defaultConfigFile)
      (mkIf (cfg.configFile != null) cfg.configFile)
    ];

    system.nixos.tags = [ "linode" ];
    image.extension = "img.gz";
    system.build.image = config.system.build.linodeImage;
    system.build.linodeImage = import ../../lib/make-disk-image.nix {
      name = "linode-image";
      baseName = config.image.baseName;
      # NOTE: Linode specifically requires images to be `gzip`-ed prior to upload
      # See: https://www.linode.com/docs/products/tools/images/guides/upload-an-image/#requirements-and-considerations
      postVM = ''
        ${pkgs.gzip}/bin/gzip -${toString cfg.compressionLevel} -c -- $diskImage > \
        $out/${config.image.fileName}
        rm $diskImage
      '';
      format = "raw";
      partitionTableType = "none";
      inherit (config.virtualisation) configFile diskSize;
      inherit config lib pkgs;
    };
  };

  meta.maintainers = with maintainers; [ cyntheticfox ];
}
