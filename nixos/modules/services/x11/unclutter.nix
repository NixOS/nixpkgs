{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.unclutter;

in {
  options.services.unclutter = {

    enable = mkOption {
      description = lib.mdDoc "Enable unclutter to hide your mouse cursor when inactive";
      type = types.bool;
      default = false;
    };

    package = mkOption {
      type = types.package;
      default = pkgs.unclutter;
      defaultText = literalExpression "pkgs.unclutter";
      description = lib.mdDoc "unclutter derivation to use.";
    };

    keystroke = mkOption {
      description = lib.mdDoc "Wait for a keystroke before hiding the cursor";
      type = types.bool;
      default = false;
    };

    timeout = mkOption {
      description = lib.mdDoc "Number of seconds before the cursor is marked inactive";
      type = types.int;
      default = 1;
    };

    threshold = mkOption {
      description = lib.mdDoc "Minimum number of pixels considered cursor movement";
      type = types.int;
      default = 1;
    };

    excluded = mkOption {
      description = lib.mdDoc "Names of windows where unclutter should not apply";
      type = types.listOf types.str;
      default = [];
      example = [ "" ];
    };

    extraOptions = mkOption {
      description = lib.mdDoc "More arguments to pass to the unclutter command";
      type = types.listOf types.str;
      default = [];
      example = [ "noevent" "grab" ];
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.unclutter = {
      description = "unclutter";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig.ExecStart = ''
        ${cfg.package}/bin/unclutter \
          -idle ${toString cfg.timeout} \
          -jitter ${toString (cfg.threshold - 1)} \
          ${optionalString cfg.keystroke "-keystroke"} \
          ${concatMapStrings (x: " -"+x) cfg.extraOptions} \
          -not ${concatStringsSep " " cfg.excluded} \
      '';
      serviceConfig.PassEnvironment = "DISPLAY";
      serviceConfig.RestartSec = 3;
      serviceConfig.Restart = "always";
    };
  };

  imports = [
    (mkRenamedOptionModule [ "services" "unclutter" "threeshold" ]
                           [ "services"  "unclutter" "threshold" ])
  ];

  meta.maintainers = with lib.maintainers; [ rnhmjoj ];

}
