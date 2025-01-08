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
    lib.mkOption
    mkIf
    types
    literalExpression
    ;
in
{

  meta.maintainers = with lib.maintainers; [ drupol ];

  options = {
    services.chromadb = {
      enable = lib.mkEnableOption "ChromaDB, an open-source AI application database.";

      package = lib.mkOption {
        type = lib.types.package;
        example = lib.literalExpression "pkgs.python3Packages.chromadb";
        default = pkgs.python3Packages.chromadb;
        defaultText = "pkgs.python3Packages.chromadb";
        description = "ChromaDB package to use.";
      };

      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = ''
          Defines the IP address by which ChromaDB will be accessible.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 8000;
        description = ''
          Defined the port number to listen.
        '';
      };

      logFile = lib.mkOption {
        type = lib.types.path;
        default = "/var/log/chromadb/chromadb.log";
        description = ''
          Specifies the location of file for logging output.
        '';
      };

      dbpath = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/chromadb";
        description = "Location where ChromaDB stores its files";
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to automatically open the specified TCP port in the firewall.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.chromadb = {
      description = "ChromaDB";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        StateDirectory = "chromadb";
        WorkingDirectory = "/var/lib/chromadb";
        LogsDirectory = "chromadb";
        ExecStart = "${lib.getExe cfg.package} run --path ${cfg.dbpath} --host ${cfg.host} --port ${toString cfg.port} --log-path ${cfg.logFile}";
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
