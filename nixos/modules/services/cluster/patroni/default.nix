{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.patroni;
  defaultUser = "patroni";
  defaultGroup = "patroni";
  format = pkgs.formats.yaml { };

  #boto doesn't support python 3.10 yet
  patroni = pkgs.patroni.override { pythonPackages = pkgs.python39Packages; };

  configFileName = "patroni-${cfg.scope}-${cfg.name}.yaml";
  configFile = format.generate configFileName cfg.settings;
in
{
  options.services.patroni = {

    enable = mkEnableOption (lib.mdDoc "Patroni");

    postgresqlPackage = mkOption {
      type = types.package;
      example = literalExpression "pkgs.postgresql_14";
      description = mdDoc ''
        PostgreSQL package to use.
        Plugins can be enabled like this `pkgs.postgresql_14.withPackages (p: [ p.pg_safeupdate p.postgis ])`.
      '';
    };

    postgresqlDataDir = mkOption {
      type = types.path;
      defaultText = literalExpression ''"/var/lib/postgresql/''${config.services.patroni.postgresqlPackage.psqlSchema}"'';
      example = "/var/lib/postgresql/14";
      default = "/var/lib/postgresql/${cfg.postgresqlPackage.psqlSchema}";
      description = mdDoc ''
        The data directory for PostgreSQL. If left as the default value
        this directory will automatically be created before the PostgreSQL server starts, otherwise
        the sysadmin is responsible for ensuring the directory exists with appropriate ownership
        and permissions.
      '';
    };

    postgresqlPort = mkOption {
      type = types.port;
      default = 5432;
      description = mdDoc ''
        The port on which PostgreSQL listens.
      '';
    };

    user = mkOption {
      type = types.str;
      default = defaultUser;
      example = "postgres";
      description = mdDoc ''
        The user for the service. If left as the default value this user will automatically be created,
        otherwise the sysadmin is responsible for ensuring the user exists.
      '';
    };

    group = mkOption {
      type = types.str;
      default = defaultGroup;
      example = "postgres";
      description = mdDoc ''
        The group for the service. If left as the default value this group will automatically be created,
        otherwise the sysadmin is responsible for ensuring the group exists.
      '';
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/patroni";
      description = mdDoc ''
        Folder where Patroni data will be written, used by Raft as well if enabled.
      '';
    };

    scope = mkOption {
      type = types.str;
      example = "cluster1";
      description = mdDoc ''
        Cluster name.
      '';
    };

    name = mkOption {
      type = types.str;
      example = "node1";
      description = mdDoc ''
        The name of the host. Must be unique for the cluster.
      '';
    };

    namespace = mkOption {
      type = types.str;
      default = "/service";
      description = mdDoc ''
        Path within the configuration store where Patroni will keep information about the cluster.
      '';
    };

    nodeIp = mkOption {
      type = types.str;
      example = "192.168.1.1";
      description = mdDoc ''
        IP address of this node.
      '';
    };

    otherNodesIps = mkOption {
      type = types.listOf types.string;
      example = [ "192.168.1.2" "192.168.1.3" ];
      description = mdDoc ''
        IP addresses of the other nodes.
      '';
    };

    restApiPort = mkOption {
      type = types.port;
      default = 8008;
      description = mdDoc ''
        The port on Patroni's REST api listens.
      '';
    };

    raft = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        This will configure Patroni to use its own RAFT implementation instead of using a dedicated DCS.
      '';
    };

    raftPort = mkOption {
      type = types.port;
      default = 5010;
      description = mdDoc ''
        The port on which RAFT listens.
      '';
    };

    softwareWatchdog = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc ''
        This will configure Patroni to use the software watchdog built into the Linux kernel
        as described in the [documentation](https://patroni.readthedocs.io/en/latest/watchdog.html#setting-up-software-watchdog-on-linux).
      '';
    };

    settings = mkOption {
      type = format.type;
      default = { };
      description = mdDoc ''
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
      description = mdDoc "Environment variables made available to Patroni as files content, useful for providing secrets from files.";
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

      raft = mkIf cfg.raft {
        data_dir = "${cfg.dataDir}/raft";
        self_addr = "${cfg.nodeIp}:5010";
        partner_addrs = map (ip: ip + ":5010") cfg.otherNodesIps;
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
          exec ${patroni}/bin/patroni ${configFile}
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
            StateDirectory = "patroni patroni/raft postgresql postgresql/${cfg.postgresqlPackage.psqlSchema}";
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
      patroni
      cfg.postgresqlPackage
      (mkIf cfg.raft pkgs.python310Packages.pysyncobj)
    ];

    environment.etc."${configFileName}".source = configFile;

    environment.sessionVariables = {
      PATRONICTL_CONFIG_FILE = "/etc/${configFileName}";
    };
  };

  meta.maintainers = [ maintainers.phfroidmont ];
}
