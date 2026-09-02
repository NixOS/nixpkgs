{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkPackageOption
    mkIf
    ;

  cfg = config.services.rqbit;
  stateDir = "/var/lib/rqbit";
  defaultDownloadDir = "${stateDir}/downloads";
in
{
  options.services.rqbit = {
    enable = mkEnableOption "rqbit BitTorrent daemon";

    package = mkPackageOption pkgs "rqbit" { };

    user = mkOption {
      type = types.str;
      default = "rqbit";
      description = "User account under which rqbit runs.";
    };

    group = mkOption {
      type = types.str;
      default = "rqbit";
      description = "Group account under which rqbit runs.";
    };

    downloadDir = mkOption {
      type = types.path;
      default = defaultDownloadDir;
      example = "/mnt/storage/torrents";
      description = "Directory where to download torrents.";
    };

    httpPort = mkOption {
      type = types.port;
      default = 3030;
      description = "The listen port for the HTTP API.";
    };

    httpHost = mkOption {
      type = types.str;
      default = "127.0.0.1";
      example = "0.0.0.0";
      description = "The listen host for the HTTP API.";
    };

    peerPort = mkOption {
      type = types.port;
      default = 4240;
      description = "The port to listen for incoming BitTorrent peer connections (TCP and uTP).";
    };

    openFirewall = mkEnableOption "opening of the HTTP and Peer ports in the firewall";
  };

  config = mkIf cfg.enable {
    systemd.services.rqbit = {
      description = "rqbit BitTorrent Service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        HOME = stateDir;
        RQBIT_HTTP_API_LISTEN_ADDR = "${
          if (lib.hasInfix ":" cfg.httpHost) then "[${cfg.httpHost}]" else cfg.httpHost
        }:${toString cfg.httpPort}";
        RQBIT_LISTEN_PORT = toString cfg.peerPort;
        RQBIT_SESSION_PERSISTENCE_LOCATION = stateDir;
      };

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} server start ${cfg.downloadDir}";
        User = cfg.user;
        Group = cfg.group;

        StateDirectory = "rqbit";
        StateDirectoryMode = "0750";

        # systemd-analyze security rqbit
        ReadWritePaths = mkIf (cfg.downloadDir != defaultDownloadDir) [ cfg.downloadDir ];
        ProtectSystem = "strict";
        ProtectHome = "read-only";
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        PrivateUsers = true;
        RemoveIPC = true;
        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        ProtectClock = true;
        ProtectHostname = true;
        RestrictNamespaces = true;
        SystemCallFilter = [
          "@system-service"
          "@network-io"
          "@file-system"
          "~@privileged"
          "~@resources"
        ];
        SystemCallArchitectures = "native";
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        MemoryDenyWriteExecute = true;
        LockPersonality = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        UMask = "0027";
      };
    };

    users = {
      users = mkIf (cfg.user == "rqbit") {
        rqbit = {
          inherit (cfg) group;
          isSystemUser = true;
        };
      };
      groups = mkIf (cfg.group == "rqbit") { rqbit = { }; };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [
        cfg.httpPort
        cfg.peerPort
      ];
      allowedUDPPorts = [ cfg.peerPort ];
    };
  };

  meta.maintainers = with lib.maintainers; [ CodedNil ];
}
