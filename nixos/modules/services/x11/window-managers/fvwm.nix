{ pkgs, config, ... }:

with pkgs.lib;

let
  cfg = config.services.xserver.windowManager.fvwm;
in

{
  options = {
    services.xserver.windowManager.fvwm = {
      enable = mkOption {
        default = false;
        example = true;
        description = "Enable the fvwm window manager.";
      };

      configFile = mkOption {
        default = null;
        type = types.nullOr types.path;
        description = ''
          Path to the fvwm configuration file.
          If left at the default value, $HOME/.fvwm/config will be used.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager = {
      session = [{
        name = "fvwm";
        start = ''
          ${pkgs.fvwm}/bin/fvwm ${optionalString (cfg.configFile != null)
            "-c \"${cfg.configFile}\""
          } &
          waitPID=$!
        '';
      }];
    };
    environment.systemPackages = [ pkgs.fvwm ];
  };
}
