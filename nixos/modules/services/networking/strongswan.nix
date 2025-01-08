{
  config,
  lib,
  pkgs,
  ...
}:

let

  inherit (builtins) toFile;

  cfg = config.services.strongswan;

  ipsecSecrets = secrets: lib.concatMapStrings (f: "include ${f}\n") secrets;

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
        lib.concatStringsSep "\n\n" (
          lib.mapAttrsToList (
            sec: attrs:
            "${type} ${sec}\n" + (lib.concatStringsSep "\n" (lib.mapAttrsToList (k: v: "  ${k}=${v}") attrs))
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
        ${lib.optionalString managePlugins "load_modular = no"}
        ${lib.optionalString managePlugins ("load = " + (lib.concatStringsSep " " enabledPlugins))}
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
    enable = lib.mkEnableOption "strongSwan";

    secrets = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "/run/keys/ipsec-foo.secret" ];
      description = ''
        A list of paths to IPSec secret files. These
        files will be included into the main ipsec.secrets file with
        the `include` directive. It is safer if these
        paths are absolute.
      '';
    };

    setup = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
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

    connections = lib.mkOption {
      type = lib.types.attrsOf (lib.types.attrsOf lib.types.str);
      default = { };
      example = lib.literalExpression ''
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

    ca = lib.mkOption {
      type = lib.types.attrsOf (lib.types.attrsOf lib.types.str);
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

    managePlugins = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        If set to true, this option will disable automatic plugin loading and
        then tell strongSwan to enable the plugins specified in the
        {option}`enabledPlugins` option.
      '';
    };

    enabledPlugins = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        A list of additional plugins to enable if
        {option}`managePlugins` is true.
      '';
    };
  };

  config =
    lib.mkIf cfg.enable {

      # here we should use the default strongswan ipsec.secrets and
      # append to it (default one is empty so not a pb for now)
      environment.etc."ipsec.secrets".text = ipsecSecrets cfg.secrets;

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
            inherit (cfg)
              setup
              connections
              ca
              managePlugins
              enabledPlugins
              ;
            secretsFile = "/etc/ipsec.secrets";
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
