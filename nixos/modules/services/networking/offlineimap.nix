{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.offlineimap;
in {

  options.services.offlineimap = {
    enable = mkEnableOption "Offlineimap, a software to dispose your mailbox(es) as a local Maildir(s).";

    install = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = ''
        Whether to install a user service for Offlineimap. Once
        the service is started, emails will be fetched automatically.

        The service must be manually started for each user with
        "systemctl --user start offlineimap" or globally through
        <varname>services.offlineimap.enable</varname>.
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.offlineimap;
      defaultText = "pkgs.offlineimap";
      description = "Offlineimap derivation to use.";
    };

    path = mkOption {
      type = types.listOf types.path;
      default = [];
      example = literalExample "[ pkgs.pass pkgs.bash pkgs.notmuch ]";
      description = "List of derivations to put in Offlineimap's path.";
    };

    onCalendar = mkOption {
      type = types.str;
      default = "*:0/3"; # every 3 minutes
      description = "How often is offlineimap started. Default is '*:0/3' meaning every 3 minutes. See systemd.time(7) for more information about the format.";
    };

    timeoutStartSec = mkOption {
      type = types.str;
      default = "120sec"; # Kill if still alive after 2 minutes
      description = "How long waiting for offlineimap before killing it. Default is '120sec' meaning every 2 minutes. See systemd.time(7) for more information about the format.";
    };
  };
  config = mkIf (cfg.enable || cfg.install) {
    systemd.user.services.offlineimap = {
      description = "Offlineimap: a software to dispose your mailbox(es) as a local Maildir(s)";
      serviceConfig = {
        Type      = "oneshot";
        ExecStart = "${cfg.package}/bin/offlineimap -u basic -o -1";
        TimeoutStartSec = cfg.timeoutStartSec;
      };
      path = cfg.path;
    };
    environment.systemPackages = [ "${cfg.package}" ];
    systemd.user.timers.offlineimap = {
      description = "offlineimap timer";
      timerConfig               = {
        Unit = "offlineimap.service";
        OnCalendar = cfg.onCalendar;
        # start immediately after computer is started:
        Persistent = "true";
      };
    } // optionalAttrs cfg.enable { wantedBy = [ "default.target" ]; };
  };
}
