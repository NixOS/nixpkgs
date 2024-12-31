{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.unclutter-xfixes;

in
{
  options.services.unclutter-xfixes = {

    enable = lib.mkOption {
      description = "Enable unclutter-xfixes to hide your mouse cursor when inactive.";
      type = lib.types.bool;
      default = false;
    };

    package = lib.mkPackageOption pkgs "unclutter-xfixes" { };

    timeout = lib.mkOption {
      description = "Number of seconds before the cursor is marked inactive.";
      type = lib.types.int;
      default = 1;
    };

    threshold = lib.mkOption {
      description = "Minimum number of pixels considered cursor movement.";
      type = lib.types.int;
      default = 1;
    };

    extraOptions = lib.mkOption {
      description = "More arguments to pass to the unclutter-xfixes command.";
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "exclude-root"
        "ignore-scrolling"
        "fork"
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.unclutter-xfixes = {
      description = "unclutter-xfixes";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig.ExecStart = ''
        ${cfg.package}/bin/unclutter \
          --timeout ${toString cfg.timeout} \
          --jitter ${toString (cfg.threshold - 1)} \
          ${lib.concatMapStrings (x: " --" + x) cfg.extraOptions} \
      '';
      serviceConfig.RestartSec = 3;
      serviceConfig.Restart = "always";
    };
  };
}
