{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) types;
  inherit (lib.attrsets)
    filterAttrs
    mapAttrs
    mapAttrs'
    mapAttrsToList
    nameValuePair
    ;
  inherit (lib.lists) concatMap concatLists filter;
  inherit (lib.modules) mkIf;
  inherit (lib.options) literalExpression mkOption;
  inherit (lib.strings) hasInfix;
  inherit (lib.trivial) flip pipe;

  removeNulls = filterAttrs (_: v: v != null);

  privateKeyCredential = interfaceName: "wireguard-${interfaceName}-private-key";
  presharedKeyCredential =
    interfaceName: peer: "wireguard-${interfaceName}-${peer.name}-preshared-key";

  interfaceCredentials =
    interfaceName: interface:
    [ "${privateKeyCredential interfaceName}:${interface.privateKeyFile}" ]
    ++ pipe interface.peers [
      (filter (peer: peer.presharedKeyFile != null))
      (map (peer: "${presharedKeyCredential interfaceName peer}:${peer.presharedKeyFile}"))
    ];

  generateNetdev =
    name: interface:
    nameValuePair "40-${name}" {
      netdevConfig = removeNulls {
        Kind = "wireguard";
        Name = name;
        MTUBytes = interface.mtu;
      };
      wireguardConfig = removeNulls {
        PrivateKey = "@${privateKeyCredential name}";
        ListenPort = interface.listenPort;
        FirewallMark = interface.fwMark;
        RouteTable = if interface.allowedIPsAsRoutes then interface.table else null;
        RouteMetric = interface.metric;
      };
      wireguardPeers = map (generateWireguardPeer name) interface.peers;
    };

  generateWireguardPeer =
    interfaceName: peer:
    removeNulls {
      PublicKey = peer.publicKey;
      PresharedKey = "@${presharedKeyCredential interfaceName peer}";
      AllowedIPs = peer.allowedIPs;
      Endpoint = peer.endpoint;
      PersistentKeepalive = peer.persistentKeepalive;
    };

  generateNetwork = name: interface: {
    matchConfig.Name = name;
    address = interface.ips;
  };

  cfg = config.networking.wireguard;

  refreshEnabledInterfaces = filterAttrs (
    name: interface: interface.dynamicEndpointRefreshSeconds != 0
  ) cfg.interfaces;

  generateRefreshTimer =
    name: interface:
    nameValuePair "wireguard-dynamic-refresh-${name}" {
      partOf = [ "wireguard-dynamic-refresh-${name}.service" ];
      wantedBy = [ "timers.target" ];
      description = "Wireguard dynamic endpoint refresh (${name}) timer";
      timerConfig.OnBootSec = interface.dynamicEndpointRefreshSeconds;
      timerConfig.OnUnitInactiveSec = interface.dynamicEndpointRefreshSeconds;
    };

  generateRefreshService =
    name: interface:
    nameValuePair "wireguard-dynamic-refresh-${name}" {
      description = "Wireguard dynamic endpoint refresh (${name})";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      path = with pkgs; [
        iproute2
        systemd
      ];
      # networkd doesn't provide a mechanism for refreshing endpoints.
      # See: https://github.com/systemd/systemd/issues/9911
      # This hack does the job but takes down the whole interface to do it.
      script = ''
        ip link delete ${name}
        networkctl reload
      '';
    };

