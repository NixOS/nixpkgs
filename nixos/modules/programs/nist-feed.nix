{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.nist-feed;
in
{
  options = {
    programs.nist-feed = {
      enable = mkEnableOption (mdDoc "NIST Feed notifies you about the newest published CVEs.");
      package = mkPackageOption pkgs "nist-feed" { };
      arguments = mkOption {
        type = types.str;
        default = "-l -s CRITICAL";
        description = mdDoc ''lib.
          Arguments to provide to NIST-Feed.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    systemd.user.services.nist-feed = {
        wantedBy = [ "default.target" ];
        description = "NIST-Feed service";
        path = [ pkgs.curl pkgs.busybox ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${cfg.package}/bin/nist-feed ${cfg.arguments}";
        };
    };

    systemd.user.timers.nist-feed = {
        wantedBy = [ "default.target" ];
        description = "NIST-Feed timer";
        timerConfig = {
          Unit = "nist-feed.service";
          OnCalendar = "*:0/2";
          Persistent = "true";
        };
    };
  };

  meta.maintainers = with maintainers; [octodi];
}
