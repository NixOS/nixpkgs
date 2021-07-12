{ config, lib, pkgs, ... }:

let
  cfg = config.services.earlyoom;

  inherit (lib)
    mkDefault mkEnableOption mkIf mkOption types
    concatStringsSep optional;

in
{
  options = {
    services.earlyoom = {

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

      useKernelOOMKiller = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Use kernel OOM killer instead of own user-space implementation.
        '';
      };

      ignoreOOMScoreAdjust = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Ignore oom_score_adjust values of processes.
          User-space implementation only.
        '';
      };

      enableDebugInfo = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable debugging messages.
        '';
      };

      notificationsCommand = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          This option is deprecated and ignored by earlyoom since 1.6.
          Use <option>services.earlyoom.enableNotifications</option> instead.
        '';
      };

      enableNotifications = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Send notifications about killed processes via the system d-bus.
          To actually see the notifications in your GUI session, you need to have
          <literal>systembus-notify</literal> running as your user which this
          option handles.

          See <link xlink:href="https://github.com/rfjakob/earlyoom#notifications">README</link> for details.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !cfg.useKernelOOMKiller || !cfg.ignoreOOMScoreAdjust;
        message = "Both options in conjunction do not make sense";
      }
    ];

    warnings = optional (cfg.notificationsCommand != null)
      "`services.earlyoom.notificationsCommand` is deprecated and ignored by earlyoom since 1.6.";

    services.systembus-notify.enable = mkDefault cfg.enableNotifications;

    systemd.services.earlyoom = {
      description = "Early OOM Daemon for Linux";
      wantedBy = [ "multi-user.target" ];
      path = optional cfg.enableNotifications pkgs.dbus;
      serviceConfig = {
        StandardOutput = "null";
        ExecStart = concatStringsSep " " ([
          "${pkgs.earlyoom}/bin/earlyoom"
          "-m ${toString cfg.freeMemThreshold}"
          "-s ${toString cfg.freeSwapThreshold}"
        ]
        ++ optional cfg.useKernelOOMKiller "-k"
        ++ optional cfg.ignoreOOMScoreAdjust "-i"
        ++ optional cfg.enableDebugInfo "-d"
        ++ optional cfg.enableNotifications "-n"
        );
      };
    };
  };
}
