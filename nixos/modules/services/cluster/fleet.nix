{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.fleet;

in {

  ##### Interface
  options.services.fleet = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable fleet service.
      '';
    };

    listen = mkOption {
      type = types.listOf types.str;
      default = [ "/var/run/fleet.sock" ];
      example = [ "/var/run/fleet.sock" "127.0.0.1:49153" ];
      description = ''
        Fleet listening addresses.
      '';
    };

    etcdServers = mkOption {
      type = types.listOf types.str;
      default = [ "http://127.0.0.1:2379" ];
      description = ''
        Fleet list of etcd endpoints to use.
      '';
    };

    publicIp = mkOption {
      type = types.nullOr types.str;
      default = "";
      description = ''
        Fleet IP address that should be published with the local Machine's
        state and any socket information. If not set, fleetd will attempt
        to detect the IP it should publish based on the machine's IP
        routing information.
      '';
    };

    etcdCafile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Fleet TLS ca file when SSL certificate authentication is enabled
        in etcd endpoints.
      '';
    };

    etcdKeyfile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Fleet TLS key file when SSL certificate authentication is enabled
        in etcd endpoints.
      '';
    };

    etcdCertfile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Fleet TLS cert file when SSL certificate authentication is enabled
        in etcd endpoints.
      '';
    };

    metadata = mkOption {
      type = types.attrsOf types.str;
      default = {};
      apply = attrs: concatMapStringsSep "," (n: "${n}=${attrs."${n}"}") (attrNames attrs);
      example = literalExample ''
        {
          region = "us-west";
          az = "us-west-1";
        }
      '';
      description = ''
        Key/value pairs that are published with the local to the fleet registry.
        This data can be used directly by a client of fleet to make scheduling decisions.
      '';
    };

    extraConfig = mkOption {
      type = types.attrsOf types.str;
      apply = mapAttrs' (n: v: nameValuePair ("FLEET_" + n) v);
      default = {};
      example = literalExample ''
        {
          VERBOSITY = 1;
          ETCD_REQUEST_TIMEOUT = "2.0";
          AGENT_TTL = "40s";
        }
      '';
      description = ''
        Fleet extra config. See
        <link xlink:href="https://github.com/coreos/fleet/blob/master/Documentation/deployment-and-configuration.md"/>
        for configuration options.
      '';
    };

  };

  ##### Implementation
  config = mkIf cfg.enable {
    systemd.services.fleet = {
      description = "Fleet Init System Daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "fleet.socket" "etcd.service" "docker.service" ];
      requires = [ "fleet.socket" ];
      environment = {
        FLEET_ETCD_SERVERS = concatStringsSep "," cfg.etcdServers;
        FLEET_PUBLIC_IP = cfg.publicIp;
        FLEET_ETCD_CAFILE = cfg.etcdCafile;
        FLEET_ETCD_KEYFILE = cfg.etcdKeyfile;
        FLEET_ETCD_CERTFILE = cfg.etcdCertfile;
        FLEET_METADATA = cfg.metadata;
      } // cfg.extraConfig;
      serviceConfig = {
        ExecStart = "${pkgs.fleet}/bin/fleetd";
        Group = "fleet";
      };
    };

    systemd.sockets.fleet = {
      description = "Fleet Socket for the API";
      wantedBy = [ "sockets.target" ];
      listenStreams = cfg.listen;
      socketConfig = {
        ListenStream = "/var/run/fleet.sock";
        SocketMode = "0660";
        SocketUser = "root";
        SocketGroup = "fleet";
      };
    };

    services.etcd.enable = mkDefault true;
    virtualisation.docker.enable = mkDefault true;

    environment.systemPackages = [ pkgs.fleet ];
    users.extraGroups.fleet.gid = config.ids.gids.fleet;
  };
}
