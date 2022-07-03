/* This module enables a simple firewall.

   The firewall can be customised in arbitrary ways by setting
   ‘networking.firewall.extraCommands’.  For modularity, the firewall
   uses several chains:

   - ‘nixos-fw’ is the main chain for input packet processing.

   - ‘nixos-fw-accept’ is called for accepted packets.  If you want
     additional logging, or want to reject certain packets anyway, you
     can insert rules at the start of this chain.

   - ‘nixos-fw-log-refuse’ and ‘nixos-fw-refuse’ are called for
     refused packets.  (The former jumps to the latter after logging
     the packet.)  If you want additional logging, or want to accept
     certain packets anyway, you can insert rules at the start of
     this chain.

   - ‘nixos-fw-rpfilter’ is used as the main chain in the raw table,
     called from the built-in ‘PREROUTING’ chain.  If the kernel
     supports it and `cfg.checkReversePath` is set this chain will
     perform a reverse path filter test.

   - ‘nixos-drop’ is used while reloading the firewall in order to drop
     all traffic.  Since reloading isn't implemented in an atomic way
     this'll prevent any traffic from leaking through while reloading
     the firewall.  However, if the reloading fails, the ‘firewall-stop’
     script will be called which in return will effectively disable the
     complete firewall (in the default configuration).

*/

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.networking.firewall;

  inherit (config.boot.kernelPackages) kernel;

  kernelHasRPFilter = ((kernel.config.isEnabled or (x: false)) "IP_NF_MATCH_RPFILTER") || (kernel.features.netfilterRPFilter or false);

  helpers = import ./helpers.nix { inherit config lib; };

  writeShScript = name: text: let dir = pkgs.writeScriptBin name ''
    #! ${pkgs.runtimeShell} -e
    ${text}
  ''; in "${dir}/bin/${name}";

  defaultInterface = { default = mapAttrs (name: value: cfg.${name}) commonOptions; };
  allInterfaces = defaultInterface // cfg.interfaces;

  startScript = writeShScript "firewall-start" ''
    ${helpers}

    # Flush the old firewall rules.  !!! Ideally, updating the
    # firewall would be atomic.  Apparently that's possible
    # with iptables-restore.
    ip46tables -D INPUT -j nixos-fw 2> /dev/null || true
    for chain in nixos-fw nixos-fw-accept nixos-fw-log-refuse nixos-fw-refuse; do
      ip46tables -F "$chain" 2> /dev/null || true
      ip46tables -X "$chain" 2> /dev/null || true
    done


    # The "nixos-fw-accept" chain just accepts packets.
    ip46tables -N nixos-fw-accept
    ip46tables -A nixos-fw-accept -j ACCEPT


    # The "nixos-fw-refuse" chain rejects or drops packets.
    ip46tables -N nixos-fw-refuse

    ${if cfg.rejectPackets then ''
      # Send a reset for existing TCP connections that we've
      # somehow forgotten about.  Send ICMP "port unreachable"
      # for everything else.
      ip46tables -A nixos-fw-refuse -p tcp ! --syn -j REJECT --reject-with tcp-reset
      ip46tables -A nixos-fw-refuse -j REJECT
    '' else ''
      ip46tables -A nixos-fw-refuse -j DROP
    ''}


    # The "nixos-fw-log-refuse" chain performs logging, then
    # jumps to the "nixos-fw-refuse" chain.
    ip46tables -N nixos-fw-log-refuse

    ${optionalString cfg.logRefusedConnections ''
      ip46tables -A nixos-fw-log-refuse -p tcp --syn -j LOG --log-level info --log-prefix "refused connection: "
    ''}
    ${optionalString (cfg.logRefusedPackets && !cfg.logRefusedUnicastsOnly) ''
      ip46tables -A nixos-fw-log-refuse -m pkttype --pkt-type broadcast \
        -j LOG --log-level info --log-prefix "refused broadcast: "
      ip46tables -A nixos-fw-log-refuse -m pkttype --pkt-type multicast \
        -j LOG --log-level info --log-prefix "refused multicast: "
    ''}
    ip46tables -A nixos-fw-log-refuse -m pkttype ! --pkt-type unicast -j nixos-fw-refuse
    ${optionalString cfg.logRefusedPackets ''
      ip46tables -A nixos-fw-log-refuse \
        -j LOG --log-level info --log-prefix "refused packet: "
    ''}
    ip46tables -A nixos-fw-log-refuse -j nixos-fw-refuse


    # The "nixos-fw" chain does the actual work.
    ip46tables -N nixos-fw

    # Clean up rpfilter rules
    ip46tables -t raw -D PREROUTING -j nixos-fw-rpfilter 2> /dev/null || true
    ip46tables -t raw -F nixos-fw-rpfilter 2> /dev/null || true
    ip46tables -t raw -X nixos-fw-rpfilter 2> /dev/null || true

    ${optionalString (kernelHasRPFilter && (cfg.checkReversePath != false)) ''
      # Perform a reverse-path test to refuse spoofers
      # For now, we just drop, as the raw table doesn't have a log-refuse yet
      ip46tables -t raw -N nixos-fw-rpfilter 2> /dev/null || true
      ip46tables -t raw -A nixos-fw-rpfilter -m rpfilter --validmark ${optionalString (cfg.checkReversePath == "loose") "--loose"} -j RETURN

      # Allows this host to act as a DHCP4 client without first having to use APIPA
      iptables -t raw -A nixos-fw-rpfilter -p udp --sport 67 --dport 68 -j RETURN

      # Allows this host to act as a DHCPv4 server
      iptables -t raw -A nixos-fw-rpfilter -s 0.0.0.0 -d 255.255.255.255 -p udp --sport 68 --dport 67 -j RETURN

      ${optionalString cfg.logReversePathDrops ''
        ip46tables -t raw -A nixos-fw-rpfilter -j LOG --log-level info --log-prefix "rpfilter drop: "
      ''}
      ip46tables -t raw -A nixos-fw-rpfilter -j DROP

      ip46tables -t raw -A PREROUTING -j nixos-fw-rpfilter
    ''}

    # Accept all traffic on the trusted interfaces.
    ${flip concatMapStrings cfg.trustedInterfaces (iface: ''
      ip46tables -A nixos-fw -i ${iface} -j nixos-fw-accept
    '')}

    # Accept packets from established or related connections.
    ip46tables -A nixos-fw -m conntrack --ctstate ESTABLISHED,RELATED -j nixos-fw-accept

    # Accept connections to the allowed TCP ports.
    ${concatStrings (mapAttrsToList (iface: cfg:
      concatMapStrings (port:
        ''
          ip46tables -A nixos-fw -p tcp --dport ${toString port} -j nixos-fw-accept ${optionalString (iface != "default") "-i ${iface}"}
        ''
      ) cfg.allowedTCPPorts
    ) allInterfaces)}

    # Accept connections to the allowed TCP port ranges.
    ${concatStrings (mapAttrsToList (iface: cfg:
      concatMapStrings (rangeAttr:
        let range = toString rangeAttr.from + ":" + toString rangeAttr.to; in
        ''
          ip46tables -A nixos-fw -p tcp --dport ${range} -j nixos-fw-accept ${optionalString (iface != "default") "-i ${iface}"}
        ''
      ) cfg.allowedTCPPortRanges
    ) allInterfaces)}

    # Accept packets on the allowed UDP ports.
    ${concatStrings (mapAttrsToList (iface: cfg:
      concatMapStrings (port:
        ''
          ip46tables -A nixos-fw -p udp --dport ${toString port} -j nixos-fw-accept ${optionalString (iface != "default") "-i ${iface}"}
        ''
      ) cfg.allowedUDPPorts
    ) allInterfaces)}

    # Accept packets on the allowed UDP port ranges.
    ${concatStrings (mapAttrsToList (iface: cfg:
      concatMapStrings (rangeAttr:
        let range = toString rangeAttr.from + ":" + toString rangeAttr.to; in
        ''
          ip46tables -A nixos-fw -p udp --dport ${range} -j nixos-fw-accept ${optionalString (iface != "default") "-i ${iface}"}
        ''
      ) cfg.allowedUDPPortRanges
    ) allInterfaces)}

    # Optionally respond to ICMPv4 pings.
    ${optionalString cfg.allowPing ''
      iptables -w -A nixos-fw -p icmp --icmp-type echo-request ${optionalString (cfg.pingLimit != null)
        "-m limit ${cfg.pingLimit} "
      }-j nixos-fw-accept
    ''}

    ${optionalString config.networking.enableIPv6 ''
      # Accept all ICMPv6 messages except redirects and node
      # information queries (type 139).  See RFC 4890, section
      # 4.4.
      ip6tables -A nixos-fw -p icmpv6 --icmpv6-type redirect -j DROP
      ip6tables -A nixos-fw -p icmpv6 --icmpv6-type 139 -j DROP
      ip6tables -A nixos-fw -p icmpv6 -j nixos-fw-accept

      # Allow this host to act as a DHCPv6 client
      ip6tables -A nixos-fw -d fe80::/64 -p udp --dport 546 -j nixos-fw-accept
    ''}

    ${cfg.extraCommands}

    # Reject/drop everything else.
    ip46tables -A nixos-fw -j nixos-fw-log-refuse


    # Enable the firewall.
    ip46tables -A INPUT -j nixos-fw
  '';

  stopScript = writeShScript "firewall-stop" ''
    ${helpers}

    # Clean up in case reload fails
    ip46tables -D INPUT -j nixos-drop 2>/dev/null || true

    # Clean up after added ruleset
    ip46tables -D INPUT -j nixos-fw 2>/dev/null || true

    ${optionalString (kernelHasRPFilter && (cfg.checkReversePath != false)) ''
      ip46tables -t raw -D PREROUTING -j nixos-fw-rpfilter 2>/dev/null || true
    ''}

    ${cfg.extraStopCommands}
  '';

  reloadScript = writeShScript "firewall-reload" ''
    ${helpers}

    # Create a unique drop rule
    ip46tables -D INPUT -j nixos-drop 2>/dev/null || true
    ip46tables -F nixos-drop 2>/dev/null || true
    ip46tables -X nixos-drop 2>/dev/null || true
    ip46tables -N nixos-drop
    ip46tables -A nixos-drop -j DROP

    # Don't allow traffic to leak out until the script has completed
    ip46tables -A INPUT -j nixos-drop

    ${cfg.extraStopCommands}

    if ${startScript}; then
      ip46tables -D INPUT -j nixos-drop 2>/dev/null || true
    else
      echo "Failed to reload firewall... Stopping"
      ${stopScript}
      exit 1
    fi
  '';

  canonicalizePortList =
    ports: lib.unique (builtins.sort builtins.lessThan ports);

  commonOptions = {
    allowedTCPPorts = mkOption {
      type = types.listOf types.port;
      default = [ ];
      apply = canonicalizePortList;
      example = [ 22 80 ];
      description =
        ''
          List of TCP ports on which incoming connections are
          accepted.
        '';
    };

    allowedTCPPortRanges = mkOption {
      type = types.listOf (types.attrsOf types.port);
      default = [ ];
      example = [ { from = 8999; to = 9003; } ];
      description =
        ''
          A range of TCP ports on which incoming connections are
          accepted.
        '';
    };

    allowedUDPPorts = mkOption {
      type = types.listOf types.port;
      default = [ ];
      apply = canonicalizePortList;
      example = [ 53 ];
      description =
        ''
          List of open UDP ports.
        '';
    };

    allowedUDPPortRanges = mkOption {
      type = types.listOf (types.attrsOf types.port);
      default = [ ];
      example = [ { from = 60000; to = 61000; } ];
      description =
        ''
          Range of open UDP ports.
        '';
    };
  };

