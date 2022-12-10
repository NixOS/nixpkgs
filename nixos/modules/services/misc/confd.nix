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
    enable = mkEnableOption (lib.mdDoc "confd service");

    backend = mkOption {
      description = lib.mdDoc "Confd config storage backend to use.";
      default = "etcd";
      type = types.enum ["etcd" "consul" "redis" "zookeeper"];
    };

    interval = mkOption {
      description = lib.mdDoc "Confd check interval.";
      default = 10;
      type = types.int;
    };

    nodes = mkOption {
      description = lib.mdDoc "Confd list of nodes to connect to.";
      default = [ "http://127.0.0.1:2379" ];
      type = types.listOf types.str;
    };

    watch = mkOption {
      description = lib.mdDoc "Confd, whether to watch etcd config for changes.";
      default = true;
      type = types.bool;
    };

    prefix = mkOption {
      description = lib.mdDoc "The string to prefix to keys.";
      default = "/";
      type = types.path;
    };

    logLevel = mkOption {
      description = lib.mdDoc "Confd log level.";
      default = "info";
      type = types.enum ["info" "debug"];
    };

    confDir = mkOption {
      description = lib.mdDoc "The path to the confd configs.";
      default = "/etc/confd";
      type = types.path;
    };

    package = mkOption {
      description = lib.mdDoc "Confd package to use.";
      default = pkgs.confd;
      defaultText = literalExpression "pkgs.confd";
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
