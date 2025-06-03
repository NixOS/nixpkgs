{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.xserver.windowManager.mlvwm;

in
{

  options.services.xserver.windowManager.mlvwm = {
    enable = mkEnableOption "Macintosh-like Virtual Window Manager";

    configFile = mkOption {
      default = null;
      type = with types; nullOr path;
      description = ''
        Path to the mlvwm configuration file.
        If left at the default value, $HOME/.mlvwmrc will be used.
      '';
    };
  };

  config = mkIf cfg.enable {

    services.xserver.windowManager.session = [
      {
        name = "mlvwm";
        start = ''
          ${pkgs.mlvwm}/bin/mlvwm ${optionalString (cfg.configFile != null) "-f /etc/mlvwm/mlvwmrc"} &
          waitPID=$!
        '';
      }
    ];

    environment.etc."mlvwm/mlvwmrc" = mkIf (cfg.configFile != null) {
      source = cfg.configFile;
    };

    environment.systemPackages = [ pkgs.mlvwm ];
  };
}
