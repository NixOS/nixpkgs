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
      firewalld zone configuration files. See {manpage}`firewalld.zone(5)`.
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
          description = "";
          default = null;
        };
        target = mkOption {
          type = enum [
            "ACCEPT"
            "%%REJECT%%"
            "DROP"
          ];
          description = "";
          default = "%%REJECT%%";
        };
        ingressPriority = mkOption {
          type = nullOr ints.s16;
          description = "";
          default = null;
        };
        egressPriority = mkOption {
          type = nullOr ints.s16;
          description = "";
          default = null;
        };
        interfaces = mkOption {
          type = listOf nonEmptyStr;
          description = "";
          default = [ ];
        };
        sources = mkOption {
          type = listOf (attrTag {
            address = mkOption {
              type = nonEmptyStr;
              description = "";
            };
            mac = mkOption {
              type = strMatching "([[:xdigit:]]{2}:){5}[[:xdigit:]]{2}";
              description = "";
            };
            ipset = mkOption {
              type = nonEmptyStr;
              description = "";
            };
          });
          description = "";
          default = [ ];
        };
        icmpBlockInversion = mkOption {
          type = bool;
          description = "";
          default = false;
        };
        forward = mkOption {
          type = bool;
          description = "";
          default = false;
        };
        short = mkOption {
          type = nullOr nonEmptyStr;
          description = "";
          default = null;
        };
        description = mkOption {
          type = nullOr nonEmptyStr;
          description = "";
          default = null;
        };
        services = mkOption {
          type = listOf nonEmptyStr;
          description = "";
          default = [ ];
        };
        ports = mkOption {
          type = listOf (submodule portProtocolOptions);
          description = "";
          default = [ ];
        };
        protocols = mkOption {
          type = listOf nonEmptyStr;
          description = "";
          default = [ ];
        };
        icmpBlocks = mkOption {
          type = listOf nonEmptyStr;
          description = "";
          default = [ ];
        };
        masquerade = mkOption {
          type = bool;
          description = "";
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
                description = "";
                default = null;
              };
            };
          });
          description = "";
          default = [ ];
        };
        sourcePorts = mkOption {
          type = listOf (submodule portProtocolOptions);
          description = "";
          default = [ ];
        };
        rules = mkOption {
          type = listOf (format.type);
          description = "";
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
