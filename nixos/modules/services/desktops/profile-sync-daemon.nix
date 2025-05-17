{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.psd;
in
{
  options.services.psd = with lib.types; {
    enable = lib.mkOption {
      type = bool;
      default = false;
      description = ''
        Whether to enable the Profile Sync daemon.
      '';
    };
    resyncTimer = lib.mkOption {
      type = str;
      default = "1h";
      example = "1h 30min";
      description = ''
        The amount of time to wait before syncing browser profiles back to the
        disk.

        Takes a systemd.unit time span. The time unit defaults to seconds if
        omitted.
      '';
    };
    overlayfsUsers = lib.mkOption {
      type = listOf str;
      default = [];
      example = "[ \"somebody\" ]";
      description = ''
        The users to add to sudoers that can run psd-overlay-helper without
        a password. See the manpage FAQ for an explanation.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd = {
      user = {
        services = {
          psd = {
            enable = true;
            description = "Profile Sync daemon";
            wants = [ "psd-resync.service" ];
            wantedBy = [ "default.target" ];
            path = with pkgs; [
              rsync
              kmod
              gawk
              nettools
              util-linux
              profile-sync-daemon
            ];
            unitConfig = {
              RequiresMountsFor = [ "/home/" ];
            };
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = "yes";
              ExecStart = "${pkgs.profile-sync-daemon}/bin/profile-sync-daemon startup";
              ExecStop = "${pkgs.profile-sync-daemon}/bin/profile-sync-daemon unsync";
            };
          };

          psd-resync = {
            enable = true;
            description = "Timed profile resync";
            after = [ "psd.service" ];
            wants = [ "psd-resync.timer" ];
            partOf = [ "psd.service" ];
            wantedBy = [ "default.target" ];
            path = with pkgs; [
              rsync
              kmod
              gawk
              nettools
              util-linux
              profile-sync-daemon
            ];
            serviceConfig = {
              Type = "oneshot";
              ExecStart = "${pkgs.profile-sync-daemon}/bin/profile-sync-daemon resync";
            };
          };
        };

        timers.psd-resync = {
          description = "Timer for profile sync daemon - ${cfg.resyncTimer}";
          partOf = [
            "psd-resync.service"
            "psd.service"
          ];

          timerConfig = {
            OnUnitActiveSec = "${cfg.resyncTimer}";
          };
        };
      };
    };
    security.sudo.extraRules = lib.mkAfter (lib.lists.optional (cfg.overlayfsUsers != []) {
      users = cfg.overlayfsUsers;
      runAs = "ALL";
      commands = [ { command = "${pkgs.profile-sync-daemon}/bin/psd-overlay-helper"; options = [ "NOPASSWD" ]; } ];
    });
  };
}
