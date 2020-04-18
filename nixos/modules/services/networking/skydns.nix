{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.skydns;

in {
  options.services.skydns = {
    enable = mkEnableOption "skydns service";

    etcd = {
      machines = mkOption {
        default = [ "http://127.0.0.1:2379" ];
        type = types.listOf types.str;
        description = "Skydns list of etcd endpoints to connect to.";
      };

      tlsKey = mkOption {
        default = null;
        type = types.nullOr types.path;
        description = "Skydns path of TLS client certificate - private key.";
      };

      tlsPem = mkOption {
        default = null;
        type = types.nullOr types.path;
        description = "Skydns path of TLS client certificate - public key.";
      };

      caCert = mkOption {
        default = null;
        type = types.nullOr types.path;
        description = "Skydns path of TLS certificate authority public key.";
      };
    };

    address = mkOption {
      default = "0.0.0.0:53";
      type = types.str;
      description = "Skydns address to bind to.";
    };

    domain = mkOption {
      default = "skydns.local.";
      type = types.str;
      description = "Skydns default domain if not specified by etcd config.";
    };

    nameservers = mkOption {
      default = map (n: n + ":53") config.networking.nameservers;
      type = types.listOf types.str;
      description = "Skydns list of nameservers to forward DNS requests to when not authoritative for a domain.";
      example = ["8.8.8.8:53" "8.8.4.4:53"];
    };

    package = mkOption {
      default = pkgs.skydns;
      defaultText = "pkgs.skydns";
      type = types.package;
      description = "Skydns package to use.";
    };

    extraConfig = mkOption {
      default = {};
      type = types.attrsOf types.str;
      description = "Skydns attribute set of extra config options passed as environemnt variables.";
    };
  };

  config = mkIf (cfg.enable) {
    systemd.services.skydns = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "etcd.service" ];
      description = "Skydns Service";
      environment = {
        ETCD_MACHINES = concatStringsSep "," cfg.etcd.machines;
        ETCD_TLSKEY = cfg.etcd.tlsKey;
        ETCD_TLSPEM = cfg.etcd.tlsPem;
        ETCD_CACERT = cfg.etcd.caCert;
        SKYDNS_ADDR = cfg.address;
        SKYDNS_DOMAIN = cfg.domain;
        SKYDNS_NAMESERVERS = concatStringsSep "," cfg.nameservers;
      };
      serviceConfig = {
        ExecStart = "${cfg.package.bin}/bin/skydns";
      };
    };

    environment.systemPackages = [ cfg.package ];
  };
}
