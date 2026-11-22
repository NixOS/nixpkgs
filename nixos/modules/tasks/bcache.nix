{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.boot.bcache;
in
{
  options.boot.bcache.enable = lib.mkEnableOption "bcache mount support" // {
    default = true;
    example = false;
  };
  options.boot.initrd.services.bcache.enable = lib.mkEnableOption "bcache support in the initrd" // {
    default = config.boot.bcache.enable;
    defaultText = lib.literalExpression "config.boot.bcache.enable";
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ pkgs.bcache-tools ];

    services.udev.packages = [ pkgs.bcache-tools ];

    boot.initrd.services.udev = lib.mkIf config.boot.initrd.services.bcache.enable {
      packages = [ pkgs.bcache-tools ];
      binPackages = [ pkgs.bcache-tools ];
    };
  };
}
