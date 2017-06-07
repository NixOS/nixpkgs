{ config, lib, pkgs, ...}:

with lib;

let
  cfg = config.services.wayland.windowManager.sway;
in

{
  ### Interface
  options =  services.wayland.windowManager.sway  { 
    enable = mkEnableOption "Sway window manager";

    configFile = mkOption {
      default = null;
      type = with types; nullOr path;
      description =
      ''
      Location of the Sway configuration file.
      '';
        };
      };
    

    ### Implementation

    config = mkIf cfg.enable {
      services.wayland.windowManager.session = [{
        name = "sway";
        start =
        ''
        ${pkgs.sway}/bin/sway ${optionalString (cfg.configFile != null)
        "-c \"${cfg.configFile}\""
      } & waitPID=$!
      '';

    }];

    environment.systemPackages = [ pkgs.sway ];

  };
}