in

{

  ###### interface

  options = {

    networking.firewall = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description =
          ''
            Whether to enable the firewall.  This is a simple stateful
            firewall that blocks connection attempts to unauthorised TCP
            or UDP ports on this machine.  It does not affect packet
            forwarding.
          '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.iptables;
        defaultText = literalExpression "pkgs.iptables";
        example = literalExpression "pkgs.iptables-legacy";
        description =
          ''
            The iptables package to use for running the firewall service."
          '';
      };

      logRefusedConnections = mkOption {
        type = types.bool;
        default = true;
        description =
          ''
            Whether to log rejected or dropped incoming connections.
            Note: The logs are found in the kernel logs, i.e. dmesg
            or journalctl -k.
          '';
      };

      logRefusedPackets = mkOption {
        type = types.bool;
        default = false;
        description =
          ''
            Whether to log all rejected or dropped incoming packets.
            This tends to give a lot of log messages, so it's mostly
            useful for debugging.
            Note: The logs are found in the kernel logs, i.e. dmesg
            or journalctl -k.
          '';
      };

      logRefusedUnicastsOnly = mkOption {
        type = types.bool;
        default = true;
        description =
          ''
            If <option>networking.firewall.logRefusedPackets</option>
            and this option are enabled, then only log packets
            specifically directed at this machine, i.e., not broadcasts
            or multicasts.
          '';
      };

      rejectPackets = mkOption {
        type = types.bool;
        default = false;
        description =
          ''
            If set, refused packets are rejected rather than dropped
            (ignored).  This means that an ICMP "port unreachable" error
            message is sent back to the client (or a TCP RST packet in
            case of an existing connection).  Rejecting packets makes
            port scanning somewhat easier.
          '';
      };

      trustedInterfaces = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "enp0s2" ];
        description =
          ''
            Traffic coming in from these interfaces will be accepted
            unconditionally.  Traffic from the loopback (lo) interface
            will always be accepted.
          '';
      };

      allowPing = mkOption {
        type = types.bool;
        default = true;
        description =
          ''
            Whether to respond to incoming ICMPv4 echo requests
            ("pings").  ICMPv6 pings are always allowed because the
            larger address space of IPv6 makes network scanning much
            less effective.
          '';
      };

      pingLimit = mkOption {
        type = types.nullOr (types.separatedString " ");
        default = null;
        example = "--limit 1/minute --limit-burst 5";
        description =
          ''
            If pings are allowed, this allows setting rate limits
            on them.  If non-null, this option should be in the form of
            flags like "--limit 1/minute --limit-burst 5"
          '';
      };

      checkReversePath = mkOption {
        type = types.either types.bool (types.enum ["strict" "loose"]);
        default = kernelHasRPFilter;
        defaultText = literalDocBook "<literal>true</literal> if supported by the chosen kernel";
        example = "loose";
        description =
          ''
            Performs a reverse path filter test on a packet.  If a reply
            to the packet would not be sent via the same interface that
            the packet arrived on, it is refused.

            If using asymmetric routing or other complicated routing, set
            this option to loose mode or disable it and setup your own
            counter-measures.

            This option can be either true (or "strict"), "loose" (only
            drop the packet if the source address is not reachable via any
            interface) or false.  Defaults to the value of
            kernelHasRPFilter.
          '';
      };

      logReversePathDrops = mkOption {
        type = types.bool;
        default = false;
        description =
          ''
            Logs dropped packets failing the reverse path filter test if
            the option networking.firewall.checkReversePath is enabled.
          '';
      };

      connectionTrackingModules = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "ftp" "irc" "sane" "sip" "tftp" "amanda" "h323" "netbios_sn" "pptp" "snmp" ];
        description =
          ''
            List of connection-tracking helpers that are auto-loaded.
            The complete list of possible values is given in the example.

            As helpers can pose as a security risk, it is advised to
            set this to an empty list and disable the setting
            networking.firewall.autoLoadConntrackHelpers unless you
            know what you are doing. Connection tracking is disabled
            by default.

            Loading of helpers is recommended to be done through the
            CT target.  More info:
            https://home.regit.org/netfilter-en/secure-use-of-helpers/
          '';
      };

      autoLoadConntrackHelpers = mkOption {
        type = types.bool;
        default = false;
        description =
          ''
            Whether to auto-load connection-tracking helpers.
            See the description at networking.firewall.connectionTrackingModules

            (needs kernel 3.5+)
          '';
      };

      extraCommands = mkOption {
        type = types.lines;
        default = "";
        example = "iptables -A INPUT -p icmp -j ACCEPT";
        description =
          ''
            Additional shell commands executed as part of the firewall
            initialisation script.  These are executed just before the
            final "reject" firewall rule is added, so they can be used
            to allow packets that would otherwise be refused.
          '';
      };

      extraPackages = mkOption {
        type = types.listOf types.package;
        default = [ ];
        example = literalExpression "[ pkgs.ipset ]";
        description =
          ''
            Additional packages to be included in the environment of the system
            as well as the path of networking.firewall.extraCommands.
          '';
      };

      extraStopCommands = mkOption {
        type = types.lines;
        default = "";
        example = "iptables -P INPUT ACCEPT";
        description =
          ''
            Additional shell commands executed as part of the firewall
            shutdown script.  These are executed just after the removal
            of the NixOS input rule, or if the service enters a failed
            state.
          '';
      };

      interfaces = mkOption {
        default = { };
        type = with types; attrsOf (submodule [ { options = commonOptions; } ]);
        description =
          ''
            Interface-specific open ports.
          '';
      };
    } // commonOptions;

  };


  ###### implementation

  # FIXME: Maybe if `enable' is false, the firewall should still be
  # built but not started by default?
  config = mkIf cfg.enable {

    networking.firewall.trustedInterfaces = [ "lo" ];

    environment.systemPackages = [ cfg.package ] ++ cfg.extraPackages;

    boot.kernelModules = (optional cfg.autoLoadConntrackHelpers "nf_conntrack")
      ++ map (x: "nf_conntrack_${x}") cfg.connectionTrackingModules;
    boot.extraModprobeConfig = optionalString cfg.autoLoadConntrackHelpers ''
      options nf_conntrack nf_conntrack_helper=1
    '';

    assertions = [
      # This is approximately "checkReversePath -> kernelHasRPFilter",
      # but the checkReversePath option can include non-boolean
      # values.
      { assertion = cfg.checkReversePath == false || kernelHasRPFilter;
        message = "This kernel does not support rpfilter"; }
    ];

    systemd.services.firewall = {
      description = "Firewall";
      wantedBy = [ "sysinit.target" ];
      wants = [ "network-pre.target" ];
      before = [ "network-pre.target" ];
      after = [ "systemd-modules-load.service" ];

      path = [ cfg.package ] ++ cfg.extraPackages;

      # FIXME: this module may also try to load kernel modules, but
      # containers don't have CAP_SYS_MODULE.  So the host system had
      # better have all necessary modules already loaded.
      unitConfig.ConditionCapability = "CAP_NET_ADMIN";
      unitConfig.DefaultDependencies = false;

      reloadIfChanged = true;

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "@${startScript} firewall-start";
        ExecReload = "@${reloadScript} firewall-reload";
        ExecStop = "@${stopScript} firewall-stop";
      };
    };

  };

}
