{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.kapacitor;

  kapacitorConf = pkgs.writeTextFile {
    name = "kapacitord.conf";
    text = ''
      hostname="${config.networking.hostName}"
      data_dir="${cfg.dataDir}"

      [http]
        bind-address = "${cfg.bind}:${toString cfg.port}"
        log-enabled = false
        auth-enabled = false

      [task]
        dir = "${cfg.dataDir}/tasks"
        snapshot-interval = "${cfg.taskSnapshotInterval}"

      [replay]
        dir = "${cfg.dataDir}/replay"

      [storage]
        boltdb = "${cfg.dataDir}/kapacitor.db"

      ${optionalString (cfg.loadDirectory != null) ''
        [load]
          enabled = true
          dir = "${cfg.loadDirectory}"
      ''}

      ${optionalString (cfg.defaultDatabase.enable) ''
        [[influxdb]]
          name = "default"
          enabled = true
          default = true
          urls = [ "${cfg.defaultDatabase.url}" ]
          username = "${cfg.defaultDatabase.username}"
          password = "${cfg.defaultDatabase.password}"
      ''}

      ${optionalString (cfg.alerta.enable) ''
        [alerta]
          enabled = true
          url = "${cfg.alerta.url}"
          token = "${cfg.alerta.token}"
          environment = "${cfg.alerta.environment}"
          origin = "${cfg.alerta.origin}"
      ''}

      ${cfg.extraConfig}
    '';
  };
in
{
  options.services.kapacitor = {
    enable = mkEnableOption "kapacitor";

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/kapacitor";
      description = lib.mdDoc "Location where Kapacitor stores its state";
    };

    port = mkOption {
      type = types.int;
      default = 9092;
      description = lib.mdDoc "Port of Kapacitor";
    };

    bind = mkOption {
      type = types.str;
      default = "";
      example = "0.0.0.0";
      description = lib.mdDoc "Address to bind to. The default is to bind to all addresses";
    };

    extraConfig = mkOption {
      description = lib.mdDoc "These lines go into kapacitord.conf verbatim.";
      default = "";
      type = types.lines;
    };

    user = mkOption {
      type = types.str;
      default = "kapacitor";
      description = lib.mdDoc "User account under which Kapacitor runs";
    };

    group = mkOption {
      type = types.str;
      default = "kapacitor";
      description = lib.mdDoc "Group under which Kapacitor runs";
    };

    taskSnapshotInterval = mkOption {
      type = types.str;
      description = lib.mdDoc "Specifies how often to snapshot the task state  (in InfluxDB time units)";
      default = "1m0s";
    };

    loadDirectory = mkOption {
      type = types.nullOr types.path;
      description = lib.mdDoc "Directory where to load services from, such as tasks, templates and handlers (or null to disable service loading on startup)";
      default = null;
    };

    defaultDatabase = {
      enable = mkEnableOption "kapacitor.defaultDatabase";

      url = mkOption {
        description = lib.mdDoc "The URL to an InfluxDB server that serves as the default database";
        example = "http://localhost:8086";
        type = types.str;
      };

      username = mkOption {
        description = lib.mdDoc "The username to connect to the remote InfluxDB server";
        type = types.str;
      };

      password = mkOption {
        description = lib.mdDoc "The password to connect to the remote InfluxDB server";
        type = types.str;
      };
    };

    alerta = {
      enable = mkEnableOption "kapacitor alerta integration";

      url = mkOption {
        description = lib.mdDoc "The URL to the Alerta REST API";
        default = "http://localhost:5000";
        type = types.str;
      };

      token = mkOption {
        description = lib.mdDoc "Default Alerta authentication token";
        type = types.str;
        default = "";
      };

      environment = mkOption {
        description = lib.mdDoc "Default Alerta environment";
        type = types.str;
        default = "Production";
      };

      origin = mkOption {
        description = lib.mdDoc "Default origin of alert";
        type = types.str;
        default = "kapacitor";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.kapacitor ];

    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' - ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.kapacitor = {
      description = "Kapacitor Real-Time Stream Processing Engine";
      wantedBy = [ "multi-user.target" ];
      after = [ "networking.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.kapacitor}/bin/kapacitord -config ${kapacitorConf}";
        User = "kapacitor";
        Group = "kapacitor";
      };
    };

    users.users.kapacitor = {
      uid = config.ids.uids.kapacitor;
      description = "Kapacitor user";
      home = cfg.dataDir;
    };

    users.groups.kapacitor = {
      gid = config.ids.gids.kapacitor;
    };
  };
}
