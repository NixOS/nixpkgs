{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.seatd;
  inherit (lib) mkEnableOption lib.mkOption types;
in
{
  meta.maintainers = with lib.maintainers; [ sinanmohd ];

  options.services.seatd = {
    enable = lib.mkEnableOption "seatd";

    user = lib.mkOption {
      type = lib.types.str;
      default = "root";
      description = "User to own the seatd socket";
    };
    group = lib.mkOption {
      type = lib.types.str;
      default = "seat";
      description = "Group to own the seatd socket";
    };
    logLevel = lib.mkOption {
      type = lib.types.enum [
        "debug"
        "info"
        "error"
        "silent"
      ];
      default = "info";
      description = "Logging verbosity";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      seatd
      sdnotify-wrapper
    ];
    users.groups.seat = lib.mkIf (cfg.group == "seat") { };

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
