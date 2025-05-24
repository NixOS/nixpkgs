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
          description = "";
          default = null;
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
        sourcePorts = mkOption {
          type = listOf (submodule portProtocolOptions);
          description = "";
          default = [ ];
        };
        destination = mkOption {
          type = submodule {
            options = {
              ipv4 = mkOption {
                type = nullOr (strMatching "([0-9]{1,3}\\.){3}[0-9]{1,3}(/[0-9]{1,2})?");
                description = "";
                default = null;
              };
              ipv6 = mkOption {
                type = nullOr (strMatching "[0-9A-Fa-f:]{3,39}(/[0-9]{1,3})?");
                description = "";
                default = null;
              };
            };
          };
          description = "";
          default = { };
        };
        includes = mkOption {
          type = listOf nonEmptyStr;
          description = "";
          default = [ ];
        };
        helpers = mkOption {
          type = listOf nonEmptyStr;
          description = "";
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
