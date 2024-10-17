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
  imports = [ ./linode-config.nix ];

  options = {
    virtualisation.linodeImage.diskSize = mkOption {
      type = with types; either (enum (singleton "auto")) ints.positive;
      default = "auto";
      example = 1536;
      description = ''
        Size of disk image in MB.
      '';
    };

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
    system.build.linodeImage = import ../../lib/make-disk-image.nix {
      name = "linode-image";
      # NOTE: Linode specifically requires images to be `gzip`-ed prior to upload
      # See: https://www.linode.com/docs/products/tools/images/guides/upload-an-image/#requirements-and-considerations
      postVM = ''
        ${pkgs.gzip}/bin/gzip -${toString cfg.compressionLevel} -c -- $diskImage > \
        $out/nixos-image-${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}.img.gz
        rm $diskImage
      '';
      format = "raw";
      partitionTableType = "none";
      configFile = if cfg.configFile == null then defaultConfigFile else cfg.configFile;
      inherit (cfg) diskSize;
      inherit config lib pkgs;
    };
  };

  meta.maintainers = with maintainers; [ cyntheticfox ];
}
