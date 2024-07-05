{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.endlessh;
in
{
  options.services.endlessh = {
    enable = mkEnableOption "endlessh service";

    port = mkOption {
      type = types.port;
      default = 2222;
      example = 22;
      description = ''
        Specifies on which port the endlessh daemon listens for SSH
        connections.

        Setting this to `22` may conflict with {option}`services.openssh`.
      '';
    };

    extraOptions = mkOption {
      type = with types; listOf str;
      default = [ ];
      example = [ "-6" "-d 9000" "-v" ];
      description = ''
        Additional command line options to pass to the endlessh daemon.
      '';
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to open a firewall port for the SSH listener.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.endlessh = {
      description = "SSH tarpit";
      requires = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig =
        let
          needsPrivileges = cfg.port < 1024;
          capabilities = [ "" ] ++ optionals needsPrivileges [ "CAP_NET_BIND_SERVICE" ];
          rootDirectory = "/run/endlessh";
        in
        {
          Restart = "always";
          ExecStart = with cfg; concatStringsSep " " ([
            "${pkgs.endlessh}/bin/endlessh"
            "-p ${toString port}"
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
          SystemCallFilter = [ "@system-service" "~@resources" "~@privileged" ];
        };
    };

    networking.firewall.allowedTCPPorts = with cfg;
      optionals openFirewall [ port ];
  };

  meta.maintainers = with maintainers; [ azahi ];
}
