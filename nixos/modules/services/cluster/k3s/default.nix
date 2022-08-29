{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.k3s;
  removeOption = config: instruction:
    lib.mkRemovedOptionModule ([ "services" "k3s" ] ++ config) instruction;
in
{
  imports = [
    (removeOption [ "docker" ] "k3s docker option is no longer supported.")
  ];

  # interface
  options.services.k3s = {
    enable = mkEnableOption "k3s";

    package = mkOption {
      type = types.package;
      default = pkgs.k3s;
      defaultText = literalExpression "pkgs.k3s";
      description = lib.mdDoc "Package that should be used for k3s";
    };

    role = mkOption {
      description = lib.mdDoc ''
        Whether k3s should run as a server or agent.
        Note that the server, by default, also runs as an agent.
      '';
      default = "server";
      type = types.enum [ "server" "agent" ];
    };

    serverAddr = mkOption {
      type = types.str;
      description = lib.mdDoc "The k3s server to connect to. This option only makes sense for an agent.";
      example = "https://10.0.0.10:6443";
      default = "";
    };

    token = mkOption {
      type = types.str;
      description = lib.mdDoc ''
        The k3s token to use when connecting to the server. This option only makes sense for an agent.
        WARNING: This option will expose store your token unencrypted world-readable in the nix store.
        If this is undesired use the tokenFile option instead.
      '';
      default = "";
    };

    tokenFile = mkOption {
      type = types.nullOr types.path;
      description = lib.mdDoc "File path containing k3s token to use when connecting to the server. This option only makes sense for an agent.";
      default = null;
    };

    extraFlags = mkOption {
      description = lib.mdDoc "Extra flags to pass to the k3s command.";
      type = types.str;
      default = "";
      example = "--no-deploy traefik --cluster-cidr 10.24.0.0/16";
    };

    disableAgent = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc "Only run the server. This option only makes sense for a server.";
    };

    configPath = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = lib.mdDoc "File path containing the k3s YAML config. This is useful when the config is generated (for example on boot).";
    };
  };

  # implementation

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.role == "agent" -> (cfg.configPath != null || cfg.serverAddr != "");
        message = "serverAddr or configPath (with 'server' key) should be set if role is 'agent'";
      }
      {
        assertion = cfg.role == "agent" -> cfg.configPath != null || cfg.tokenFile != null || cfg.token != "";
        message = "token or tokenFile or configPath (with 'token' or 'token-file' keys) should be set if role is 'agent'";
      }
    ];

    environment.systemPackages = [ config.services.k3s.package ];

    systemd.services.k3s = {
      description = "k3s service";
      after = [ "network.service" "firewall.service" ];
      wants = [ "network.service" "firewall.service" ];
      wantedBy = [ "multi-user.target" ];
      path = optional config.boot.zfs.enabled config.boot.zfs.package;
      serviceConfig = {
        # See: https://github.com/rancher/k3s/blob/dddbd16305284ae4bd14c0aade892412310d7edc/install.sh#L197
        Type = if cfg.role == "agent" then "exec" else "notify";
        KillMode = "process";
        Delegate = "yes";
        Restart = "always";
        RestartSec = "5s";
        LimitNOFILE = 1048576;
        LimitNPROC = "infinity";
        LimitCORE = "infinity";
        TasksMax = "infinity";
        ExecStart = concatStringsSep " \\\n " (
          [
            "${cfg.package}/bin/k3s ${cfg.role}"
          ]
          ++ (optional cfg.disableAgent "--disable-agent")
          ++ (optional (cfg.serverAddr != "") "--server ${cfg.serverAddr}")
          ++ (optional (cfg.token != "") "--token ${cfg.token}")
          ++ (optional (cfg.tokenFile != null) "--token-file ${cfg.tokenFile}")
          ++ (optional (cfg.configPath != null) "--config ${cfg.configPath}")
          ++ [ cfg.extraFlags ]
        );
      };
    };
  };
}