in
{
  meta.maintainers = [ lib.maintainers.majiir ];

  options.networking.wireguard = {
    useNetworkd = mkOption {
      default = config.networking.useNetworkd;
      defaultText = literalExpression "config.networking.useNetworkd";
      type = types.bool;
      description = ''
        Whether to use networkd as the network configuration backend for
        Wireguard instead of the legacy script-based system.

        ::: {.warning}
        Some options have slightly different behavior with the networkd and
        script-based backends. Check the documentation for each Wireguard
        option you use before enabling this option.
        :::
      '';
    };
  };

  config = mkIf (cfg.enable && cfg.useNetworkd) {

    # TODO: Some of these options may be possible to support in networkd.
    #
    # privateKey and presharedKey are trivial to support, but we deliberately
    # don't in order to discourage putting secrets in the /nix store.
    #
    # generatePrivateKeyFile can be supported if we can order a service before
    # networkd configures interfaces. There is also a systemd feature request
    # for key generation: https://github.com/systemd/systemd/issues/14282
    #
    # preSetup, postSetup, preShutdown and postShutdown may be possible, but
    # networkd is not likely to support script hooks like this directly. See:
    # https://github.com/systemd/systemd/issues/11629
    #
    # socketNamespace and interfaceNamespace can be implemented once networkd
    # supports setting a netdev's namespace. See:
    # https://github.com/systemd/systemd/issues/11103
    # https://github.com/systemd/systemd/pull/14915

    assertions = concatLists (
      flip mapAttrsToList cfg.interfaces (
        name: interface:
        [
          # Interface assertions
          {
            assertion = interface.privateKey == null;
            message = "networking.wireguard.interfaces.${name}.privateKey cannot be used with networkd. Use privateKeyFile instead.";
          }
          {
            assertion = !interface.generatePrivateKeyFile;
            message = "networking.wireguard.interfaces.${name}.generatePrivateKeyFile cannot be used with networkd.";
          }
          {
            assertion = interface.preSetup == "";
            message = "networking.wireguard.interfaces.${name}.preSetup cannot be used with networkd.";
          }
          {
            assertion = interface.postSetup == "";
            message = "networking.wireguard.interfaces.${name}.postSetup cannot be used with networkd.";
          }
          {
            assertion = interface.preShutdown == "";
            message = "networking.wireguard.interfaces.${name}.preShutdown cannot be used with networkd.";
          }
          {
            assertion = interface.postShutdown == "";
            message = "networking.wireguard.interfaces.${name}.postShutdown cannot be used with networkd.";
          }
          {
            assertion = interface.socketNamespace == null;
            message = "networking.wireguard.interfaces.${name}.socketNamespace cannot be used with networkd.";
          }
          {
            assertion = interface.interfaceNamespace == null;
            message = "networking.wireguard.interfaces.${name}.interfaceNamespace cannot be used with networkd.";
          }
        ]
        ++ flip concatMap interface.ips (ip: [
          # IP assertions
          {
            assertion = hasInfix "/" ip;
            message = "networking.wireguard.interfaces.${name}.ips value \"${ip}\" requires a subnet (e.g. 192.0.2.1/32) with networkd.";
          }
        ])
        ++ flip concatMap interface.peers (peer: [
          # Peer assertions
          {
            assertion = peer.presharedKey == null;
            message = "networking.wireguard.interfaces.${name}.peers[].presharedKey cannot be used with networkd. Use presharedKeyFile instead.";
          }
          {
            assertion = peer.dynamicEndpointRefreshSeconds == null;
            message = "networking.wireguard.interfaces.${name}.peers[].dynamicEndpointRefreshSeconds cannot be used with networkd. Use networking.wireguard.interfaces.${name}.dynamicEndpointRefreshSeconds instead.";
          }
          {
            assertion = peer.dynamicEndpointRefreshRestartSeconds == null;
            message = "networking.wireguard.interfaces.${name}.peers[].dynamicEndpointRefreshRestartSeconds cannot be used with networkd.";
          }
        ])
      )
    );

    systemd.network = {
      enable = true;
      netdevs = mapAttrs' generateNetdev cfg.interfaces;
      networks = mapAttrs generateNetwork cfg.interfaces;
    };

    systemd.timers = mapAttrs' generateRefreshTimer refreshEnabledInterfaces;
    systemd.services = (mapAttrs' generateRefreshService refreshEnabledInterfaces) // {
      systemd-networkd.serviceConfig.LoadCredential = mapAttrsToList interfaceCredentials cfg.interfaces;
    };
  };
}
