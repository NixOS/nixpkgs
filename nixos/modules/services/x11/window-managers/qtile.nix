{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.qtile;
  qtile = cfg.package;
in

{
  options = {
    services.xserver.windowManager.qtile = {
      enable = mkEnableOption "qtile";

      package = mkOption {
        type = types.package;
        default = pkgs.qtile;
        defaultText = literalExpression "pkgs.qtile";
        example = literalExpression "pkgs.unstable.qtile";
        description = "Qtile package to use.";
      };

      configFile = mkOption {
        type = with types; nullOr path;
        default = null;
        example = literalExpression "/path/to/your/config.py";
        description = ''
          Path to the qtile configuration file.
          If null, $HOME/.config/qtile/config.py will be used.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager.session = [{
      name = "qtile";
      start = ''
        ${qtile}/bin/qtile start ${optionalString (cfg.configFile != null)
          "--config \"${cfg.configFile}\""
        } &
        waitPID=$!
      '';
    }];

    environment.systemPackages = [ qtile ];
  };
}
