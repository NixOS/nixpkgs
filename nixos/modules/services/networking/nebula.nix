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
        description = lib.mdDoc "Nebula network definitions.";
        default = {};
        type = types.attrsOf (types.submodule {
          options = {
            enable = mkOption {
              type = types.bool;
              default = true;
              description = lib.mdDoc "Enable or disable this network.";
            };

            package = mkOption {
              type = types.package;
              default = pkgs.nebula;
              defaultText = literalExpression "pkgs.nebula";
              description = lib.mdDoc "Nebula derivation to use.";
            };

            ca = mkOption {
              type = types.path;
              description = lib.mdDoc "Path to the certificate authority certificate.";
              example = "/etc/nebula/ca.crt";
            };

            cert = mkOption {
              type = types.path;
              description = lib.mdDoc "Path to the host certificate.";
              example = "/etc/nebula/host.crt";
            };

            key = mkOption {
              type = types.path;
              description = lib.mdDoc "Path to the host key.";
              example = "/etc/nebula/host.key";
            };

            staticHostMap = mkOption {
              type = types.attrsOf (types.listOf (types.str));
              default = {};
              description = lib.mdDoc ''
                The static host map defines a set of hosts with fixed IP addresses on the internet (or any network).
                A host can have multiple fixed IP addresses defined here, and nebula will try each when establishing a tunnel.
              '';
              example = { "192.168.100.1" = [ "100.64.22.11:4242" ]; };
            };

            isLighthouse = mkOption {
              type = types.bool;
              default = false;
              description = lib.mdDoc "Whether this node is a lighthouse.";
            };

            isRelay = mkOption {
              type = types.bool;
              default = false;
              description = lib.mdDoc "Whether this node is a relay.";
            };

            lighthouses = mkOption {
              type = types.listOf types.str;
              default = [];
              description = lib.mdDoc ''
                List of IPs of lighthouse hosts this node should report to and query from. This should be empty on lighthouse
                nodes. The IPs should be the lighthouse's Nebula IPs, not their external IPs.
              '';
              example = [ "192.168.100.1" ];
            };

            relays = mkOption {
              type = types.listOf types.str;
              default = [];
              description = lib.mdDoc ''
                List of IPs of relays that this node should allow traffic from.
              '';
              example = [ "192.168.100.1" ];
            };

            listen.host = mkOption {
              type = types.str;
              default = "0.0.0.0";
              description = lib.mdDoc "IP address to listen on.";
            };

            listen.port = mkOption {
              type = types.port;
              default = 4242;
              description = lib.mdDoc "Port number to listen on.";
            };

            tun.disable = mkOption {
              type = types.bool;
              default = false;
              description = lib.mdDoc ''
                When tun is disabled, a lighthouse can be started without a local tun interface (and therefore without root).
              '';
            };

            tun.device = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = lib.mdDoc "Name of the tun device. Defaults to nebula.\${networkName}.";
            };

            firewall.outbound = mkOption {
              type = types.listOf types.attrs;
              default = [];
              description = lib.mdDoc "Firewall rules for outbound traffic.";
              example = [ { port = "any"; proto = "any"; host = "any"; } ];
            };

            firewall.inbound = mkOption {
              type = types.listOf types.attrs;
              default = [];
              description = lib.mdDoc "Firewall rules for inbound traffic.";
              example = [ { port = "any"; proto = "any"; host = "any"; } ];
            };

            settings = mkOption {
              type = format.type;
              default = {};
              description = lib.mdDoc ''
                Nebula configuration. Refer to
                <https://github.com/slackhq/nebula/blob/master/examples/config.yml>
                for details on supported values.
              '';
              example = literalExpression ''
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
          relay = {
            am_relay = netCfg.isRelay;
            relays = netCfg.relays;
            use_relays = true;
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
          # Create the systemd service for Nebula.
          "nebula@${netName}" = {
            description = "Nebula VPN service for ${netName}";
            wants = [ "basic.target" ];
            after = [ "basic.target" "network.target" ];
            before = [ "sshd.service" ];
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              Type = "simple";
              Restart = "always";
              ExecStart = "${netCfg.package}/bin/nebula -config ${configFile}";
              UMask = "0027";
              CapabilityBoundingSet = "CAP_NET_ADMIN";
              AmbientCapabilities = "CAP_NET_ADMIN";
              LockPersonality = true;
              NoNewPrivileges = true;
              PrivateDevices = false; # needs access to /dev/net/tun (below)
              DeviceAllow = "/dev/net/tun rw";
              DevicePolicy = "closed";
              PrivateTmp = true;
              PrivateUsers = false; # CapabilityBoundingSet needs to apply to the host namespace
              ProtectClock = true;
              ProtectControlGroups = true;
              ProtectHome = true;
              ProtectHostname = true;
              ProtectKernelLogs = true;
              ProtectKernelModules = true;
              ProtectKernelTunables = true;
              ProtectProc = "invisible";
              ProtectSystem = "strict";
              RestrictNamespaces = true;
              RestrictSUIDSGID = true;
              User = networkId;
              Group = networkId;
            };
            unitConfig.StartLimitIntervalSec = 0; # ensure Restart=always is always honoured (networks can go down for arbitrarily long)
          };
        }) enabledNetworks);

    # Open the chosen ports for UDP.
    networking.firewall.allowedUDPPorts =
      unique (mapAttrsToList (netName: netCfg: netCfg.listen.port) enabledNetworks);

    # Create the service users and groups.
    users.users = mkMerge (mapAttrsToList (netName: netCfg:
      {
        ${nameToId netName} = {
          group = nameToId netName;
          description = "Nebula service user for network ${netName}";
          isSystemUser = true;
        };
      }) enabledNetworks);

    users.groups = mkMerge (mapAttrsToList (netName: netCfg: {
      ${nameToId netName} = {};
    }) enabledNetworks);
  };
}
