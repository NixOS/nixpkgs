# This module enables Network Address Translation (NAT).
# XXX: todo: support multiple upstream links
# see http://yesican.chsoft.biz/lartc/MultihomedLinuxNetworking.html

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.networking.nat;

  mkDest = externalIP:
    if externalIP == null
    then "-j MASQUERADE"
    else "-j SNAT --to-source ${externalIP}";
  dest = mkDest cfg.externalIP;
  destIPv6 = mkDest cfg.externalIPv6;

  # Whether given IP (plus optional port) is an IPv6.
  isIPv6 = ip: builtins.length (lib.splitString ":" ip) > 2;

  helpers = import ./helpers.nix { inherit config lib; };

  flushNat = ''
    ${helpers}
    ip46tables -w -t nat -D PREROUTING -j nixos-nat-pre 2>/dev/null|| true
    ip46tables -w -t nat -F nixos-nat-pre 2>/dev/null || true
    ip46tables -w -t nat -X nixos-nat-pre 2>/dev/null || true
    ip46tables -w -t nat -D POSTROUTING -j nixos-nat-post 2>/dev/null || true
    ip46tables -w -t nat -F nixos-nat-post 2>/dev/null || true
    ip46tables -w -t nat -X nixos-nat-post 2>/dev/null || true
    ip46tables -w -t nat -D OUTPUT -j nixos-nat-out 2>/dev/null || true
    ip46tables -w -t nat -F nixos-nat-out 2>/dev/null || true
    ip46tables -w -t nat -X nixos-nat-out 2>/dev/null || true

    ${cfg.extraStopCommands}
  '';

  mkSetupNat = { iptables, dest, internalIPs, forwardPorts }: ''
    # We can't match on incoming interface in POSTROUTING, so
    # mark packets coming from the internal interfaces.
    ${concatMapStrings (iface: ''
      ${iptables} -w -t nat -A nixos-nat-pre \
        -i '${iface}' -j MARK --set-mark 1
    '') cfg.internalInterfaces}

    # NAT the marked packets.
    ${optionalString (cfg.internalInterfaces != []) ''
      ${iptables} -w -t nat -A nixos-nat-post -m mark --mark 1 \
        ${optionalString (cfg.externalInterface != null) "-o ${cfg.externalInterface}"} ${dest}
    ''}

    # NAT packets coming from the internal IPs.
    ${concatMapStrings (range: ''
      ${iptables} -w -t nat -A nixos-nat-post \
        -s '${range}' ${optionalString (cfg.externalInterface != null) "-o ${cfg.externalInterface}"} ${dest}
    '') internalIPs}

    # NAT from external ports to internal ports.
    ${concatMapStrings (fwd: ''
      ${iptables} -w -t nat -A nixos-nat-pre \
        -i ${toString cfg.externalInterface} -p ${fwd.proto} \
        --dport ${builtins.toString fwd.sourcePort} \
        -j DNAT --to-destination ${fwd.destination}

      ${concatMapStrings (loopbackip:
        let
          matchIP          = if isIPv6 fwd.destination then "[[]([0-9a-fA-F:]+)[]]" else "([0-9.]+)";
          m                = builtins.match "${matchIP}:([0-9-]+)" fwd.destination;
          destinationIP    = if m == null then throw "bad ip:ports `${fwd.destination}'" else elemAt m 0;
          destinationPorts = if m == null then throw "bad ip:ports `${fwd.destination}'" else builtins.replaceStrings ["-"] [":"] (elemAt m 1);
        in ''
          # Allow connections to ${loopbackip}:${toString fwd.sourcePort} from the host itself
          ${iptables} -w -t nat -A nixos-nat-out \
            -d ${loopbackip} -p ${fwd.proto} \
            --dport ${builtins.toString fwd.sourcePort} \
            -j DNAT --to-destination ${fwd.destination}

          # Allow connections to ${loopbackip}:${toString fwd.sourcePort} from other hosts behind NAT
          ${iptables} -w -t nat -A nixos-nat-pre \
            -d ${loopbackip} -p ${fwd.proto} \
            --dport ${builtins.toString fwd.sourcePort} \
            -j DNAT --to-destination ${fwd.destination}

          ${iptables} -w -t nat -A nixos-nat-post \
            -d ${destinationIP} -p ${fwd.proto} \
            --dport ${destinationPorts} \
            -j SNAT --to-source ${loopbackip}
        '') fwd.loopbackIPs}
    '') forwardPorts}
  '';

  setupNat = ''
    ${helpers}
    # Create subchains where we store rules
    ip46tables -w -t nat -N nixos-nat-pre
    ip46tables -w -t nat -N nixos-nat-post
    ip46tables -w -t nat -N nixos-nat-out

    ${mkSetupNat {
      iptables = "iptables";
      inherit dest;
      inherit (cfg) internalIPs;
      forwardPorts = filter (x: !(isIPv6 x.destination)) cfg.forwardPorts;
    }}

    ${optionalString cfg.enableIPv6 (mkSetupNat {
      iptables = "ip6tables";
      dest = destIPv6;
      internalIPs = cfg.internalIPv6s;
      forwardPorts = filter (x: isIPv6 x.destination) cfg.forwardPorts;
    })}

    ${optionalString (cfg.dmzHost != null) ''
      iptables -w -t nat -A nixos-nat-pre \
        -i ${toString cfg.externalInterface} -j DNAT \
        --to-destination ${cfg.dmzHost}
    ''}

    ${cfg.extraCommands}

    # Append our chains to the nat tables
    ip46tables -w -t nat -A PREROUTING -j nixos-nat-pre
    ip46tables -w -t nat -A POSTROUTING -j nixos-nat-post
    ip46tables -w -t nat -A OUTPUT -j nixos-nat-out
  '';

in

{

  options = {

    networking.nat.extraCommands = mkOption {
      type = types.lines;
      default = "";
      example = "iptables -A INPUT -p icmp -j ACCEPT";
      description = lib.mdDoc ''
        Additional shell commands executed as part of the nat
        initialisation script.

        This option is incompatible with the nftables based nat module.
      '';
    };

    networking.nat.extraStopCommands = mkOption {
      type = types.lines;
      default = "";
      example = "iptables -D INPUT -p icmp -j ACCEPT || true";
      description = lib.mdDoc ''
        Additional shell commands executed as part of the nat
        teardown script.

        This option is incompatible with the nftables based nat module.
      '';
    };

  };


  config = mkIf (!config.networking.nftables.enable)
    (mkMerge [
      ({ networking.firewall.extraCommands = mkBefore flushNat; })
      (mkIf config.networking.nat.enable {

        networking.firewall = mkIf config.networking.firewall.enable {
          extraCommands = setupNat;
          extraStopCommands = flushNat;
        };

        systemd.services = mkIf (!config.networking.firewall.enable) {
          nat = {
            description = "Network Address Translation";
            wantedBy = [ "network.target" ];
            after = [ "network-pre.target" "systemd-modules-load.service" ];
            path = [ config.networking.firewall.package ];
            unitConfig.ConditionCapability = "CAP_NET_ADMIN";

            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };

            script = flushNat + setupNat;

            postStop = flushNat;
          };
        };
      })
    ]);
}
