{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xserver.windowManager.mlvwm;
in
{

  options.services.xserver.windowManager.mlvwm = {
    enable = lib.mkEnableOption "Macintosh-like Virtual Window Manager";

    package = lib.mkPackageOption pkgs "mlvwm" { };

    configFile = lib.mkOption {
      default = null;
      type = with lib.types; nullOr path;
      description = ''
        Path to the mlvwm configuration file.
        If left at the default value, $HOME/.mlvwmrc will be used.
      '';
    };
  };

  config = lib.mkIf cfg.enable {

    services.xserver.windowManager.session = [
      {
        name = "mlvwm";
        start = ''
          ${cfg.package}/bin/mlvwm ${lib.optionalString (cfg.configFile != null) "-f /etc/mlvwm/mlvwmrc"} &
          waitPID=$!
        '';
      }
    ];

    environment.etc."mlvwm/mlvwmrc" = lib.mkIf (cfg.configFile != null) {
      source = cfg.configFile;
    };

    environment.systemPackages = [ cfg.package ];
  };
}
