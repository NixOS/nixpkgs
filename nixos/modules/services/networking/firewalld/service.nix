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
    mkXmlAttr
    portProtocolOptions
    toXmlAttrs
    ;
  inherit (lib) mkOption;
  inherit (lib.types)
    attrsOf
    listOf
    nonEmptyStr
    nullOr
    strMatching
    submodule
    ;
in
{
  options.services.firewalld.services = mkOption {
    description = ''
      firewalld service configuration files. See {manpage}`firewalld.service(5)`.
    '';
    default = { };
    type = attrsOf (submodule {
      options = {
        version = mkOption {
          type = nullOr nonEmptyStr;
          description = "Version of the service.";
          default = null;
        };
        short = mkOption {
          type = nullOr nonEmptyStr;
          description = "Short description for the service.";
          default = null;
        };
        description = mkOption {
          type = nullOr nonEmptyStr;
          description = "Description for the service.";
          default = null;
        };
        ports = mkOption {
          type = listOf (submodule portProtocolOptions);
          description = "Ports of the service.";
          default = [ ];
        };
        protocols = mkOption {
          type = listOf nonEmptyStr;
          description = "Protocols for the service.";
          default = [ ];
        };
        sourcePorts = mkOption {
          type = listOf (submodule portProtocolOptions);
          description = "Source ports for the service.";
          default = [ ];
        };
        destination = mkOption {
          type = submodule {
            options = {
              ipv4 = mkOption {
                type = nullOr (strMatching "([0-9]{1,3}\\.){3}[0-9]{1,3}(/[0-9]{1,2})?");
                description = "IPv4 destination.";
                default = null;
              };
              ipv6 = mkOption {
                type = nullOr (strMatching "[0-9A-Fa-f:]{3,39}(/[0-9]{1,3})?");
                description = "IPv6 destination.";
                default = null;
              };
            };
          };
          description = "Destinations for the service.";
          default = { };
        };
        includes = mkOption {
          type = listOf nonEmptyStr;
          description = "Services to include for the service.";
          default = [ ];
        };
        helpers = mkOption {
          type = listOf nonEmptyStr;
          description = "Helpers for the service.";
          default = [ ];
        };
      };
    });
  };

  config = lib.mkIf cfg.enable {
    environment.etc = lib.mapAttrs' (
      name: value:
      lib.nameValuePair "firewalld/services/${name}.xml" {
        source = format.generate "firewalld-service-${name}.xml" {
          service = filterNullAttrs (
            lib.mergeAttrsList [
              (toXmlAttrs { inherit (value) version; })
              {
                inherit (value) short description;
                port = builtins.map toXmlAttrs value.ports;
                protocol = builtins.map (mkXmlAttr "value") value.protocols;
                source-port = builtins.map toXmlAttrs value.sourcePorts;
                destination = toXmlAttrs value.destination;
                include = builtins.map (mkXmlAttr "service") value.includes;
                helper = builtins.map (mkXmlAttr "name") value.helpers;
              }
            ]
          );
        };
      }
    ) cfg.services;
  };
}
