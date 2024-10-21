{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.hardware.apple.touchBar;
  format = pkgs.formats.toml { };
  cfgFile = format.generate "config.toml" cfg.settings;
in
{
  options.hardware.apple.touchBar = {
    enable = mkEnableOption "support for the Touch Bar on some Apple laptops using tiny-dfr";

    settings = mkOption {
      type = format.type;
      default = { };
      description = ''
        Configuration for tiny-dfr. See
        <https://github.com/WhatAmISupposedToPutHere/tiny-dfr/blob/master/share/tiny-dfr/config.toml>
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.enable -> config.services.udev.enable;
        message = "Touch Bar support via tiny-dfr requires udev.";
      }
    ];

    environment.etc."tiny-dfr/config.toml".source = cfgFile;

    systemd.packages = with pkgs; [ tiny-dfr ];
    services.udev.packages = with pkgs; [ tiny-dfr ];
  };
}
