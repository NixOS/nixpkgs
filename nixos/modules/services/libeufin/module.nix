{
  lib,
  pkgs,
  config,
  ...
}:

let
  settingsFormat = pkgs.formats.ini { };
  this = config.services.libeufin;
in

{
  options.services.libeufin = {
    enable = lib.mkEnableOption "the libeufin system" // lib.mkOption { internal = true; };
    configFile = lib.mkOption {
      internal = true;
      default = settingsFormat.generate "generated-libeufin.conf" this.settings;
    };
    settings = lib.mkOption {
      description = "Global configuration options for the libeufin bank system config file.";
      type = lib.types.submodule { freeformType = settingsFormat.type; };
      default = { };
    };
  };

  config = lib.mkIf this.enable {
    environment.etc."libeufin/libeufin.conf".source = this.configFile;
  };
}
