{ config, lib, pkgs, ... }:

let
  cfg = config.services.earlyoom;

  inherit (lib)
    mkDefault mkEnableOption mkIf mkOption types
    mkRemovedOptionModule literalExpression
    escapeShellArg concatStringsSep optional;

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
      description = ''
        An absolute path to an executable to be run for each process killed.
        Some environment variables are available, see
        <link xlink:href="https://github.com/rfjakob/earlyoom#notifications">README</link> and
        <link xlink:href="https://github.com/rfjakob/earlyoom/blob/master/MANPAGE.md#-n-pathtoscript">the man page</link>
        for details.
      '';
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "-r 60" "-g" "--prefer '(^|/)(java|chromium)$'" ];
      description = "Extra command-line arguments to be passed to earlyoom.";
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
          "-m ${toString cfg.freeMemThreshold}"
          "-s ${toString cfg.freeSwapThreshold}"
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
