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

    settings = lib.mkOption {
      type = format.type;
      default = { };
      description = ''
        Configuration for tiny-dfr. See
        <https://github.com/WhatAmISupposedToPutHere/tiny-dfr/blob/master/share/tiny-dfr/config.toml>
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
    assertions = [
      {
        assertion = cfg.enable -> config.services.udev.enable;
        message = "Touch Bar support via tiny-dfr requires udev.";
      }
    ];

    environment.etc."tiny-dfr/config.toml".source = cfgFile;

    systemd.packages = with pkgs; [ tiny-dfr ];
    services.udev.packages = with pkgs; [ tiny-dfr ];

    systemd.services.tiny-dfr.restartTriggers = [ cfgFile ];
  };
}
