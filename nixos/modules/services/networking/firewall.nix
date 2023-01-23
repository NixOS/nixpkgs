{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.networking.firewall;

  canonicalizePortList =
    ports: lib.unique (builtins.sort builtins.lessThan ports);

  commonOptions = {
    allowedTCPPorts = mkOption {
      type = types.listOf types.port;
      default = [ ];
      apply = canonicalizePortList;
      example = [ 22 80 ];
      description = lib.mdDoc ''
        List of TCP ports on which incoming connections are
        accepted.
      '';
    };

    allowedTCPPortRanges = mkOption {
      type = types.listOf (types.attrsOf types.port);
      default = [ ];
      example = [{ from = 8999; to = 9003; }];
      description = lib.mdDoc ''
        A range of TCP ports on which incoming connections are
        accepted.
      '';
    };

    allowedUDPPorts = mkOption {
      type = types.listOf types.port;
      default = [ ];
      apply = canonicalizePortList;
      example = [ 53 ];
      description = lib.mdDoc ''
        List of open UDP ports.
      '';
    };

    allowedUDPPortRanges = mkOption {
      type = types.listOf (types.attrsOf types.port);
      default = [ ];
      example = [{ from = 60000; to = 61000; }];
      description = lib.mdDoc ''
        Range of open UDP ports.
      '';
    };
  };

in

{

  options = {

    networking.firewall = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Whether to enable the firewall.  This is a simple stateful
          firewall that blocks connection attempts to unauthorised TCP
          or UDP ports on this machine.
        '';
      };

      package = mkOption {
        type = types.package;
        default = if config.networking.nftables.enable then pkgs.nftables else pkgs.iptables;
        defaultText = literalExpression ''if config.networking.nftables.enable then "pkgs.nftables" else "pkgs.iptables"'';
        example = literalExpression "pkgs.iptables-legacy";
        description = lib.mdDoc ''
          The package to use for running the firewall service.
        '';
      };

      logRefusedConnections = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Whether to log rejected or dropped incoming connections.
          Note: The logs are found in the kernel logs, i.e. dmesg
          or journalctl -k.
        '';
      };

      logRefusedPackets = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
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
        description = lib.mdDoc ''
          If {option}`networking.firewall.logRefusedPackets`
          and this option are enabled, then only log packets
          specifically directed at this machine, i.e., not broadcasts
          or multicasts.
        '';
      };

      rejectPackets = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
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
        description = lib.mdDoc ''
          Traffic coming in from these interfaces will be accepted
          unconditionally.  Traffic from the loopback (lo) interface
          will always be accepted.
        '';
      };

      allowPing = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
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
        description = lib.mdDoc ''
          If pings are allowed, this allows setting rate limits on them.

          For the iptables based firewall, it should be set like
          "--limit 1/minute --limit-burst 5".

          For the nftables based firewall, it should be set like
          "2/second" or "1/minute burst 5 packets".
        '';
      };

      checkReversePath = mkOption {
        type = types.either types.bool (types.enum [ "strict" "loose" ]);
        default = true;
        defaultText = literalMD "`true` except if the iptables based firewall is in use and the kernel lacks rpfilter support";
        example = "loose";
        description = lib.mdDoc ''
          Performs a reverse path filter test on a packet.  If a reply
          to the packet would not be sent via the same interface that
          the packet arrived on, it is refused.

          If using asymmetric routing or other complicated routing, set
          this option to loose mode or disable it and setup your own
          counter-measures.

          This option can be either true (or "strict"), "loose" (only
          drop the packet if the source address is not reachable via any
          interface) or false.
        '';
      };

      logReversePathDrops = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Logs dropped packets failing the reverse path filter test if
          the option networking.firewall.checkReversePath is enabled.
        '';
      };

      filterForward = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Enable filtering in IP forwarding.

          This option only works with the nftables based firewall.
        '';
      };

      connectionTrackingModules = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "ftp" "irc" "sane" "sip" "tftp" "amanda" "h323" "netbios_sn" "pptp" "snmp" ];
        description = lib.mdDoc ''
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
        description = lib.mdDoc ''
          Whether to auto-load connection-tracking helpers.
          See the description at networking.firewall.connectionTrackingModules

          (needs kernel 3.5+)
        '';
      };

      extraPackages = mkOption {
        type = types.listOf types.package;
        default = [ ];
        example = literalExpression "[ pkgs.ipset ]";
        description = lib.mdDoc ''
          Additional packages to be included in the environment of the system
          as well as the path of networking.firewall.extraCommands.
        '';
      };

      interfaces = mkOption {
        default = { };
        type = with types; attrsOf (submodule [{ options = commonOptions; }]);
        description = lib.mdDoc ''
          Interface-specific open ports.
        '';
      };

      allInterfaces = mkOption {
        internal = true;
        visible = false;
        default = { default = mapAttrs (name: value: cfg.${name}) commonOptions; } // cfg.interfaces;
        type = with types; attrsOf (submodule [{ options = commonOptions; }]);
        description = lib.mdDoc ''
          All open ports.
        '';
      };
    } // commonOptions;

  };


  config = mkIf cfg.enable {

    assertions = [
      {
        assertion = cfg.filterForward -> config.networking.nftables.enable;
        message = "filterForward only works with the nftables based firewall";
      }
    ];

    networking.firewall.trustedInterfaces = [ "lo" ];

    environment.systemPackages = [ cfg.package ] ++ cfg.extraPackages;

    boot.kernelModules = (optional cfg.autoLoadConntrackHelpers "nf_conntrack")
      ++ map (x: "nf_conntrack_${x}") cfg.connectionTrackingModules;
    boot.extraModprobeConfig = optionalString cfg.autoLoadConntrackHelpers ''
      options nf_conntrack nf_conntrack_helper=1
    '';

  };

}
