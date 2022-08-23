{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.tp-auto-kbbl;

in {
  meta.maintainers = with maintainers; [ sebtm ];

  options = {
    services.tp-auto-kbbl = {
      enable = mkEnableOption "Auto toggle keyboard back-lighting on Thinkpads (and maybe other laptops) for Linux";

      package = mkOption {
        type = types.package;
        default = pkgs.tp-auto-kbbl;
        defaultText = literalExpression "pkgs.tp-auto-kbbl";
        description = lib.mdDoc "Package providing {command}`tp-auto-kbbl`.";
      };

      arguments = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = lib.mdDoc ''
          List of arguments appended to `./tp-auto-kbbl --device [device] [arguments]`
        '';
      };

      device = mkOption {
        type = types.str;
        default = "/dev/input/event0";
        description = lib.mdDoc "Device watched for activities.";
      };

    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.services.tp-auto-kbbl = {
      serviceConfig = {
        ExecStart = concatStringsSep " "
          ([ "${cfg.package}/bin/tp-auto-kbbl" "--device ${cfg.device}" ] ++ cfg.arguments);
        Restart = "always";
        Type = "simple";
      };

      unitConfig = {
        Description = "Auto toggle keyboard backlight";
        Documentation = "https://github.com/saibotd/tp-auto-kbbl";
        After = [ "dbus.service" ];
      };

      wantedBy = [ "multi-user.target" ];
    };
  };
}
