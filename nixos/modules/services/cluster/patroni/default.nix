{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.patroni;
  defaultUser = "patroni";
  defaultGroup = "patroni";
  format = pkgs.formats.yaml { };

  configFileName = "patroni-${cfg.scope}-${cfg.name}.yaml";
  configFile = format.generate configFileName cfg.settings;
in
{
  imports = [
    (lib.mkRemovedOptionModule [ "services" "patroni" "raft" ] ''
      Raft has been deprecated by upstream.
    '')
    (lib.mkRemovedOptionModule [ "services" "patroni" "raftPort" ] ''
      Raft has been deprecated by upstream.
    '')
  ];

  options.services.patroni = {

    enable = mkEnableOption "Patroni";

    postgresqlPackage = mkOption {
      type = types.package;
      example = literalExpression "pkgs.postgresql_14";
      description = ''
        PostgreSQL package to use.
        Plugins can be enabled like this `pkgs.postgresql_14.withPackages (p: [ p.pg_safeupdate p.postgis ])`.
      '';
    };

    postgresqlDataDir = mkOption {
      type = types.path;
      defaultText = literalExpression ''"/var/lib/postgresql/''${config.services.patroni.postgresqlPackage.psqlSchema}"'';
      example = "/var/lib/postgresql/14";
      default = "/var/lib/postgresql/${cfg.postgresqlPackage.psqlSchema}";
      description = ''
        The data directory for PostgreSQL. If left as the default value
        this directory will automatically be created before the PostgreSQL server starts, otherwise
        the sysadmin is responsible for ensuring the directory exists with appropriate ownership
        and permissions.
      '';
    };

    postgresqlPort = mkOption {
      type = types.port;
      default = 5432;
      description = ''
        The port on which PostgreSQL listens.
      '';
    };

    user = mkOption {
      type = types.str;
      default = defaultUser;
      example = "postgres";
      description = ''
        The user for the service. If left as the default value this user will automatically be created,
        otherwise the sysadmin is responsible for ensuring the user exists.
      '';
    };

    group = mkOption {
      type = types.str;
      default = defaultGroup;
      example = "postgres";
      description = ''
        The group for the service. If left as the default value this group will automatically be created,
        otherwise the sysadmin is responsible for ensuring the group exists.
      '';
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/patroni";
      description = ''
        Folder where Patroni data will be written, this is where the pgpass password file will be written.
      '';
    };

    scope = mkOption {
      type = types.str;
      example = "cluster1";
      description = ''
        Cluster name.
      '';
    };

    name = mkOption {
      type = types.str;
      example = "node1";
      description = ''
        The name of the host. Must be unique for the cluster.
      '';
    };

    namespace = mkOption {
      type = types.str;
      default = "/service";
      description = ''
        Path within the configuration store where Patroni will keep information about the cluster.
      '';
    };

    nodeIp = mkOption {
      type = types.str;
      example = "192.168.1.1";
      description = ''
        IP address of this node.
      '';
    };

    otherNodesIps = mkOption {
      type = types.listOf types.str;
      example = [ "192.168.1.2" "192.168.1.3" ];
      description = ''
        IP addresses of the other nodes.
      '';
    };

    restApiPort = mkOption {
      type = types.port;
      default = 8008;
      description = ''
        The port on Patroni's REST api listens.
      '';
    };

    softwareWatchdog = mkOption {
      type = types.bool;
      default = false;
      description = ''
        This will configure Patroni to use the software watchdog built into the Linux kernel
        as described in the [documentation](https://patroni.readthedocs.io/en/latest/watchdog.html#setting-up-software-watchdog-on-linux).
      '';
    };

    settings = mkOption {
      type = format.type;
      default = { };
      description = ''
        The primary patroni configuration. See the [documentation](https://patroni.readthedocs.io/en/latest/SETTINGS.html)
        for possible values.
        Secrets should be passed in by using the `environmentFiles` option.
      '';
    };

    environmentFiles = mkOption {
      type = with types; attrsOf (nullOr (oneOf [ str path package ]));
      default = { };
      example = {
        PATRONI_REPLICATION_PASSWORD = "/secret/file";
        PATRONI_SUPERUSER_PASSWORD = "/secret/file";
      };
      description = "Environment variables made available to Patroni as files content, useful for providing secrets from files.";
    };
  };

  config = mkIf cfg.enable {

    services.patroni.settings = {
      scope = cfg.scope;
      name = cfg.name;
      namespace = cfg.namespace;

      restapi = {
        listen = "${cfg.nodeIp}:${toString cfg.restApiPort}";
        connect_address = "${cfg.nodeIp}:${toString cfg.restApiPort}";
      };

      postgresql = {
        listen = "${cfg.nodeIp}:${toString cfg.postgresqlPort}";
        connect_address = "${cfg.nodeIp}:${toString cfg.postgresqlPort}";
        data_dir = cfg.postgresqlDataDir;
        bin_dir = "${cfg.postgresqlPackage}/bin";
        pgpass = "${cfg.dataDir}/pgpass";
      };

      watchdog = mkIf cfg.softwareWatchdog {
        mode = "required";
        device = "/dev/watchdog";
        safety_margin = 5;
      };
    };


    users = {
      users = mkIf (cfg.user == defaultUser) {
        patroni = {
          group = cfg.group;
          isSystemUser = true;
        };
      };
      groups = mkIf (cfg.group == defaultGroup) {
        patroni = { };
      };
    };

    systemd.services = {
      patroni = {
        description = "Runners to orchestrate a high-availability PostgreSQL";

        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        script = ''
          ${concatStringsSep "\n" (attrValues (mapAttrs (name: path: ''export ${name}="$(< ${escapeShellArg path})"'') cfg.environmentFiles))}
          exec ${pkgs.patroni}/bin/patroni ${configFile}
        '';

        serviceConfig = mkMerge [
          {
            User = cfg.user;
            Group = cfg.group;
            Type = "simple";
            Restart = "on-failure";
            TimeoutSec = 30;
            ExecReload = "${pkgs.coreutils}/bin/kill -s HUP $MAINPID";
            KillMode = "process";
          }
          (mkIf (cfg.postgresqlDataDir == "/var/lib/postgresql/${cfg.postgresqlPackage.psqlSchema}" && cfg.dataDir == "/var/lib/patroni") {
            StateDirectory = "patroni postgresql postgresql/${cfg.postgresqlPackage.psqlSchema}";
            StateDirectoryMode = "0750";
          })
        ];
      };
    };

    boot.kernelModules = mkIf cfg.softwareWatchdog [ "softdog" ];

    services.udev.extraRules = mkIf cfg.softwareWatchdog ''
      KERNEL=="watchdog", OWNER="${cfg.user}", GROUP="${cfg.group}", MODE="0600"
    '';

    environment.systemPackages = [
      pkgs.patroni
      cfg.postgresqlPackage
    ];

    environment.etc."${configFileName}".source = configFile;

    environment.sessionVariables = {
      PATRONICTL_CONFIG_FILE = "/etc/${configFileName}";
    };
  };

  meta.maintainers = [ maintainers.phfroidmont ];
}
