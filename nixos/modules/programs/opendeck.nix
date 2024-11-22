{
  config,
  lib,
  pkgs,
}:
let
  cfg = config.programs.opendeck;
  format = pkgs.formats.json { };
in
{
  options.programs.opendeck = {
    enable = lib.mkEnableOption "OpenDeck, a cross-platform desktop application that provides functionality for stream controller devices. ";

    package = lib.mkPackageOption pkgs "opendeck" { };

    settings = lib.mkOption {
      type = lib.types.nullOr lib.types.submodule {
        freeformType = format.type;

        options = {
          language = lib.mkOption {
            type = lib.types.str;
            default = "en";
            example = "de";
            description = ''
              Display language for the OpenDeck.

              While OpenDeck itself is not yet translated, any installed plugins that supports the
              selected language would display its text in that language.
            '';
          };
          background = lib.mkOption {
            type = lib.types.bool;
            default = true;
            example = false;
            description = ''
              Whether OpenDeck should be minimized to tray and run in the background when its window is closed.
            '';
          };
          autolaunch = lib.mkOption {
            type = lib.types.bool;
            default = false;
            example = true;
            description = ''
              Whether to automatically start OpenDeck on login.
            '';
          };
          darktheme = lib.mkOption {
            type = lib.types.bool;
            default = true;
            example = false;
            description = ''
              Whether to use dark theme for OpenDeck.
            '';
          };
          brightness = lib.mkOption {
            type = lib.types.ints.between 0 100;
            default = 50;
            example = 100;
            description = ''
              Brightness of devices connected to OpenDeck.
            '';
          };
          developer = lib.mkOption {
            type = lib.types.bool;
            default = false;
            example = true;
            description = ''
              Whether to enable developer mode and features that make plugin debugging and development
              easier, while also exposing *all* file paths on your device to a local webserver in
              order to symbolically link plugins.
            '';
          };
        };
      };
      default = null;
      description = "Settings for OpenDeck.";
    };

    pluginsDir = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = lib.literalExpression ''/path/to/my/plugins'';
      description = ''
        Path to a folder containing installed plugins.

        The folder should contain folders that each contain a `manifest.json`, as well as the plugin itself.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    services.udev.packages = [ cfg.package ];

    environment.etc."xdg/opendeck/settings.json".source = format.generate "opendeck-settings.json" cfg.settings;

    systemd.tmpfiles.settings."10-opendeck" = {
      "etc/xdg/opendeck/plugins"."L+".argument = lib.mkIf (cfg.pluginsDir != null) "${cfg.pluginsDir}";
    };
  };
}
