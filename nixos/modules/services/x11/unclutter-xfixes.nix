{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.unclutter-xfixes;

in {
  options.services.unclutter-xfixes = {

    enable = mkOption {
      description = "Enable unclutter-xfixes to hide your mouse cursor when inactive.";
      type = types.bool;
      default = false;
    };

    package = mkOption {
      description = "unclutter-xfixes derivation to use.";
      type = types.package;
      default = pkgs.unclutter-xfixes;
      defaultText = "pkgs.unclutter-xfixes";
    };

    timeout = mkOption {
      description = "Number of seconds before the cursor is marked inactive.";
      type = types.int;
      default = 1;
    };

    threshold = mkOption {
      description = "Minimum number of pixels considered cursor movement.";
      type = types.int;
      default = 1;
    };

    extraOptions = mkOption {
      description = "More arguments to pass to the unclutter-xfixes command.";
      type = types.listOf types.str;
      default = [];
      example = [ "exclude-root" "ignore-scrolling" "fork" ];
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.unclutter-xfixes = {
      description = "unclutter-xfixes";
      wantedBy = [ "graphical.target" ];
      serviceConfig.ExecStart = ''
        ${cfg.package}/bin/unclutter \
          --timeout ${toString cfg.timeout} \
          --jitter ${toString (cfg.threshold - 1)} \
          ${concatMapStrings (x: " --"+x) cfg.extraOptions} \
      '';
      serviceConfig.RestartSec = 3;
      serviceConfig.Restart = "always";
    };
  };
}
