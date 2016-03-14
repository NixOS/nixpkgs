{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.i3;
in

{
  options = {
    services.xserver.windowManager.i3 = {
      enable = mkEnableOption "i3";

      configFile = mkOption {
        default = null;
        type = types.nullOr types.path;
        description = ''
          Path to the i3 configuration file.
          If left at the default value, $HOME/.i3/config will be used.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager = {
      session = [{
        name = "i3";
        start = ''
          ${pkgs.i3}/bin/i3 ${optionalString (cfg.configFile != null)
            "-c \"${cfg.configFile}\""
          } &
          waitPID=$!
        '';
      }];
    };
    environment.systemPackages = with pkgs; [ i3 ];
  };
}
