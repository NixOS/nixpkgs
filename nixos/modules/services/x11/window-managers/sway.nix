{ config, lib, pkgs, ... }:

with lib;

let
  wmCfg = config.services.xserver.windowManager;

  swayOption = name: {
    enable = mkEnableOption name;
    configFile = mkOption {
      default = null;
      type = types.nullOr types.path;
      description = ''
        Path to the sway configuration file.
        If left at the default value, $HOME/.config/sway/config will be used.
      '';
    };
    debug = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Whether to enable full logging, including debug information.
      '';
    };
    extraSessionCommands = mkOption {
      default = "";
      type = types.lines;
      description = ''
        Shell commands executed just before sway is started.
      '';
    };
  };

  swayConfig = name: pkg: cfg: {
    services.xserver.windowManager.session = [{
      inherit name;
      start = ''
        ${cfg.extraSessionCommands}

        ${pkg}/bin/sway \
          ${optionalString (cfg.configFile != null)
            "-c \"${cfg.configFile}\""
          } \
          ${optionalString (cfg.debug)
            "-d"
          } &
        waitPID=$!
      '';
    }];
    environment.systemPackages = [ pkg ];
  };

in

{
  options.services.xserver.windowManager = {
    sway = swayOption "sway";
  };

  config = mkMerge [
    (mkIf wmCfg.sway.enable (swayConfig "sway" pkgs.sway wmCfg.sway))
  ];
}
