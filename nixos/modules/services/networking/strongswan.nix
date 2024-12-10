{
  config,
  lib,
  pkgs,
  ...
}:

let

  inherit (builtins) toFile;
  inherit (lib)
    concatMapStringsSep
    concatStringsSep
    mapAttrsToList
    mkIf
    mkEnableOption
    mkOption
    types
    literalExpression
    optionalString
    ;

  cfg = config.services.strongswan;

  ipsecSecrets =
    secrets: toFile "ipsec.secrets" (concatMapStringsSep "\n" (f: "include ${f}") secrets);

  ipsecConf =
    {
      setup,
      connections,
      ca,
    }:
    let
      # https://wiki.strongswan.org/projects/strongswan/wiki/IpsecConf
      makeSections =
        type: sections:
        concatStringsSep "\n\n" (
          mapAttrsToList (
            sec: attrs:
            "${type} ${sec}\n" + (concatStringsSep "\n" (mapAttrsToList (k: v: "  ${k}=${v}") attrs))
          ) sections
        );
      setupConf = makeSections "config" { inherit setup; };
      connectionsConf = makeSections "conn" connections;
      caConf = makeSections "ca" ca;

    in
    builtins.toFile "ipsec.conf" ''
      ${setupConf}
      ${connectionsConf}
      ${caConf}
    '';

  strongswanConf =
    {
      setup,
      connections,
      ca,
      secretsFile,
      managePlugins,
      enabledPlugins,
    }:
    toFile "strongswan.conf" ''
      charon {
        ${optionalString managePlugins "load_modular = no"}
        ${optionalString managePlugins ("load = " + (concatStringsSep " " enabledPlugins))}
        plugins {
          stroke {
            secrets_file = ${secretsFile}
          }
        }
      }

      starter {
        config_file = ${ipsecConf { inherit setup connections ca; }}
      }
    '';

in
{
  options.services.strongswan = {
    enable = mkEnableOption "strongSwan";

    secrets = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "/run/keys/ipsec-foo.secret" ];
      description = ''
        A list of paths to IPSec secret files. These
        files will be included into the main ipsec.secrets file with
        the `include` directive. It is safer if these
        paths are absolute.
      '';
    };

    setup = mkOption {
      type = types.attrsOf types.str;
      default = { };
      example = {
        cachecrls = "yes";
        strictcrlpolicy = "yes";
      };
      description = ''
        A set of options for the ‘config setup’ section of the
        {file}`ipsec.conf` file. Defines general
        configuration parameters.
      '';
    };

    connections = mkOption {
      type = types.attrsOf (types.attrsOf types.str);
      default = { };
      example = literalExpression ''
        {
          "%default" = {
            keyexchange = "ikev2";
            keyingtries = "1";
          };
          roadwarrior = {
            auto       = "add";
            leftcert   = "/run/keys/moonCert.pem";
            leftid     = "@moon.strongswan.org";
            leftsubnet = "10.1.0.0/16";
            right      = "%any";
          };
        }
      '';
      description = ''
        A set of connections and their options for the ‘conn xxx’
        sections of the {file}`ipsec.conf` file.
      '';
    };

    ca = mkOption {
      type = types.attrsOf (types.attrsOf types.str);
      default = { };
      example = {
        strongswan = {
          auto = "add";
          cacert = "/run/keys/strongswanCert.pem";
          crluri = "http://crl2.strongswan.org/strongswan.crl";
        };
      };
      description = ''
        A set of CAs (certification authorities) and their options for
        the ‘ca xxx’ sections of the {file}`ipsec.conf`
        file.
      '';
    };

    managePlugins = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If set to true, this option will disable automatic plugin loading and
        then tell strongSwan to enable the plugins specified in the
        {option}`enabledPlugins` option.
      '';
    };

    enabledPlugins = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        A list of additional plugins to enable if
        {option}`managePlugins` is true.
      '';
    };
  };

  config =
    with cfg;
    let
      secretsFile = ipsecSecrets cfg.secrets;
    in
    mkIf enable {

      # here we should use the default strongswan ipsec.secrets and
      # append to it (default one is empty so not a pb for now)
      environment.etc."ipsec.secrets".source = secretsFile;

      systemd.services.strongswan = {
        description = "strongSwan IPSec Service";
        wantedBy = [ "multi-user.target" ];
        path = with pkgs; [
          kmod
          iproute2
          iptables
          util-linux
        ]; # XXX Linux
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];
        environment = {
          STRONGSWAN_CONF = strongswanConf {
            inherit
              setup
              connections
              ca
              secretsFile
              managePlugins
              enabledPlugins
              ;
          };
        };
        serviceConfig = {
          ExecStart = "${pkgs.strongswan}/sbin/ipsec start --nofork";
        };
        preStart = ''
          # with 'nopeerdns' setting, ppp writes into this folder
          mkdir -m 700 -p /etc/ppp
        '';
      };
    };
}
