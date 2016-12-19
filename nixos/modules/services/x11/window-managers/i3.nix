{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.i3;
in

{
  options.services.xserver.windowManager.i3 = {
    enable = mkEnableOption "i3 window manager";

    configFile = mkOption {
      default     = null;
      type        = with types; nullOr path;
      description = ''
        Path to the i3 configuration file.
        If left at the default value, $HOME/.i3/config will be used.
      '';
    };

    extraSessionCommands = mkOption {
      default     = "";
      type        = types.lines;
      description = ''
        Shell commands executed just before i3 is started.
      '';
    };

    package = mkOption {
      type        = types.package;
      default     = pkgs.i3;
      defaultText = "pkgs.i3";
      example     = "pkgs.i3-gaps";
      description = ''
        i3 package to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager.session = [{
      name  = "i3";
      start = ''
        ${cfg.extraSessionCommands}

        ${cfg.package}/bin/i3 ${optionalString (cfg.configFile != null)
          "-c \"${cfg.configFile}\""
        } &
        waitPID=$!
      '';
    }];
    environment.systemPackages = [ cfg.package ];
  };

  imports = [
    (mkRemovedOptionModule [ "services" "xserver" "windowManager" "i3-gaps" "enable" ]
      "Use services.xserver.windowManager.i3.enable and set services.xserver.windowManager.i3.package to pkgs.i3-gaps to use i3-gaps.")
  ];
}
