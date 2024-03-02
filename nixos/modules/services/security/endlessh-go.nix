{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.endlessh-go;
in
{
  options.services.endlessh-go = {
    enable = mkEnableOption (mdDoc "endlessh-go service");

    listenAddress = mkOption {
      type = types.str;
      default = "0.0.0.0";
      example = "[::]";
      description = mdDoc ''
        Interface address to bind the endlessh-go daemon to SSH connections.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 2222;
      example = 22;
      description = mdDoc ''
        Specifies on which port the endlessh-go daemon listens for SSH
        connections.

        Setting this to `22` may conflict with {option}`services.openssh`.
      '';
    };

    prometheus = {
      enable = mkEnableOption (mdDoc "Prometheus integration");

      listenAddress = mkOption {
        type = types.str;
        default = "0.0.0.0";
        example = "[::]";
        description = mdDoc ''
          Interface address to bind the endlessh-go daemon to answer Prometheus
          queries.
        '';
      };

      port = mkOption {
        type = types.port;
        default = 2112;
        example = 9119;
        description = mdDoc ''
          Specifies on which port the endlessh-go daemon listens for Prometheus
          queries.
        '';
      };
    };

    extraOptions = mkOption {
      type = with types; listOf str;
      default = [ ];
      example = [ "-conn_type=tcp4" "-max_clients=8192" ];
      description = mdDoc ''
        Additional command line options to pass to the endlessh-go daemon.
      '';
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to open a firewall port for the SSH listener.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.endlessh-go = {
      description = "SSH tarpit";
      requires = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig =
        let
          needsPrivileges = cfg.port < 1024 || cfg.prometheus.port < 1024;
          capabilities = [ "" ] ++ optionals needsPrivileges [ "CAP_NET_BIND_SERVICE" ];
          rootDirectory = "/run/endlessh-go";
        in
        {
          Restart = "always";
          ExecStart = with cfg; concatStringsSep " " ([
            "${pkgs.endlessh-go}/bin/endlessh-go"
            "-logtostderr"
            "-host=${listenAddress}"
            "-port=${toString port}"
          ] ++ optionals prometheus.enable [
            "-enable_prometheus"
            "-prometheus_host=${prometheus.listenAddress}"
            "-prometheus_port=${toString prometheus.port}"
          ] ++ extraOptions);
          DynamicUser = true;
          RootDirectory = rootDirectory;
          BindReadOnlyPaths = [ builtins.storeDir ];
          InaccessiblePaths = [ "-+${rootDirectory}" ];
          RuntimeDirectory = baseNameOf rootDirectory;
          RuntimeDirectoryMode = "700";
          AmbientCapabilities = capabilities;
          CapabilityBoundingSet = capabilities;
          UMask = "0077";
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateTmp = true;
          PrivateUsers = !needsPrivileges;
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectSystem = "strict";
          ProtectProc = "noaccess";
          ProcSubset = "pid";
          RemoveIPC = true;
          RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [ "@system-service" "~@privileged" ];
        };
    };

    networking.firewall.allowedTCPPorts = with cfg;
      optionals openFirewall [ port prometheus.port ];
  };

  meta.maintainers = with maintainers; [ azahi ];
}
