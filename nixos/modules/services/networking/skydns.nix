{ config, pkgs, lib, ... }:

let
  cfg = config.services.skydns;

in {
  options.services.skydns = {
    enable = lib.mkEnableOption "skydns service";

    etcd = {
      machines = lib.mkOption {
        default = [ "http://127.0.0.1:2379" ];
        type = lib.types.listOf lib.types.str;
        description = "Skydns list of etcd endpoints to connect to.";
      };

      tlsKey = lib.mkOption {
        default = null;
        type = lib.types.nullOr lib.types.path;
        description = "Skydns path of TLS client certificate - private key.";
      };

      tlsPem = lib.mkOption {
        default = null;
        type = lib.types.nullOr lib.types.path;
        description = "Skydns path of TLS client certificate - public key.";
      };

      caCert = lib.mkOption {
        default = null;
        type = lib.types.nullOr lib.types.path;
        description = "Skydns path of TLS certificate authority public key.";
      };
    };

    address = lib.mkOption {
      default = "0.0.0.0:53";
      type = lib.types.str;
      description = "Skydns address to bind to.";
    };

    domain = lib.mkOption {
      default = "skydns.local.";
      type = lib.types.str;
      description = "Skydns default domain if not specified by etcd config.";
    };

    nameservers = lib.mkOption {
      default = map (n: n + ":53") config.networking.nameservers;
      defaultText = lib.literalExpression ''map (n: n + ":53") config.networking.nameservers'';
      type = lib.types.listOf lib.types.str;
      description = "Skydns list of nameservers to forward DNS requests to when not authoritative for a domain.";
      example = ["8.8.8.8:53" "8.8.4.4:53"];
    };

    package = lib.mkPackageOption pkgs "skydns" { };

    extraConfig = lib.mkOption {
      default = {};
      type = lib.types.attrsOf lib.types.str;
      description = "Skydns attribute set of extra config options passed as environment variables.";
    };
  };

  config = lib.mkIf (cfg.enable) {
    systemd.services.skydns = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "etcd.service" ];
      description = "Skydns Service";
      environment = {
        ETCD_MACHINES = lib.concatStringsSep "," cfg.etcd.machines;
        ETCD_TLSKEY = cfg.etcd.tlsKey;
        ETCD_TLSPEM = cfg.etcd.tlsPem;
        ETCD_CACERT = cfg.etcd.caCert;
        SKYDNS_ADDR = cfg.address;
        SKYDNS_DOMAIN = cfg.domain;
        SKYDNS_NAMESERVERS = lib.concatStringsSep "," cfg.nameservers;
      };
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/skydns";
      };
    };

    environment.systemPackages = [ cfg.package ];
  };
}
