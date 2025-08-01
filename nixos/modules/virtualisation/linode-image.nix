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
        and be used when switching to a new configuration.
        If set to `null`, a default configuration is used, where the only import is
        `<nixpkgs/nixos/modules/virtualisation/linode-image.nix>`
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
      configFile = if cfg.configFile == null then defaultConfigFile else cfg.configFile;
      inherit (config.virtualisation) diskSize;
      inherit config lib pkgs;
    };
  };

  meta.maintainers = with maintainers; [ cyntheticfox ];
}
