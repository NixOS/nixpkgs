{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.unclutter;

in
{
  options.services.unclutter = {

    enable = lib.mkOption {
      description = "Enable unclutter to hide your mouse cursor when inactive";
      type = lib.types.bool;
      default = false;
    };

    package = lib.mkPackageOption pkgs "unclutter" { };

    keystroke = lib.mkOption {
      description = "Wait for a keystroke before hiding the cursor";
      type = lib.types.bool;
      default = false;
    };

    timeout = lib.mkOption {
      description = "Number of seconds before the cursor is marked inactive";
      type = lib.types.int;
      default = 1;
    };

    threshold = lib.mkOption {
      description = "Minimum number of pixels considered cursor movement";
      type = lib.types.int;
      default = 1;
    };

    excluded = lib.mkOption {
      description = "Names of windows where unclutter should not apply";
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "" ];
    };

    extraOptions = lib.mkOption {
      description = "More arguments to pass to the unclutter command";
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "noevent"
        "grab"
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.unclutter = {
      description = "unclutter";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig.ExecStart = ''
        ${cfg.package}/bin/unclutter \
          -idle ${toString cfg.timeout} \
          -jitter ${toString (cfg.threshold - 1)} \
          ${lib.optionalString cfg.keystroke "-keystroke"} \
          ${lib.concatMapStrings (x: " -" + x) cfg.extraOptions} \
          -not ${lib.concatStringsSep " " cfg.excluded} \
      '';
      serviceConfig.PassEnvironment = "DISPLAY";
      serviceConfig.RestartSec = 3;
      serviceConfig.Restart = "always";
    };
  };

  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "unclutter" "threeshold" ]
      [ "services" "unclutter" "threshold" ]
    )
  ];

  meta.maintainers = with lib.maintainers; [ rnhmjoj ];

}
