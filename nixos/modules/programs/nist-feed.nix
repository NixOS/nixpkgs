{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.nist-feed;
in
{
  options = {
    programs.nist-feed = {
      enable = mkEnableOption (mdDoc "NIST Feed, which notifies you about the newest published CVEs");
      package = mkPackageOption pkgs "nist-feed" { };
      extraArgs = mkOption {
        type = types.str;
        default = "-l -s CRITICAL";
        description = mdDoc ''
          Arguments to provide to NIST-Feed, see a full list at
          <https://github.com/D3vil0p3r/NIST-Feed/blob/main/README.md#nist-feed>
        '';
      };

      onCalendar = mkOption {
        type = types.str;
        default = "*:0/30";
        description = mdDoc ''
          How often NIST-Feed executes.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    systemd.user.services.nist-feed = {
        wantedBy = [ "default.target" ];
        description = "A notification daemon for CVEs";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${cfg.package}/bin/nist-feed ${escapeShellArgs cfg.extraArgs}";
        };
    };

    systemd.user.timers.nist-feed = {
        wantedBy = [ "default.target" ];
        timerConfig = {
          Unit = "nist-feed.service";
          OnCalendar = cfg.onCalendar;
          Persistent = "true";
        };
    };
  };

  meta.maintainers = with maintainers; [octodi];
}
