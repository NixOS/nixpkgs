{ config, lib, ... }:
let
  cfg = config.services.displayManager.generic;
in
{
  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "displayManager" "preStart" ]
      [ "services" "displayManager" "generic" "preStart" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "displayManager" "execCmd" ]
      [ "services" "displayManager" "generic" "execCmd" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "displayManager" "environment" ]
      [ "services" "displayManager" "generic" "environment" ]
    )
  ];

  options = {
    services.displayManager.generic = {
      enable = lib.mkEnableOption "generic display manager integration - deprecated";

      preStart = lib.mkOption {
        type = lib.types.lines;
        default = "";
        example = "rm -f /var/log/my-display-manager.log";
        description = "Script executed before the display manager is started.";
      };

      execCmd = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = lib.literalExpression ''"''${pkgs.lightdm}/bin/lightdm"'';
        description = "Command to start the display manager.";
      };

      environment = lib.mkOption {
        type = with lib.types; attrsOf unspecified;
        default = { };
        description = "Additional environment variables needed by the display manager.";
      };
    };
  };
  config = lib.mkIf (cfg.enable || cfg.execCmd != null) {
    warnings = [
      (lib.mkIf (!cfg.enable) ''
        Enabling display-manager.service implicitly due to `services.displayManager.generic.execCmd` being set; this will be removed eventually.
        Please set `services.displayManager.generic.enable` explicitly, or switch your display manager to use upstream systemd units (preferred).
      '')
    ];

    services.displayManager.enable = true;

    systemd.services.display-manager = {
      description = "Display Manager";
      after = [
        "acpid.service"
        "systemd-logind.service"
        "systemd-user-sessions.service"
        "autovt@tty1.service"
      ];
      conflicts = [
        "autovt@tty1.service"
      ];
      restartIfChanged = false;

      environment = cfg.environment;

      preStart = cfg.preStart;
      script = cfg.execCmd;

      # Stop restarting if the display manager stops (crashes) 2 times
      # in one minute. Starting X typically takes 3-4s.
      startLimitIntervalSec = 30;
      startLimitBurst = 3;
      serviceConfig = {
        Restart = "always";
        RestartSec = "200ms";
        SyslogIdentifier = "display-manager";
      };
    };
  };
}
