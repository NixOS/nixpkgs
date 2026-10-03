{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.t3code;
in
{
  options.services.t3code = {
    enable = lib.mkEnableOption "T3 Code, a web GUI for coding agents" // {
      description = ''
        Whether to enable T3 Code, a web GUI for coding agents.
        Do not also run `t3 service install`: it installs a second,
        self-updating copy from npm outside the Nix store.
      '';
    };

    package = lib.mkPackageOption pkgs "t3code" {
      example = "t3code.override { enableClaude = true; }";
    };

    user = lib.mkOption {
      type = lib.types.str;
      example = "alice";
      description = ''
        User to run T3 Code as. The agents it launches act with this user's
        permissions, repositories and provider credentials. T3 Code stores its
        state in {file}`~/.t3` of this user.
      '';
    };

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "0.0.0.0";
      description = "Host or interface to bind to.";
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
    systemd.services.t3code = {
      description = "T3 Code server";
      wantedBy = [ "multi-user.target" ];
      environment.T3CODE_TELEMETRY_ENABLED = lib.mkDefault "false";

      serviceConfig = {
        User = cfg.user;
        WorkingDirectory = "~";
        ExecStart = "${lib.getExe' cfg.package "t3"} serve --host ${cfg.host} --port ${toString cfg.port}";
        LogFilterPatterns = [
          "~^Token: "
          "~^Pairing URL: "
          "~[█▀▄]"
        ];
        KillMode = "mixed";
        OOMPolicy = "continue";
        Restart = "always";
        RestartSec = 5;
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
  };

  meta.maintainers = with lib.maintainers; [ jakob1379 ];
}
