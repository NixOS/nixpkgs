{ config, pkgs, lib, ... }:
let
  cfg = config.services.confd;

  confdConfig = ''
    backend = "${cfg.backend}"
    confdir = "${cfg.confDir}"
    interval = ${toString cfg.interval}
    nodes = [ ${lib.concatMapStringsSep "," (s: ''"${s}"'') cfg.nodes}, ]
    prefix = "${cfg.prefix}"
    log-level = "${cfg.logLevel}"
    watch = ${lib.boolToString cfg.watch}
  '';

in {
  options.services.confd = {
    enable = lib.mkEnableOption "confd, a service to manage local application configuration files using templates and data from etcd/consul/redis/zookeeper";

    backend = lib.mkOption {
      description = "Confd config storage backend to use.";
      default = "etcd";
      type = lib.types.enum ["etcd" "consul" "redis" "zookeeper"];
    };

    interval = lib.mkOption {
      description = "Confd check interval.";
      default = 10;
      type = lib.types.int;
    };

    nodes = lib.mkOption {
      description = "Confd list of nodes to connect to.";
      default = [ "http://127.0.0.1:2379" ];
      type = lib.types.listOf lib.types.str;
    };

    watch = lib.mkOption {
      description = "Confd, whether to watch etcd config for changes.";
      default = true;
      type = lib.types.bool;
    };

    prefix = lib.mkOption {
      description = "The string to prefix to keys.";
      default = "/";
      type = lib.types.path;
    };

    logLevel = lib.mkOption {
      description = "Confd log level.";
      default = "info";
      type = lib.types.enum ["info" "debug"];
    };

    confDir = lib.mkOption {
      description = "The path to the confd configs.";
      default = "/etc/confd";
      type = lib.types.path;
    };

    package = lib.mkPackageOption pkgs "confd" { };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.confd = {
      description = "Confd Service.";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/confd";
      };
    };

    environment.etc = {
      "confd/confd.toml".text = confdConfig;
    };

    environment.systemPackages = [ cfg.package ];

    services.etcd.enable = lib.mkIf (cfg.backend == "etcd") (lib.mkDefault true);
  };
}
