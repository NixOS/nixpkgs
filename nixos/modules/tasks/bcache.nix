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
    description = ''
      *This will only be used when systemd is used in stage 1.*

      Whether to enable bcache support in the initrd.
    '';
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ pkgs.bcache-tools ];

    services.udev.packages = [ pkgs.bcache-tools ];

    boot.initrd.extraUdevRulesCommands = lib.mkIf (!config.boot.initrd.systemd.enable) ''
      cp -v ${pkgs.bcache-tools}/lib/udev/rules.d/*.rules $out/
    '';

    boot.initrd.services.udev = lib.mkIf config.boot.initrd.services.bcache.enable {
      packages = [ pkgs.bcache-tools ];
      binPackages = [ pkgs.bcache-tools ];
    };
  };
}
