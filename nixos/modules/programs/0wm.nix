{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    literalExpression
    mkOption
    types
    ;

  cfg = config.programs.zwm-client;
  cfgServer = config.services.zwm-server;

  settingsFormat = pkgs.formats.json { };
  configFile = settingsFormat.generate "config.json" cfg.settings;
in
{
  options.programs.zwm-client = {
    enable = lib.mkEnableOption "0wm-client";
    package = lib.mkPackageOption pkgs "_0wm-client" { };

    finalPackage = lib.mkOption {
      type = lib.types.package;
      description = "0WM package wrapped with config file.";
      internal = true;
      readOnly = true;
      visible = false;
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;
        options = {
          api = mkOption {
            type = types.str;
            default = "http://${cfgServer.settings.interface}:${toString cfgServer.settings.port}";
            defaultText = literalExpression "http://\${config.services.zwm-server.settings.interface}:\${toString config.services.zwm-server.settings.port}";
            description = "0WM server address";
          };
        };
      };
      default = { };
      description = "0WM config settings.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zwm-client.finalPackage = cfg.package.override {
      inherit configFile;
    };

    environment.systemPackages = [
      cfg.finalPackage

      # TODO: hide behind a debug option?
      pkgs._0wm-opmode
      pkgs._0wm-server.ap-mock
    ];
  };
}
