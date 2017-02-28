{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.glances;

  mkFlag = cfg: flagname: (mkNamedFlag cfg flagname flagname);

  mkNamedFlag = cfg: flagname: destname:
    let
      flg = cfg."${flagname}";
    in
    if (isBool flg && flg == true) || (!isBool flg && !isNull flg) then
      " --${destname}" +
      (
        if !isBool flg then " ${toString flg}"
        else ""
      )
    else
      "";

  mkConfig = cfg:
    pkgs.writeTextFile {
      name = "glances.conf";
      text =
        if !(isNull cfg.confFile) then builtins.readFile cfg.confFile
        else cfg.conf;
    };

  # Building the commandline flags for glances here
  glancesCommands = ""
    + "--config ${mkConfig cfg}"
    + "${mkNamedFlag cfg "listenAddress" "bind"}"
    + "${mkFlag cfg "port"}"
    + "${mkFlag cfg "username"}"
    + "${mkFlag cfg "password"}"
    + "${mkFlag cfg "disable-alert"}"
    + "${mkFlag cfg "disable-amps"}"
    + "${mkFlag cfg "disable-cpu"}"
    + "${mkFlag cfg "disable-diskio"}"
    + "${mkFlag cfg "disable-docker"}"
    + "${mkFlag cfg "disable-folders"}"
    + "${mkFlag cfg "disable-fs"}"
    + "${mkFlag cfg "disable-hddtemp"}"
    + "${mkFlag cfg "disable-ip"}"
    + "${mkFlag cfg "disable-irq"}"
    + "${mkFlag cfg "disable-load"}"
    + "${mkFlag cfg "disable-mem"}"
    + "${mkFlag cfg "disable-memswap"}"
    + "${mkFlag cfg "disable-network"}"
    + "${mkFlag cfg "disable-now"}"
    + "${mkFlag cfg "disable-ports"}"
    + "${mkFlag cfg "disable-process"}"
    + "${mkFlag cfg "disable-raid"}"
    + "${mkFlag cfg "disable-sensors"}"
    + "${mkFlag cfg "disable-wifi"}"
    + "${mkFlag cfg "disable-irix"}"
    + "${mkFlag cfg "percpu"}"
    + "${mkFlag cfg "disable-left-sidebar"}"
    + "${mkFlag cfg "disable-quicklook"}"
    + "${mkFlag cfg "full-quicklook"}"
    + "${mkFlag cfg "disable-top"}"
    + "${mkFlag cfg "meangpu"}"
    + "${mkFlag cfg "enable-history"}"
    + "${mkFlag cfg "disable-bold"}"
    + "${mkFlag cfg "disable-bg"}"
    + "${mkFlag cfg "enable-process-extended"}"
    + "${mkFlag cfg "export-cassandra"}"
    + "${mkFlag cfg "export-couchdb"}"
    + "${mkFlag cfg "export-elasticsearch"}"
    + "${mkFlag cfg "export-influxdb"}"
    + "${mkFlag cfg "export-opentsdb"}"
    + "${mkFlag cfg "export-rabbitmq"}"
    + "${mkFlag cfg "export-statsd"}"
    + "${mkFlag cfg "export-riemann"}"
    + "${mkFlag cfg "export-zeromq"}"
    + "${mkFlag cfg "disable-autodiscover"}"
    + "${mkFlag cfg "time"}"
    + "${mkFlag cfg "cached-time"}"
    + "${mkFlag cfg "process-filter"}"
    + "${mkFlag cfg "process-short-name"}"
    + "${mkFlag cfg "hide-kernel-threads"}"
    + "${mkFlag cfg "tree"}"
    + "${mkFlag cfg "byte"}"
    + "${mkFlag cfg "diskio-show-ramfs"}"
    + "${mkFlag cfg "diskio-iops"}"
    + "${mkFlag cfg "fahrenheit"}"
    + "${mkFlag cfg "fs-free-space"}"
    + "${mkFlag cfg "disable-check-update"}"
    ;
in

{

  ###### interface

  options = {

    services.glances = {

      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to enable the glances server service.
        '';
      };

      listenAddress = mkOption {
        type = types.str;
        default = "";
        example = "0.0.0.0";
        description = "bind server to the given IPv4/IPv6 address or hostname";
      };

      port = mkOption {
        type = types.int;
        default = 61209;
        description = "Port to listen on.";
      };

      username = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Username";
      };

      password = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Password";
      };

      conf = mkOption {
        type = types.str;
        default = "";
        description = "Extra configuration";
      };

      confFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Configuration file. Overrides 'conf' option if set.";
      };

      disable-alert = mkOption {
        type = types.bool;
        default = false;
        description = "disable alert/log module";
      };

      disable-amps = mkOption {
        type = types.bool;
        default = false;
        description = "disable application monitoring process module";
      };

      disable-cpu = mkOption {
        type = types.bool;
        default = false;
        description = "disable CPU module";
      };

      disable-diskio = mkOption {
        type = types.bool;
        default = false;
        description = "disable disk I/O module";
      };

      disable-docker = mkOption {
        type = types.bool;
        default = false;
        description = "disable Docker module";
      };

      disable-folders = mkOption {
        type = types.bool;
        default = false;
        description = "disable folders module";
      };

      disable-fs = mkOption {
        type = types.bool;
        default = false;
        description = "disable file system module";
      };

      disable-hddtemp = mkOption {
        type = types.bool;
        default = false;
        description = "disable HD temperature module";
      };

      disable-ip = mkOption {
        type = types.bool;
        default = false;
        description = "disable IP module";
      };

      disable-irq = mkOption {
        type = types.bool;
        default = false;
        description = "disable IRQ module";
      };

      disable-load = mkOption {
        type = types.bool;
        default = false;
        description = "disable load module";
      };

      disable-mem = mkOption {
        type = types.bool;
        default = false;
        description = "disable memory module";
      };

      disable-memswap = mkOption {
        type = types.bool;
        default = false;
        description = "disable memory swap module";
      };

      disable-network = mkOption {
        type = types.bool;
        default = false;
        description = "disable network module";
      };

      disable-now = mkOption {
        type = types.bool;
        default = false;
        description = "disable current time module";
      };

      disable-ports = mkOption {
        type = types.bool;
        default = false;
        description = "disable Ports module";
      };

      disable-process = mkOption {
        type = types.bool;
        default = false;
        description = "disable process module";
      };

      disable-raid = mkOption {
        type = types.bool;
        default = false;
        description = "disable RAID module";
      };

      disable-sensors = mkOption {
        type = types.bool;
        default = false;
        description = "disable sensors module";
      };

      disable-wifi = mkOption {
        type = types.bool;
        default = false;
        description = "disable Wifi module";
      };

      disable-irix = mkOption {
        type = types.bool;
        description = "task's CPU usage will be divided by the total number of CPUs";
        default = false;
      };

      percpu = mkOption {
        type = types.bool;
        default = false;
        description = "start Glances in per CPU mode";
      };

      disable-left-sidebar = mkOption {
        type = types.bool;
        description = "disable network, disk I/O, FS and sensors modules (py3sensors lib needed)";
        default = false;
      };

      disable-quicklook = mkOption {
        type = types.bool;
        default = false;
        description = "disable quick look module";
      };

      full-quicklook = mkOption {
        type = types.bool;
        default = false;
        description = "disable all but quick look and load";
      };

      disable-top = mkOption {
        type = types.bool;
        default = false;
        description = "disable top menu (QuickLook, CPU, MEM, SWAP and LOAD)";
      };

      meangpu = mkOption {
        type = types.bool;
        default = false;
        description = "start Glances in mean GPU mode";
      };

      enable-history = mkOption {
        type = types.bool;
        default = false;
        description = "enable the history mode (matplotlib lib needed)";
      };

      disable-bold = mkOption {
        type = types.bool;
        default = false;
        description = "disable bold mode in the terminal";
      };

      disable-bg = mkOption {
        type = types.bool;
        default = false;
        description = "disable background colors in the terminal";
      };

      enable-process-extended = mkOption {
        type = types.bool;
        default = false;
        description = "enable extended stats on top process";
      };

      export-cassandra = mkOption {
        type = types.bool;
        description = "export stats to a Cassandra/Scylla server (cassandra lib needed)";
        default = false;
      };

      export-couchdb = mkOption {
        type = types.bool;
        default = false;
        description = "export stats to a CouchDB server (couchdb lib needed)";
      };

      export-elasticsearch = mkOption {
        type = types.bool;
        description = "export stats to an Elasticsearch server (elasticsearch lib needed)";
        default = false;
      };

      export-influxdb = mkOption {
        type = types.bool;
        description = "export stats to an InfluxDB server (influxdb lib needed)";
        default = false;
      };

      export-opentsdb = mkOption {
        type = types.bool;
        default = false;
        description = "export stats to an OpenTSDB server (potsdb lib needed)";
      };

      export-rabbitmq = mkOption {
        type = types.bool;
        default = false;
        description = "export stats to RabbitMQ broker (pika lib needed)";
      };

      export-statsd = mkOption {
        type = types.bool;
        default = false;
        description = "export stats to a StatsD server (statsd lib needed)";
      };

      export-riemann = mkOption {
        type = types.bool;
        default = false;
        description = "export stats to Riemann server (bernhard lib needed)";
      };

      export-zeromq = mkOption {
        type = types.bool;
        default = false;
        description = "export stats to a ZeroMQ server (zmq lib needed)";
      };

      disable-autodiscover = mkOption {
        type = types.bool;
        default = false;
        description = "disable autodiscover feature";
      };

      time = mkOption {
        type = types.int;
        default = 3;
        description = "set refresh time in seconds [default: 3 sec]";
      };

      cached-time = mkOption {
        type = types.int;
        default = 1;
        description = "set the server cache time [default: 1 sec]";
      };

      process-filter = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "set the process filter pattern (regular expression).";
      };

      process-short-name = mkOption {
        type = types.bool;
        default = false;
        description = "force short name for processes name";
      };

      hide-kernel-threads = mkOption {
        type = types.bool;
        default = false;
        description = "hide kernel threads in process list";
      };

      tree = mkOption {
        type = types.bool;
        default = false;
        description = "display processes as a tree";
      };

      byte = mkOption {
        type = types.bool;
        default = false;
        description = "display network rate in byte per second";
      };

      diskio-show-ramfs = mkOption {
        type = types.bool;
        default = false;
        description = "show RAM FS in the DiskIO plugin";
      };

      diskio-iops = mkOption {
        type = types.bool;
        default = false;
        description = "show I/O per second in the DiskIO plugin";
      };

      fahrenheit = mkOption {
        type = types.bool;
        default = false;
        description = "display temperature in Fahrenheit (default is Celsius)";
      };

      fs-free-space = mkOption {
        type = types.bool;
        default = false;
        description = "display FS free space instead of used";
      };

      disable-check-update = mkOption {
        type = types.bool;
        default = false;
        description = "disable online Glances version ckeck";
      };

    };

  };

  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.pythonPackages.glances ];

    systemd.services.glances = {
      description = "Glances monitoring service";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.pythonPackages.glances}/bin/glances --server ${glancesCommands}";
      };
      unitConfig.Documentation = "man:glances(1)";
    };

  };

}

