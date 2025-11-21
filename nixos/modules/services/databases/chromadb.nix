{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.chromadb;
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    mkIf
    types
    ;
in
{

  meta.maintainers = [ ];

  imports = [
    (lib.mkRemovedOptionModule [ "services" "chromadb" "logFile" ] ''
      ChromaDB has removed the --log-path parameter that logFile relied on.
    '')
  ];

  options = {
    services.chromadb = {
      enable = mkEnableOption "ChromaDB, an open-source AI application database.";

      package = mkPackageOption pkgs [ "python3Packages" "chromadb" ] { };

      host = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = ''
          Defines the IP address by which ChromaDB will be accessible.
        '';
      };

      port = mkOption {
        type = types.port;
        default = 8000;
        description = ''
          Defined the port number to listen.
        '';
      };

      dbpath = mkOption {
        type = types.str;
        default = "/var/lib/chromadb";
        description = "Location where ChromaDB stores its files";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to automatically open the specified TCP port in the firewall.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.chromadb = {
      description = "ChromaDB";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        StateDirectory = "chromadb";
        WorkingDirectory = "/var/lib/chromadb";
        LogsDirectory = "chromadb";
        ExecStart = "${lib.getExe cfg.package} run --path ${cfg.dbpath} --host ${cfg.host} --port ${toString cfg.port}";
        Restart = "on-failure";
        ProtectHome = true;
        ProtectSystem = "strict";
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        NoNewPrivileges = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        PrivateMounts = true;
        DynamicUser = true;
      };
    };

    networking.firewall.allowedTCPPorts = lib.optionals cfg.openFirewall [ cfg.port ];
  };
}
