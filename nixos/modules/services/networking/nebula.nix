{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.nebula;
  nebulaDesc = "Nebula VPN service";

  format = pkgs.formats.yaml {};
  configFile = format.generate "nebula-config.yml" cfg.settings;

in
{
  # Interface

  options.services.nebula = {
    enable = mkEnableOption nebulaDesc;

    package = mkOption {
      type = types.package;
      default = pkgs.nebula;
      defaultText = "pkgs.nebula";
      description = "Nebula derivation to use.";
    };

    ca = mkOption {
      type = types.path;
      description = "Path to the certificate authority certificate.";
      example = "/etc/nebula/ca.crt";
    };

    cert = mkOption {
      type = types.path;
      description = "Path to the host certificate.";
      example = "/etc/nebula/host.crt";
    };

    key = mkOption {
      type = types.path;
      description = "Path to the host key.";
      example = "/etc/nebula/host.key";
    };

    staticHostMap = mkOption {
      type = types.attrsOf (types.listOf (types.str));
      default = {};
      description = ''
        The static host map defines a set of hosts with fixed IP addresses on the internet (or any network).
        A host can have multiple fixed IP addresses defined here, and nebula will try each when establishing a tunnel.
      '';
      example = literalExample ''
        { "192.168.100.1" = [ "100.64.22.11:4242" ]; }
      '';
    };

    isLighthouse = mkOption {
      type = types.bool;
      default = false;
      description = "Whether this node is a lighthouse.";
    };

    lighthouses = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        List of IPs of lighthouse hosts this node should report to and query from. This should be empty on lighthouse
        nodes. The IPs should be the lighthouse's Nebula IPs, not their external IPs.
      '';
      example = ''[ "192.168.100.1" ]'';
    };

    listen.host = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = "IP address to listen on.";
    };

    listen.port = mkOption {
      type = types.port;
      default = 4242;
      description = "Port number to listen on.";
    };

    punch = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Continues to punch inbound/outbound at a regular interval to avoid expiration of firewall nat mappings.
      '';
    };

    tun.disable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        When tun is disabled, a lighthouse can be started without a local tun interface (and therefore without root).
      '';
    };

    tun.device = mkOption {
      type = types.str;
      default = "nebula1";
      description = "Name of the tun device.";
    };

    firewall.outbound = mkOption {
      type = types.listOf types.attrs;
      default = [];
      description = "Firewall rules for outbound traffic.";
      example = ''[ { port = "any"; proto = "any"; host = "any"; } ]'';
    };

    firewall.inbound = mkOption {
      type = types.listOf types.attrs;
      default = [];
      description = "Firewall rules for inbound traffic.";
      example = ''[ { port = "any"; proto = "any"; host = "any"; } ]'';
    };

    settings = {
      type = format.type;
      default = {};
      description = ''
        Nebula configuration. Refer to
        <link xlink:href="https://github.com/slackhq/nebula/blob/master/examples/config.yml"/>
        for details on supported values.
      '';
      example = literalExample ''
        {
          lighthouse.dns = {
            host = "0.0.0.0";
            port = 53;
          };
        }
      '';
    };
  };

  # Implementation

  config =
    let
      # The service needs to launch as root to access the tun device, if it's enabled.
      serviceUser = if cfg.tun.disable then "nebula" else "root";
      serviceGroup = if cfg.tun.disable then "nebula" else "root";
    in mkIf cfg.enable {
      services.nebula.settings = {
        pki = {
          ca = cfg.ca;
          cert = cfg.cert;
          key = cfg.key;
        };
        static_host_map = cfg.staticHostMap;
        lighthouse = {
          am_lighthouse = cfg.isLighthouse;
          hosts = cfg.lighthouses;
        };
        listen = {
          host = cfg.listen.host;
          port = cfg.listen.port;
        };
        punchy = {
          punch = cfg.punch;
        };
        tun = {
          disabled = cfg.tun.disable;
          dev = cfg.tun.device;
        };
        firewall = {
          inbound = cfg.firewall.inbound;
          outbound = cfg.firewall.outbound;
        };
      };

      # Create systemd service for Nebula.
      systemd.services.nebula = {
        description = nebulaDesc;
        after = [ "network.target" ];
        before = [ "sshd.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "simple";
          Restart = "always";
          User = serviceUser;
          Group = serviceGroup;
          ExecStart = "${cfg.package}/bin/nebula -config ${configFile}";
        };
      };

      # Open the chosen port for UDP.
      networking.firewall.allowedUDPPorts = [ cfg.listen.port ];

      # Create the service user and its group.
      users.users."nebula" = {
        name = "nebula";
        group = "nebula";
        description = "Nebula service user";
        isSystemUser = true;
        packages = [ cfg.package ];
      };
      users.groups."nebula" = {};
    };
}
