{ config, lib, pkgs, ... }:

with lib;

let
  ecfg = config.services.earlyoom;
in
{
  options = {
    services.earlyoom = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable early out of memory killing.
        '';
      };

      freeMemThreshold = mkOption {
        type = types.int;
        default = 10;
        description = ''
          Minimum of availabe memory (in percent).
          If the free memory falls below this threshold and the analog is true for
          <option>services.earlyoom.freeSwapThreshold</option>
          the killing begins.
        '';
      };

      freeSwapThreshold = mkOption {
        type = types.int;
        default = 10;
        description = ''
          Minimum of availabe swap space (in percent).
          If the available swap space falls below this threshold and the analog
          is true for <option>services.earlyoom.freeMemThreshold</option>
          the killing begins.
        '';
      };

      useKernelOOMKiller= mkOption {
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
        example = "sudo -u example_user DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus notify-send";
        description = ''
          Command used to send notifications.

          See <link xlink:href="https://github.com/rfjakob/earlyoom#notifications">README</link> for details.
        '';
      };
    };
  };

  config = mkIf ecfg.enable {
    assertions = [
      { assertion = ecfg.freeMemThreshold > 0 && ecfg.freeMemThreshold <= 100;
        message = "Needs to be a positive percentage"; }
      { assertion = ecfg.freeSwapThreshold > 0 && ecfg.freeSwapThreshold <= 100;
        message = "Needs to be a positive percentage"; }
      { assertion = !ecfg.useKernelOOMKiller || !ecfg.ignoreOOMScoreAdjust;
        message = "Both options in conjunction do not make sense"; }
    ];

    systemd.services.earlyoom = {
      description = "Early OOM Daemon for Linux";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        StandardOutput = "null";
        StandardError = "syslog";
        ExecStart = ''
          ${pkgs.earlyoom}/bin/earlyoom \
          -m ${toString ecfg.freeMemThreshold} \
          -s ${toString ecfg.freeSwapThreshold} \
          ${optionalString ecfg.useKernelOOMKiller "-k"} \
          ${optionalString ecfg.ignoreOOMScoreAdjust "-i"} \
          ${optionalString ecfg.enableDebugInfo "-d"} \
          ${optionalString (ecfg.notificationsCommand != null)
            "-N ${escapeShellArg ecfg.notificationsCommand}"}
        '';
      };
    };
  };
}
