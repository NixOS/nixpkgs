{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.torrserver;

  boolFlag = name: cliName: lib.optional (cfg.${name} or false) cliName;
  optFlag = name: cliName: lib.optional (cfg.${name} != null) "${cliName}=${toString cfg.${name}}";
  args =
    [ ]
    ++ optFlag "port" "--port"
    ++ optFlag "ip" "--ip"
    ++ boolFlag "ssl" "--ssl"
    ++ optFlag "sslPort" "--sslport"
    ++ optFlag "sslCert" "--sslcert"
    ++ optFlag "sslKey" "--sslkey"
    ++ optFlag "dataDir" "--path"
    ++ optFlag "logPath" "--logpath"
    ++ optFlag "webLogPath" "--weblogpath"
    ++ boolFlag "readOnlyDb" "--rdb"
    ++ boolFlag "httpAuth" "--httpauth"
    ++ boolFlag "dontKill" "--dontkill"
    ++ optFlag "torrentsDir" "--torrentsdir"
    ++ optFlag "torrentAddr" "--torrentaddr"
    ++ optFlag "publicIPv4" "--pubipv4"
    ++ optFlag "publicIPv6" "--pubipv6"
    ++ boolFlag "allowSearchWithoutAuth" "--searchwa"
    ++ optFlag "maxStreamSize" "--maxsize"
    ++ optFlag "telegramToken" "--tg";
in
{
  meta.maintainers = with lib.maintainers; [ r4v3n6101 ];

  options.services.torrserver = {
    enable = lib.mkEnableOption "Enable TorrServer service";

    package = lib.mkPackageOption pkgs "torrserver" { };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the firewall for the TorrServer port.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8090;
      description = "Web server HTTP port";
    };

    ip = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Web server bind address. Null binds to all interfaces";
    };

    ssl = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable HTTPS for web server";
    };

    sslPort = lib.mkOption {
      type = lib.types.nullOr lib.types.port;
      default = null;
      description = "HTTPS port. Null uses previous DB value or default 8091";
    };

    sslCert = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "SSL certificate path. Null generates self-signed cert";
    };

    sslKey = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "SSL key path. Null generates self-signed key";
    };

    dataDir = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Database and configuration directory path";
    };

    workingDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/torrserver";
      description = "Working directory for TorrServer";
    };

    logPath = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Server log file path";
    };

    webLogPath = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Web access log file path";
    };

    readOnlyDb = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Start server in read-only database mode";
    };

    httpAuth = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable HTTP authentication on all requests";
    };

    dontKill = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Do not terminate server on signal";
    };

    torrentsDir = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Directory to auto-load torrent files from";
    };

    torrentAddr = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Torrent client address ([IP]:PORT)";
    };

    publicIPv4 = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Public IPv4 address";
    };

    publicIPv6 = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Public IPv6 address";
    };

    allowSearchWithoutAuth = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Allow search without authentication";
    };

    maxStreamSize = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      description = "Maximum allowed stream size in bytes";
    };

    telegramToken = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Telegram bot token";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.torrserver = {
      description = "TorrServer";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} ${lib.concatStringsSep " " args}";
        WorkingDirectory = cfg.workingDir;

        StateDirectory = "torrserver";
        StateDirectoryMode = "0755";

        Restart = "on-failure";
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
  };
}
