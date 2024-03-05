{ config, lib, pkgs, ... }:

let
  cfg = config.services.seatd;
  inherit (lib) mkEnableOption mkOption mdDoc types;
in
{
  meta.maintainers = with lib.maintainers; [ sinanmohd ];

  options.services.seatd = {
    enable = mkEnableOption (mdDoc "seatd");

    user = mkOption {
      type = types.str;
      default = "root";
      description = mdDoc "User to own the seatd socket";
    };
    group = mkOption {
      type = types.str;
      default = "seat";
      description = mdDoc "Group to own the seatd socket";
    };
    logLevel = mkOption {
      type = types.enum [ "debug" "info" "error" "silent" ];
      default = "info";
      description = mdDoc "Logging verbosity";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ seatd sdnotify-wrapper ];
    users.groups.seat = lib.mkIf (cfg.group == "seat") {};

    systemd.services.seatd = {
      description = "Seat management daemon";
      documentation = [ "man:seatd(1)" ];

      wantedBy = [ "multi-user.target" ];
      restartIfChanged = false;

      serviceConfig = {
        Type = "notify";
        NotifyAccess = "all";
        SyslogIdentifier = "seatd";
        ExecStart = "${pkgs.sdnotify-wrapper}/bin/sdnotify-wrapper ${pkgs.seatd.bin}/bin/seatd -n 1 -u ${cfg.user} -g ${cfg.group} -l ${cfg.logLevel}";
        RestartSec = 1;
        Restart = "always";
      };
    };
  };
}
