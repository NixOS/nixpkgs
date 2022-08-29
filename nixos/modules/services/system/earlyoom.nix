{ config, lib, pkgs, ... }:

let
  cfg = config.services.earlyoom;

  inherit (lib)
    mkDefault mkEnableOption mkIf mkOption types
    mkRemovedOptionModule literalExpression
    escapeShellArg concatStringsSep optional optionalString;

in
{
  options.services.earlyoom = {
    enable = mkEnableOption "Early out of memory killing";

    freeMemThreshold = mkOption {
      type = types.ints.between 1 100;
      default = 10;
      description = lib.mdDoc ''
        Minimum available memory (in percent).

        If the available memory falls below this threshold (and the analog is true for
        {option}`freeSwapThreshold`) the killing begins.
        SIGTERM is sent first to the process that uses the most memory; then, if the available
        memory falls below {option}`freeMemKillThreshold` (and the analog is true for
        {option}`freeSwapKillThreshold`), SIGKILL is sent.

        See [README](https://github.com/rfjakob/earlyoom#command-line-options) for details.
      '';
    };

    freeMemKillThreshold = mkOption {
      type = types.nullOr (types.ints.between 1 100);
      default = null;
      description = lib.mdDoc ''
        Minimum available memory (in percent) before sending SIGKILL.
        If unset, this defaults to half of {option}`freeMemThreshold`.

        See the description of [](#opt-services.earlyoom.freeMemThreshold).
      '';
    };

    freeSwapThreshold = mkOption {
      type = types.ints.between 1 100;
      default = 10;
      description = lib.mdDoc ''
        Minimum free swap space (in percent) before sending SIGTERM.

        See the description of [](#opt-services.earlyoom.freeMemThreshold).
      '';
    };

    freeSwapKillThreshold = mkOption {
      type = types.nullOr (types.ints.between 1 100);
      default = null;
      description = lib.mdDoc ''
        Minimum free swap space (in percent) before sending SIGKILL.
        If unset, this defaults to half of {option}`freeSwapThreshold`.

        See the description of [](#opt-services.earlyoom.freeMemThreshold).
      '';
    };

    enableDebugInfo = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
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
        <literal>systembus-notify</literal> running as your user, which this
        option handles by enabling <option>services.systembus-notify</option>.

        See <link xlink:href="https://github.com/rfjakob/earlyoom#notifications">README</link> for details.
      '';
    };

    killHook = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = literalExpression ''
        pkgs.writeShellScript "earlyoom-kill-hook" '''
          echo "Process $EARLYOOM_NAME ($EARLYOOM_PID) was killed" >> /path/to/log
        '''
      '';
      description = lib.mdDoc ''
        An absolute path to an executable to be run for each process killed.
        Some environment variables are available, see
        [README](https://github.com/rfjakob/earlyoom#notifications) and
        [the man page](https://github.com/rfjakob/earlyoom/blob/master/MANPAGE.md#-n-pathtoscript)
        for details.
      '';
    };

    reportInterval = mkOption {
      type = types.int;
      default = 3600;
      example = 0;
      description = lib.mdDoc "Interval (in seconds) at which a memory report is printed (set to 0 to disable).";
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "-g" "--prefer '(^|/)(java|chromium)$'" ];
      description = lib.mdDoc "Extra command-line arguments to be passed to earlyoom.";
    };
  };

  imports = [
    (mkRemovedOptionModule [ "services" "earlyoom" "useKernelOOMKiller" ] ''
      This option is deprecated and ignored by earlyoom since 1.2.
    '')
    (mkRemovedOptionModule [ "services" "earlyoom" "notificationsCommand" ] ''
      This option was removed in earlyoom 1.6, but was reimplemented in 1.7
      and is available as the new option `services.earlyoom.killHook`.
    '')
    (mkRemovedOptionModule [ "services" "earlyoom" "ignoreOOMScoreAdjust" ] ''
      This option is deprecated and ignored by earlyoom since 1.7.
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
          ("-m ${toString cfg.freeMemThreshold}"
            + optionalString (cfg.freeMemKillThreshold != null) ",${toString cfg.freeMemKillThreshold}")
          ("-s ${toString cfg.freeSwapThreshold}"
            + optionalString (cfg.freeSwapKillThreshold != null) ",${toString cfg.freeSwapKillThreshold}")
          "-r ${toString cfg.reportInterval}"
        ]
        ++ optional cfg.enableDebugInfo "-d"
        ++ optional cfg.enableNotifications "-n"
        ++ optional (cfg.killHook != null) "-N ${escapeShellArg cfg.killHook}"
        ++ cfg.extraArgs
        );
      };
    };
  };
}
