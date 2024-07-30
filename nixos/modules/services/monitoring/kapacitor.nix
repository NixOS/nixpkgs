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
      description = "Location where Kapacitor stores its state";
    };

    port = mkOption {
      type = types.port;
      default = 9092;
      description = "Port of Kapacitor";
    };

    bind = mkOption {
      type = types.str;
      default = "";
      example = "0.0.0.0";
      description = "Address to bind to. The default is to bind to all addresses";
    };

    extraConfig = mkOption {
      description = "These lines go into kapacitord.conf verbatim.";
      default = "";
      type = types.lines;
    };

    user = mkOption {
      type = types.str;
      default = "kapacitor";
      description = "User account under which Kapacitor runs";
    };

    group = mkOption {
      type = types.str;
      default = "kapacitor";
      description = "Group under which Kapacitor runs";
    };

    taskSnapshotInterval = mkOption {
      type = types.str;
      description = "Specifies how often to snapshot the task state  (in InfluxDB time units)";
      default = "1m0s";
    };

    loadDirectory = mkOption {
      type = types.nullOr types.path;
      description = "Directory where to load services from, such as tasks, templates and handlers (or null to disable service loading on startup)";
      default = null;
    };

    defaultDatabase = {
      enable = mkEnableOption "kapacitor.defaultDatabase";

      url = mkOption {
        description = "The URL to an InfluxDB server that serves as the default database";
        example = "http://localhost:8086";
        type = types.str;
      };

      username = mkOption {
        description = "The username to connect to the remote InfluxDB server";
        type = types.str;
      };

      password = mkOption {
        description = "The password to connect to the remote InfluxDB server";
        type = types.str;
      };
    };

    alerta = {
      enable = mkEnableOption "kapacitor alerta integration";

      url = mkOption {
        description = "The URL to the Alerta REST API";
        default = "http://localhost:5000";
        type = types.str;
      };

      token = mkOption {
        description = "Default Alerta authentication token";
        type = types.str;
        default = "";
      };

      environment = mkOption {
        description = "Default Alerta environment";
        type = types.str;
        default = "Production";
      };

      origin = mkOption {
        description = "Default origin of alert";
        type = types.str;
        default = "kapacitor";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.kapacitor ];

    systemd.tmpfiles.settings."10-kapacitor".${cfg.dataDir}.d = {
      inherit (cfg) user group;
    };

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
