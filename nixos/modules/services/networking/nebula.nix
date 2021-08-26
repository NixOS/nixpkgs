{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.nebula;
  enabledNetworks = filterAttrs (n: v: v.enable) cfg.networks;

  format = pkgs.formats.yaml {};

  nameToId = netName: "nebula-${netName}";
in
{
  # Interface

  options = {
    services.nebula = {
      networks = mkOption {
        description = "Nebula network definitions.";
        default = {};
        type = types.attrsOf (types.submodule {
          options = {
            enable = mkOption {
              type = types.bool;
              default = true;
              description = "Enable or disable this network.";
            };

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

            tun.disable = mkOption {
              type = types.bool;
              default = false;
              description = ''
                When tun is disabled, a lighthouse can be started without a local tun interface (and therefore without root).
              '';
            };

            tun.device = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "Name of the tun device. Defaults to nebula.\${networkName}.";
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

            settings = mkOption {
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
        });
      };
    };
  };

  # Implementation
  config = mkIf (enabledNetworks != {}) {
    systemd.services = mkMerge (mapAttrsToList (netName: netCfg:
      let
        networkId = nameToId netName;
        settings = recursiveUpdate {
          pki = {
            ca = netCfg.ca;
            cert = netCfg.cert;
            key = netCfg.key;
          };
          static_host_map = netCfg.staticHostMap;
          lighthouse = {
            am_lighthouse = netCfg.isLighthouse;
            hosts = netCfg.lighthouses;
          };
          listen = {
            host = netCfg.listen.host;
            port = netCfg.listen.port;
          };
          tun = {
            disabled = netCfg.tun.disable;
            dev = if (netCfg.tun.device != null) then netCfg.tun.device else "nebula.${netName}";
          };
          firewall = {
            inbound = netCfg.firewall.inbound;
            outbound = netCfg.firewall.outbound;
          };
        } netCfg.settings;
        configFile = format.generate "nebula-config-${netName}.yml" settings;
        in
        {
          # Create systemd service for Nebula.
          "nebula@${netName}" = {
            description = "Nebula VPN service for ${netName}";
            wants = [ "basic.target" ];
            after = [ "basic.target" "network.target" ];
            before = [ "sshd.service" ];
            wantedBy = [ "multi-user.target" ];
            serviceConfig = mkMerge [
              {
                Type = "simple";
                Restart = "always";
                ExecStart = "${netCfg.package}/bin/nebula -config ${configFile}";
              }
              # The service needs to launch as root to access the tun device, if it's enabled.
              (mkIf netCfg.tun.disable {
                User = networkId;
                Group = networkId;
              })
            ];
          };
        }) enabledNetworks);

    # Open the chosen ports for UDP.
    networking.firewall.allowedUDPPorts =
      unique (mapAttrsToList (netName: netCfg: netCfg.listen.port) enabledNetworks);

    # Create the service users and groups.
    users.users = mkMerge (mapAttrsToList (netName: netCfg:
      mkIf netCfg.tun.disable {
        ${nameToId netName} = {
          group = nameToId netName;
          description = "Nebula service user for network ${netName}";
          isSystemUser = true;
        };
      }) enabledNetworks);

    users.groups = mkMerge (mapAttrsToList (netName: netCfg:
      mkIf netCfg.tun.disable {
        ${nameToId netName} = {};
      }) enabledNetworks);
  };
}
