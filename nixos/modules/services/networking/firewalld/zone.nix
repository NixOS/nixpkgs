{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.firewalld;
  format = pkgs.formats.xml { };
  lib' = import ./lib.nix { inherit lib; };
  inherit (lib')
    filterNullAttrs
    mkPortOption
    mkXmlAttr
    portProtocolOptions
    protocolOption
    toXmlAttrs
    ;
  inherit (lib) mkOption;
  inherit (lib.types)
    attrTag
    attrsOf
    bool
    enum
    ints
    listOf
    nonEmptyStr
    nullOr
    strMatching
    submodule
    ;
in
{
  options.services.firewalld.zones = mkOption {
    description = ''
      firewalld zone configuration files.
      See {manpage}`firewalld.zone(5)`.
    '';
    default = { };
    example = {
      public = {
        forward = true;
        services = [
          "ssh"
          "dhcpv6-client"
        ];
      };
      external = {
        forward = true;
        services = [
          "ssh"
        ];
        masquerade = true;
      };
      dmz = {
        forward = true;
        services = [
          "ssh"
        ];
      };
      work = {
        forward = true;
        services = [
          "ssh"
          "dhcpv6-client"
        ];
      };
      home = {
        forward = true;
        services = [
          "ssh"
          "mdns"
          "samba-client"
          "dhcpv6-client"
        ];
      };
      internal = {
        forward = true;
        services = [
          "ssh"
          "mdns"
          "samba-client"
          "dhcpv6-client"
        ];
      };
    };
    type = attrsOf (submodule {
      options = {
        version = mkOption {
          type = nullOr nonEmptyStr;
          description = "Version of the zone.";
          default = null;
        };
        target = mkOption {
          type = enum [
            "ACCEPT"
            "%%REJECT%%"
            "DROP"
          ];
          description = "Action for packets that doesn't match any rules.";
          default = "%%REJECT%%";
        };
        ingressPriority = mkOption {
          type = nullOr ints.s16;
          description = ''
            Priority for inbound traffic.
            Lower values have higher priority.
          '';
          default = null;
        };
        egressPriority = mkOption {
          type = nullOr ints.s16;
          description = ''
            Priority for outbound traffic.
            Lower values have higher priority.
          '';
          default = null;
        };
        interfaces = mkOption {
          type = listOf nonEmptyStr;
          description = "Interfaces to bind.";
          default = [ ];
        };
        sources = mkOption {
          type = listOf (attrTag {
            address = mkOption {
              type = nonEmptyStr;
              description = ''
                An IP address or a network IP address with a mask for IPv4 or IPv6.
                For IPv4, the mask can be a network mask or a plain number.
                For IPv6 the mask is a plain number.
                The use of host names is not supported.
              '';
            };
            mac = mkOption {
              type = strMatching "([[:xdigit:]]{2}:){5}[[:xdigit:]]{2}";
              description = "A MAC address.";
            };
            ipset = mkOption {
              type = nonEmptyStr;
              description = "An ipset.";
            };
          });
          description = "Source addresses, address ranges, MAC addresses or ipsets to bind.";
          default = [ ];
        };
        icmpBlockInversion = mkOption {
          type = bool;
          description = ''
            Whether to invert the icmp block handling.
            Only enabled ICMP types are accepted and all others are rejected in the zone.
          '';
          default = false;
        };
        forward = mkOption {
          type = bool;
          description = ''
            Whether to enable intra-zone forwarding.
            When enabled, packets will be forwarded between interfaces or sources within a zone, even if the zone's target is not set to ACCEPT.
          '';
          default = false;
        };
        short = mkOption {
          type = nullOr nonEmptyStr;
          description = "Short description for the zone.";
          default = null;
        };
        description = mkOption {
          type = nullOr nonEmptyStr;
          description = "Description for the zone.";
          default = null;
        };
        services = mkOption {
          type = listOf nonEmptyStr;
          description = "Services to allow in the zone.";
          default = [ ];
        };
        ports = mkOption {
          type = listOf (submodule portProtocolOptions);
          description = "Ports to allow in the zone.";
          default = [ ];
        };
        protocols = mkOption {
          type = listOf nonEmptyStr;
          description = "Protocols to allow in the zone.";
          default = [ ];
        };
        icmpBlocks = mkOption {
          type = listOf nonEmptyStr;
          description = "ICMP types to block in the zone.";
          default = [ ];
        };
        masquerade = mkOption {
          type = bool;
          description = "Whether to enable masquerading in the zone.";
          default = false;
        };
        forwardPorts = mkOption {
          type = listOf (submodule {
            options = {
              port = mkPortOption { };
              protocol = protocolOption;
              to-port = (mkPortOption { optional = true; }) // {
                default = null;
              };
              to-addr = mkOption {
                type = nullOr nonEmptyStr;
                description = "Destination IP address.";
                default = null;
              };
            };
          });
          description = "Ports to forward in the zone.";
          default = [ ];
        };
        sourcePorts = mkOption {
          type = listOf (submodule portProtocolOptions);
          description = "Source ports to allow in the zone.";
          default = [ ];
        };
        rules = mkOption {
          type = listOf (format.type);
          description = "Rich rules for the zone.";
          default = [ ];
        };
      };
    });
  };

  config = lib.mkIf cfg.enable {
    services.firewalld.zones = {
      drop = {
        target = "DROP";
        forward = true;
      };
      block = {
        forward = true;
      };
      trusted = {
        target = "ACCEPT";
        forward = true;
      };
    };

    environment.etc = lib.mapAttrs' (
      name: value:
      lib.nameValuePair "firewalld/zones/${name}.xml" {
        source = format.generate "firewalld-zone-${name}.xml" {
          zone =
            let
              mkXmlAttrList = name: builtins.map (mkXmlAttr name);
              mkXmlTag = value: if value then "" else null;
            in
            filterNullAttrs (
              lib.mergeAttrsList [
                (toXmlAttrs { inherit (value) version target; })
                (mkXmlAttr "ingress-priority" value.ingressPriority)
                (mkXmlAttr "egress-priority" value.egressPriority)
                {
                  interface = mkXmlAttrList "name" value.interfaces;
                  source = builtins.map toXmlAttrs value.sources;
                  icmp-block-inversion = mkXmlTag value.icmpBlockInversion;
                  forward = mkXmlTag value.forward;
                  inherit (value) short description;
                  service = mkXmlAttrList "name" value.services;
                  port = builtins.map toXmlAttrs value.ports;
                  protocol = mkXmlAttrList "value" value.protocols;
                  icmp-block = mkXmlAttrList "name" value.icmpBlocks;
                  masquerade = mkXmlTag value.masquerade;
                  forward-port = builtins.map toXmlAttrs (builtins.map filterNullAttrs value.forwardPorts);
                  source-port = builtins.map toXmlAttrs value.sourcePorts;
                  rule = value.rules;
                }
              ]
            );
        };
      }
    ) cfg.zones;
  };
}
