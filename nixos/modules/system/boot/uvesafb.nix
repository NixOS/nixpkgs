{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.boot.uvesafb;
  inherit (lib)
    mkIf
    mkEnableOption
    lib.mkOption
    types
    ;
in
{
  options = {
    boot.uvesafb = {
      enable = lib.mkEnableOption "uvesafb";

      gfx-mode = lib.mkOption {
        type = lib.types.str;
        default = "1024x768-32";
        description = "Screen resolution in modedb format. See [uvesafb](https://docs.kernel.org/fb/uvesafb.html) and [modedb](https://docs.kernel.org/fb/modedb.html) documentation for more details. The default value is a sensible default but may be not ideal for all setups.";
      };

      v86d.package = lib.mkOption {
        type = lib.types.package;
        description = "Which v86d package to use with uvesafb";
        defaultText = ''
          config.boot.kernelPackages.v86d.overrideAttrs (old: {
                    hardeningDisable = [ "all" ];
                  })'';
        default = config.boot.kernelPackages.v86d.overrideAttrs (old: {
          hardeningDisable = [ "all" ];
        });
      };
    };
  };
  config = lib.mkIf cfg.enable {
    boot.initrd = {
      kernelModules = [ "uvesafb" ];
      extraFiles."/usr/v86d".source = cfg.v86d.package;
    };

    boot.kernelParams = [
      "video=uvesafb:mode:${cfg.gfx-mode},mtrr:3,ywrap"
      ''uvesafb.v86d="${cfg.v86d.package}/bin/v86d"''
    ];
  };
}
