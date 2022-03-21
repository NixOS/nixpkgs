{ config, lib, pkgs, ... }:

let
  cfg = config.services.earlyoom;

  inherit (lib)
    mkDefault mkEnableOption mkIf mkOption types
    mkRemovedOptionModule
    concatStringsSep optional;

in
{
  options.services.earlyoom = {
    enable = mkEnableOption "Early out of memory killing";

    freeMemThreshold = mkOption {
      type = types.ints.between 1 100;
      default = 10;
      description = ''
        Minimum of availabe memory (in percent).
        If the free memory falls below this threshold and the analog is true for
        <option>services.earlyoom.freeSwapThreshold</option>
        the killing begins.
      '';
    };

    freeSwapThreshold = mkOption {
      type = types.ints.between 1 100;
      default = 10;
      description = ''
        Minimum of availabe swap space (in percent).
        If the available swap space falls below this threshold and the analog
        is true for <option>services.earlyoom.freeMemThreshold</option>
        the killing begins.
      '';
    };

    # TODO: remove or warn after 1.7 (https://github.com/rfjakob/earlyoom/commit/7ebc4554)
    ignoreOOMScoreAdjust = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Ignore oom_score_adjust values of processes.
      '';
    };

    enableDebugInfo = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable debugging messages.
      '';
    };

    enableNotifications = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Send notifications about killed processes via the system d-bus.

        WARNING: enabling this option (while convenient) should *not* be done on a
        machine where you do not trust the other users as it allows any other
        local user to DoS your session by spamming notifications.

        To actually see the notifications in your GUI session, you need to have
        <literal>systembus-notify</literal> running as your user which this
        option handles.

        See <link xlink:href="https://github.com/rfjakob/earlyoom#notifications">README</link> for details.
      '';
    };
  };

  imports = [
    (mkRemovedOptionModule [ "services" "earlyoom" "useKernelOOMKiller" ] ''
      This option is deprecated and ignored by earlyoom since 1.2.
    '')
    (mkRemovedOptionModule [ "services" "earlyoom" "notificationsCommand" ] ''
      This option is deprecated and ignored by earlyoom since 1.6.
    '')
  ];

  config = mkIf cfg.enable {
    services.systembus-notify.enable = mkDefault cfg.enableNotifications;

    systemd.services.earlyoom = {
      description = "Early OOM Daemon for Linux";
      wantedBy = [ "multi-user.target" ];
      path = optional cfg.enableNotifications pkgs.dbus;
      serviceConfig = {
        StandardError = "journal";
        ExecStart = concatStringsSep " " ([
          "${pkgs.earlyoom}/bin/earlyoom"
          "-m ${toString cfg.freeMemThreshold}"
          "-s ${toString cfg.freeSwapThreshold}"
        ]
        ++ optional cfg.ignoreOOMScoreAdjust "-i"
        ++ optional cfg.enableDebugInfo "-d"
        ++ optional cfg.enableNotifications "-n"
        );
      };
    };
  };
}
