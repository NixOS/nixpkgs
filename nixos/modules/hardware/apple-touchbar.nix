{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.hardware.apple.touchBar;
  format = pkgs.formats.toml { };
  cfgFile = format.generate "config.toml" cfg.settings;
in
{
  options.hardware.apple.touchBar = {
    enable = lib.mkEnableOption "support for the Touch Bar on some Apple laptops using tiny-dfr";
    package = lib.mkPackageOption pkgs "tiny-dfr" { };

    settings = lib.mkOption {
      type = format.type;
      default = { };
      description = ''
        Configuration for tiny-dfr. See [example configuration][1] for available options.

        [1]: https://github.com/WhatAmISupposedToPutHere/tiny-dfr/blob/master/share/tiny-dfr/config.toml
      '';
      example = lib.literalExpression ''
        {
          MediaLayerDefault = true;
          ShowButtonOutlines = false;
          EnablePixelShift = true;
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.packages = [ cfg.package ];
    services.udev.packages = [ cfg.package ];

    environment.etc."tiny-dfr/config.toml".source = cfgFile;
    systemd.services.tiny-dfr.restartTriggers = [ cfgFile ];
  };
}
