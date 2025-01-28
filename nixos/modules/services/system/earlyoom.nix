{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.earlyoom;

  inherit (lib)
    literalExpression
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    mkRemovedOptionModule
    optionalString
    optionals
    types
    ;
in
{
  meta = {
    maintainers = with lib.maintainers; [ ];
  };

  options.services.earlyoom = {
    enable = mkEnableOption "early out of memory killing";

    package = mkPackageOption pkgs "earlyoom" { };

    freeMemThreshold = mkOption {
      type = types.ints.between 1 100;
      default = 10;
      description = ''
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
      description = ''
        Minimum available memory (in percent) before sending SIGKILL.
        If unset, this defaults to half of {option}`freeMemThreshold`.

        See the description of [](#opt-services.earlyoom.freeMemThreshold).
      '';
    };

    freeSwapThreshold = mkOption {
      type = types.ints.between 1 100;
      default = 10;
      description = ''
        Minimum free swap space (in percent) before sending SIGTERM.

        See the description of [](#opt-services.earlyoom.freeMemThreshold).
      '';
    };

    freeSwapKillThreshold = mkOption {
      type = types.nullOr (types.ints.between 1 100);
      default = null;
      description = ''
        Minimum free swap space (in percent) before sending SIGKILL.
        If unset, this defaults to half of {option}`freeSwapThreshold`.

        See the description of [](#opt-services.earlyoom.freeMemThreshold).
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
        `systembus-notify` running as your user, which this
        option handles by enabling {option}`services.systembus-notify`.

        See [README](https://github.com/rfjakob/earlyoom#notifications) for details.
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
      description = ''
        An absolute path to an executable to be run for each process killed.
        Some environment variables are available, see
        [README](https://github.com/rfjakob/earlyoom#notifications) and
        [the man page](https://github.com/rfjakob/earlyoom/blob/master/MANPAGE.md#-n-pathtoscript)
        for details.

        WARNING: earlyoom is running in a sandbox with ProtectSystem="strict"
        by default, so filesystem write is also prohibited for the hook.
        If you want to change these protection rules, override the systemd
        service via `systemd.services.earlyoom.serviceConfig.ProtectSystem`.
      '';
    };

    reportInterval = mkOption {
      type = types.int;
      default = 3600;
      example = 0;
      description = "Interval (in seconds) at which a memory report is printed (set to 0 to disable).";
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [
        "-g"
        "--prefer"
        "(^|/)(java|chromium)$"
      ];
      description = ''
        Extra command-line arguments to be passed to earlyoom. Each element in
        the value list will be escaped as an argument without further
        word-breaking.
      '';
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

    systemd.packages = [ cfg.package ];

    systemd.services.earlyoom = {
      overrideStrategy = "asDropin";

      wantedBy = [ "multi-user.target" ];
      path = optionals cfg.enableNotifications [ pkgs.dbus ];

      # We setup `EARLYOOM_ARGS` via drop-ins, so disable the default import
      # from /etc/default/earlyoom.
      serviceConfig.EnvironmentFile = "";

      environment.EARLYOOM_ARGS =
        lib.cli.toGNUCommandLineShell { } {
          m =
            "${toString cfg.freeMemThreshold}"
            + optionalString (cfg.freeMemKillThreshold != null) ",${toString cfg.freeMemKillThreshold}";
          s =
            "${toString cfg.freeSwapThreshold}"
            + optionalString (cfg.freeSwapKillThreshold != null) ",${toString cfg.freeSwapKillThreshold}";
          r = "${toString cfg.reportInterval}";
          d = cfg.enableDebugInfo;
          n = cfg.enableNotifications;
          N = if cfg.killHook != null then cfg.killHook else null;
        }
        + " "
        + lib.escapeShellArgs cfg.extraArgs;
    };
  };
}
