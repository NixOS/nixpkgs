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
    watch = ${if cfg.watch then "true" else "false"}
  '';

in {
  options.services.confd = {
    enable = mkEnableOption' {
      name = "confd service";
      package = literalPackage pkgs "pkgs.confd";
    };

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
      default = [ "http://127.0.0.1:4001" ];
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

    package = mkOption {
      description = "Confd package to use.";
      default = pkgs.confd;
      defaultText = "pkgs.confd";
      type = types.package;
    };
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
