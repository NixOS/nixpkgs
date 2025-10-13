{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.nebula;
  enabledNetworks = lib.filterAttrs (n: v: v.enable) cfg.networks;

  format = pkgs.formats.yaml { };

  nameToId = netName: "nebula-${netName}";

  resolveFinalPort =
    netCfg:
    if netCfg.listen.port == null then
      if (netCfg.isLighthouse || netCfg.isRelay) then 4242 else 0
    else
      netCfg.listen.port;
in
{
  # Interface

  options = {
    services.nebula = {
      networks = lib.mkOption {
        description = "Nebula network definitions.";
        default = { };
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              enable = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = "Enable or disable this network.";
              };

              package = lib.mkPackageOption pkgs "nebula" { };

              ca = lib.mkOption {
                type = lib.types.path;
                description = "Path to the certificate authority certificate.";
                example = "/etc/nebula/ca.crt";
              };

              cert = lib.mkOption {
                type = lib.types.path;
                description = "Path to the host certificate.";
                example = "/etc/nebula/host.crt";
              };

              key = lib.mkOption {
                type = lib.types.oneOf [
                  lib.types.nonEmptyStr
                  lib.types.path
                ];
                description = "Path or reference to the host key.";
                example = "/etc/nebula/host.key";
              };

              staticHostMap = lib.mkOption {
                type = lib.types.attrsOf (lib.types.listOf (lib.types.str));
                default = { };
                description = ''
                  The static host map defines a set of hosts with fixed IP addresses on the internet (or any network).
                  A host can have multiple fixed IP addresses defined here, and nebula will try each when establishing a tunnel.
                '';
                example = {
                  "192.168.100.1" = [ "100.64.22.11:4242" ];
                };
              };

              isLighthouse = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Whether this node is a lighthouse.";
              };

              isRelay = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Whether this node is a relay.";
              };

              lighthouse.dns.enable = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Whether this lighthouse node should serve DNS.";
              };

              lighthouse.dns.host = lib.mkOption {
                type = lib.types.str;
                default = "localhost";
                description = ''
                  IP address on which nebula lighthouse should serve DNS.
                  'localhost' is a good default to ensure the service does not listen on public interfaces;
                  use a Nebula address like 10.0.0.5 to make DNS resolution available to nebula hosts only.
                '';
              };

              lighthouse.dns.port = lib.mkOption {
                type = lib.types.nullOr lib.types.port;
                default = 5353;
                description = "UDP port number for lighthouse DNS server.";
              };

              lighthouses = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
                description = ''
                  List of IPs of lighthouse hosts this node should report to and query from. This should be empty on lighthouse
                  nodes. The IPs should be the lighthouse's Nebula IPs, not their external IPs.
                '';
                example = [ "192.168.100.1" ];
              };

              relays = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
                description = ''
                  List of IPs of relays that this node should allow traffic from.
                '';
                example = [ "192.168.100.1" ];
              };

              listen.host = lib.mkOption {
                type = lib.types.str;
                default = "0.0.0.0";
                description = "IP address to listen on.";
              };

              listen.port = lib.mkOption {
                type = lib.types.nullOr lib.types.port;
                default = null;
                defaultText = lib.literalExpression ''
                  if (config.services.nebula.networks.''${name}.isLighthouse ||
                      config.services.nebula.networks.''${name}.isRelay) then
                    4242
                  else
                    0;
                '';
                description = "Port number to listen on.";
              };

              tun.disable = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = ''
                  When tun is disabled, a lighthouse can be started without a local tun interface (and therefore without root).
                '';
              };

              tun.device = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = "Name of the tun device. Defaults to nebula.\${networkName}.";
              };

              firewall.outbound = lib.mkOption {
                type = lib.types.listOf lib.types.attrs;
                default = [ ];
                description = "Firewall rules for outbound traffic.";
                example = [
                  {
                    port = "any";
                    proto = "any";
                    host = "any";
                  }
                ];
              };

              firewall.inbound = lib.mkOption {
                type = lib.types.listOf lib.types.attrs;
                default = [ ];
                description = "Firewall rules for inbound traffic.";
                example = [
                  {
                    port = "any";
                    proto = "any";
                    host = "any";
                  }
                ];
              };

              settings = lib.mkOption {
                type = format.type;
                default = { };
                description = ''
                  Nebula configuration. Refer to
                  <https://github.com/slackhq/nebula/blob/master/examples/config.yml>
                  for details on supported values.
                '';
                example = lib.literalExpression ''
                  {
                    lighthouse.interval = 15;
                  }
                '';
              };
            };
          }
        );
      };
    };
  };

  # Implementation
  config = lib.mkIf (enabledNetworks != { }) {
    systemd.services = lib.mkMerge (
      lib.mapAttrsToList (
        netName: netCfg:
        let
          networkId = nameToId netName;
          settings = lib.recursiveUpdate {
            pki = {
              ca = netCfg.ca;
              cert = netCfg.cert;
              key = netCfg.key;
            };
            static_host_map = netCfg.staticHostMap;
            lighthouse = {
              am_lighthouse = netCfg.isLighthouse;
              hosts = netCfg.lighthouses;
              serve_dns = netCfg.lighthouse.dns.enable;
              dns.host = netCfg.lighthouse.dns.host;
              dns.port = netCfg.lighthouse.dns.port;
            };
            relay = {
              am_relay = netCfg.isRelay;
              relays = netCfg.relays;
              use_relays = true;
            };
            listen = {
              host = netCfg.listen.host;
              port = resolveFinalPort netCfg;
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
          configFile = format.generate "nebula-config-${netName}.yml" (
            lib.warnIf
              ((settings.lighthouse.am_lighthouse || settings.relay.am_relay) && settings.listen.port == 0)
              ''
                Nebula network '${netName}' is configured as a lighthouse or relay, and its port is ${builtins.toString settings.listen.port}.
                You will likely experience connectivity issues: https://nebula.defined.net/docs/config/listen/#listenport
              ''
              settings
          );
          capabilities =
            let
              nebulaPort = if !settings.tun.disabled then settings.listen.port else 0;
              dnsPort = if settings.lighthouse.serve_dns then settings.lighthouse.dns.port else 0;
            in
            lib.concatStringsSep " " (
              # creation of tunnel interfaces
              lib.optional (!settings.tun.disabled) "CAP_NET_ADMIN"
              # binding to privileged ports
              ++ lib.optional (
                nebulaPort > 0 && nebulaPort < 1024 || dnsPort > 0 && dnsPort < 1024
              ) "CAP_NET_BIND_SERVICE"
            );
        in
        {
          # Create the systemd service for Nebula.
          "nebula@${netName}" = {
            description = "Nebula VPN service for ${netName}";
            wants = [ "basic.target" ];
            after = [
              "basic.target"
              "network.target"
            ];
            before = [ "sshd.service" ];
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              Type = "notify";
              Restart = "always";
              ExecStart = "${netCfg.package}/bin/nebula -config ${configFile}";
              ExecReload = "${pkgs.coreutils}/bin/kill -s HUP $MAINPID";
              UMask = "0027";
              CapabilityBoundingSet = capabilities;
              AmbientCapabilities = capabilities;
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
              ProtectSystem = true;
              RestrictNamespaces = true;
              RestrictSUIDSGID = true;
              User = networkId;
              Group = networkId;
            };
            unitConfig.StartLimitIntervalSec = 0; # ensure Restart=always is always honoured (networks can go down for arbitrarily long)
          };
        }
      ) enabledNetworks
    );

    # Open the chosen ports for UDP.
    networking.firewall.allowedUDPPorts = lib.unique (
      lib.filter (port: port > 0) (
        lib.mapAttrsToList (netName: netCfg: resolveFinalPort netCfg) enabledNetworks
      )
    );

    # Create the service users and groups.
    users.users = lib.mkMerge (
      lib.mapAttrsToList (netName: netCfg: {
        ${nameToId netName} = {
          group = nameToId netName;
          description = "Nebula service user for network ${netName}";
          isSystemUser = true;
        };
      }) enabledNetworks
    );

    users.groups = lib.mkMerge (
      lib.mapAttrsToList (netName: netCfg: {
        ${nameToId netName} = { };
      }) enabledNetworks
    );
  };

  meta.maintainers = with lib.maintainers; [
    numinit
    siriobalmelli
  ];
}
