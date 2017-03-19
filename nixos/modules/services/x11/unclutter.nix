{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.unclutter;

in {
  options.services.unclutter = {

    enable = mkOption {
      description = "Enable unclutter to hide your mouse cursor when inactive";
      type = types.bool;
      default = false;
    };

    package = mkOption {
      type = types.package;
      default = pkgs.unclutter;
      defaultText = "pkgs.unclutter";
      description = "unclutter derivation to use.";
    };

    keystroke = mkOption {
      description = "Wait for a keystroke before hiding the cursor";
      type = types.bool;
      default = false;
    };

    timeout = mkOption {
      description = "Number of seconds before the cursor is marked inactive";
      type = types.int;
      default = 1;
    };

    threeshold = mkOption {
      description = "Minimum number of pixels considered cursor movement";
      type = types.int;
      default = 1;
    };

    excluded = mkOption {
      description = "Names of windows where unclutter should not apply";
      type = types.listOf types.str;
      default = [];
      example = [ "" ];
    };

    extraOptions = mkOption {
      description = "More arguments to pass to the unclutter command";
      type = types.listOf types.str;
      default = [];
      example = [ "noevent" "grab" ];
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.unclutter = {
      description = "unclutter";
      wantedBy = [ "default.target" ];
      serviceConfig.ExecStart = ''
        ${cfg.package}/bin/unclutter \
          -idle ${toString cfg.timeout} \
          -display :${toString config.services.xserver.display} \
          -jitter ${toString (cfg.threeshold - 1)} \
          ${optionalString cfg.keystroke "-keystroke"} \
          ${concatMapStrings (x: " -"+x) cfg.extraOptions} \
          -not ${concatStringsSep " " cfg.excluded} \
      '';
      serviceConfig.RestartSec = 3;
      serviceConfig.Restart = "always";
    };
  };
}
