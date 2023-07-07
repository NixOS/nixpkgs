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
    enable = mkEnableOption (lib.mdDoc "k3s");

    package = mkOption {
      type = types.package;
      default = pkgs.k3s;
      defaultText = literalExpression "pkgs.k3s";
      description = lib.mdDoc "Package that should be used for k3s";
    };

    role = mkOption {
      description = lib.mdDoc ''
        Whether k3s should run as a server or agent.

        If it's a server:

        - By default it also runs workloads as an agent.
        - Starts by default as a standalone server using an embedded sqlite datastore.
        - Configure `clusterInit = true` to switch over to embedded etcd datastore and enable HA mode.
        - Configure `serverAddr` to join an already-initialized HA cluster.

        If it's an agent:

        - `serverAddr` is required.
      '';
      default = "server";
      type = types.enum [ "server" "agent" ];
    };

    serverAddr = mkOption {
      type = types.str;
      description = lib.mdDoc ''
        The k3s server to connect to.

        Servers and agents need to communicate each other. Read
        [the networking docs](https://rancher.com/docs/k3s/latest/en/installation/installation-requirements/#networking)
        to know how to configure the firewall.
      '';
      example = "https://10.0.0.10:6443";
      default = "";
    };

    clusterInit = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Initialize HA cluster using an embedded etcd datastore.

        If this option is `false` and `role` is `server`

        On a server that was using the default embedded sqlite backend,
        enabling this option will migrate to an embedded etcd DB.

        If an HA cluster using the embedded etcd datastore was already initialized,
        this option has no effect.

        This option only makes sense in a server that is not connecting to another server.

        If you are configuring an HA cluster with an embedded etcd,
        the 1st server must have `clusterInit = true`
        and other servers must connect to it using `serverAddr`.
      '';
    };

    token = mkOption {
      type = types.str;
      description = lib.mdDoc ''
        The k3s token to use when connecting to a server.

        WARNING: This option will expose store your token unencrypted world-readable in the nix store.
        If this is undesired use the tokenFile option instead.
      '';
      default = "";
    };

    tokenFile = mkOption {
      type = types.nullOr types.path;
      description = lib.mdDoc "File path containing k3s token to use when connecting to the server.";
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

    environmentFile = mkOption {
      type = types.nullOr types.path;
      description = lib.mdDoc ''
        File path containing environment variables for configuring the k3s service in the format of an EnvironmentFile. See systemd.exec(5).
      '';
      default = null;
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
      {
        assertion = cfg.role == "agent" -> !cfg.disableAgent;
        message = "disableAgent must be false if role is 'agent'";
      }
      {
        assertion = cfg.role == "agent" -> !cfg.clusterInit;
        message = "clusterInit must be false if role is 'agent'";
      }
    ];

    environment.systemPackages = [ config.services.k3s.package ];

    systemd.services.k3s = {
      description = "k3s service";
      after = [ "firewall.service" "network-online.target" ];
      wants = [ "firewall.service" "network-online.target" ];
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
        EnvironmentFile = cfg.environmentFile;
        ExecStart = concatStringsSep " \\\n " (
          [
            "${cfg.package}/bin/k3s ${cfg.role}"
          ]
          ++ (optional cfg.clusterInit "--cluster-init")
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
