{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.endlessh-go;
in
{
  options.services.endlessh-go = {
    enable = lib.mkEnableOption "endlessh-go service";

    package = lib.mkPackageOption pkgs "endlessh-go" { };

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      example = "[::]";
      description = ''
        Interface address to bind the endlessh-go daemon to SSH connections.
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 2222;
      example = 22;
      description = ''
        Specifies on which port the endlessh-go daemon listens for SSH
        connections.

        Setting this to `22` may conflict with {option}`services.openssh`.
      '';
    };

    prometheus = {
      enable = lib.mkEnableOption "Prometheus integration";

      listenAddress = lib.mkOption {
        type = lib.types.str;
        default = "0.0.0.0";
        example = "[::]";
        description = ''
          Interface address to bind the endlessh-go daemon to answer Prometheus
          queries.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 2112;
        example = 9119;
        description = ''
          Specifies on which port the endlessh-go daemon listens for Prometheus
          queries.
        '';
      };
    };

    extraOptions = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      example = [
        "-conn_type=tcp4"
        "-max_clients=8192"
      ];
      description = ''
        Additional command line options to pass to the endlessh-go daemon.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to open a firewall port for the SSH listener.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.endlessh-go = {
      description = "SSH tarpit";
      requires = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig =
        let
          needsPrivileges = cfg.port < 1024 || cfg.prometheus.port < 1024;
          capabilities = [ "" ] ++ lib.optionals needsPrivileges [ "CAP_NET_BIND_SERVICE" ];
          rootDirectory = "/run/endlessh-go";
        in
        {
          Restart = "always";
          ExecStart =
            with cfg;
            lib.concatStringsSep " " (
              [
                (lib.getExe cfg.package)
                "-logtostderr"
                "-host=${listenAddress}"
                "-port=${toString port}"
              ]
              ++ lib.optionals prometheus.enable [
                "-enable_prometheus"
                "-prometheus_host=${prometheus.listenAddress}"
                "-prometheus_port=${toString prometheus.port}"
              ]
              ++ extraOptions
            );
          DynamicUser = true;
          RootDirectory = rootDirectory;
          BindReadOnlyPaths = [
            builtins.storeDir
            "-/etc/hosts"
            "-/etc/localtime"
            "-/etc/nsswitch.conf"
            "-/etc/resolv.conf"
          ];
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
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "@system-service"
            "~@privileged"
          ];
        };
    };

    networking.firewall.allowedTCPPorts = with cfg; lib.optionals openFirewall [ port ];
  };

  meta.maintainers = with lib.maintainers; [ azahi ];
}
