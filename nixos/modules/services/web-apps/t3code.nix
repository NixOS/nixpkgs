{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  cfg = config.services.t3code;
in
{
  options.services.t3code = {
    enable = lib.mkEnableOption "T3 Code, a web GUI for coding agents";

    package = lib.mkPackageOption pkgs "t3code-cli" {
      example = "t3code-cli.override { enableClaude = true; }";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "t3code";
      example = "alice";
      description = ''
        User to run T3 Code as. The agents it launches act with this user's
        permissions, repositories and provider credentials. T3 Code stores its
        state in {file}`~/.t3` of this user. The `t3code` user is created when
        this is left at the default.

        {option}`services.t3code.package` is installed for this user. Pair a
        client by running {command}`t3 auth pairing create` as this user.
      '';
    };

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "0.0.0.0";
      description = ''
        Host or interface to bind to. Anyone who reaches a non-loopback address
        can drive agents with the permissions of {option}`services.t3code.user`,
        so restrict it to trusted networks.
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 3773;
      description = "Port for the HTTP/WebSocket server.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open {option}`services.t3code.port` in the firewall.";
    };
  };

  config = lib.mkIf cfg.enable {
    # A user unit, as upstream installs it, so agents get their own scopes in the user's systemd manager.
    systemd.user.services.t3code = {
      description = "T3 Code server";
      wantedBy = [ "default.target" ];
      unitConfig.ConditionUser = cfg.user;
      environment.T3CODE_TELEMETRY_ENABLED = lib.mkDefault "false";

      serviceConfig = {
        WorkingDirectory = "~";
        ExecStart = "${lib.getExe' cfg.package "t3"} serve --host ${utils.escapeSystemdExecArg cfg.host} --port ${toString cfg.port}";
        KillMode = "mixed";
        OOMPolicy = "continue";
        Restart = "always";
        RestartSec = 5;
      };
    };

    users.users.${cfg.user} = lib.mkMerge [
      {
        linger = true;
        packages = [ cfg.package ];
      }
      (lib.mkIf (cfg.user == "t3code") {
        isNormalUser = true;
        description = "T3 Code user";
      })
    ];

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
  };

  meta.maintainers = with lib.maintainers; [ jakob1379 ];
}
