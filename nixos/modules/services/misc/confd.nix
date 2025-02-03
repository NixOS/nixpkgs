{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.confd;

  confdConfig = ''
    backend = "${cfg.backend}"
    confdir = "${cfg.confDir}"
    interval = ${toString cfg.interval}
    nodes = [ ${concatMapStringsSep "," (s: ''"${s}"'') cfg.nodes}, ]
    prefix = "${cfg.prefix}"
    log-level = "${cfg.logLevel}"
    watch = ${boolToString cfg.watch}
  '';

in {
  options.services.confd = {
    enable = mkEnableOption "confd, a service to manage local application configuration files using templates and data from etcd/consul/redis/zookeeper";

    backend = mkOption {
      description = "Confd config storage backend to use.";
      default = "etcd";
      type = types.enum ["etcd" "consul" "redis" "zookeeper"];
    };

    interval = mkOption {
      description = "Confd check interval.";
      default = 10;
      type = types.int;
    };

    nodes = mkOption {
      description = "Confd list of nodes to connect to.";
      default = [ "http://127.0.0.1:2379" ];
      type = types.listOf types.str;
    };

    watch = mkOption {
      description = "Confd, whether to watch etcd config for changes.";
      default = true;
      type = types.bool;
    };

    prefix = mkOption {
      description = "The string to prefix to keys.";
      default = "/";
      type = types.path;
    };

    logLevel = mkOption {
      description = "Confd log level.";
      default = "info";
      type = types.enum ["info" "debug"];
    };

    confDir = mkOption {
      description = "The path to the confd configs.";
      default = "/etc/confd";
      type = types.path;
    };

    package = mkPackageOption pkgs "confd" { };
  };

  config = mkIf cfg.enable {
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

    services.etcd.enable = mkIf (cfg.backend == "etcd") (mkDefault true);
  };
}
