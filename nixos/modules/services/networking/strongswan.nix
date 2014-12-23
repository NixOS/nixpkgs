{ config, lib, pkgs, ... }:

let

  inherit (builtins) toFile;
  inherit (lib) concatMapStringsSep concatStringsSep mapAttrsToList
                mkIf mkEnableOption mkOption types;

  cfg = config.services.strongswan;

  ipsecSecrets = secrets: toFile "ipsec.secrets" (
    concatMapStringsSep "\n" (f: "include ${f}") secrets
  );

  ipsecConf = {setup, connections, ca}:
    let
      # https://wiki.strongswan.org/projects/strongswan/wiki/IpsecConf
      makeSections = type: sections: concatStringsSep "\n\n" (
        mapAttrsToList (sec: attrs:
          "${type} ${sec}\n" +
            (concatStringsSep "\n" ( mapAttrsToList (k: v: "  ${k}=${v}") attrs ))
        ) sections
      );
      setupConf       = makeSections "config" { inherit setup; };
      connectionsConf = makeSections "conn" connections;
      caConf          = makeSections "ca" ca;

    in
    builtins.toFile "ipsec.conf" ''
      ${setupConf}
      ${connectionsConf}
      ${caConf}
    '';

  strongswanConf = {setup, connections, ca, secrets}: toFile "strongswan.conf" ''
    charon {
      plugins {
        stroke {
          secrets_file = ${ipsecSecrets secrets}
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
      type = types.listOf types.path;
      default = [];
      example = [ "/run/keys/ipsec-foo.secret" ];
      description = ''
        A list of paths to IPSec secret files. These
        files will be included into the main ipsec.secrets file with
        the <literal>include</literal> directive. It is safer if these
        paths are absolute.
      '';
    };

    setup = mkOption {
      type = types.attrsOf types.str;
      default = {};
      example = { cachecrls = "yes"; strictcrlpolicy = "yes"; };
      description = ''
        A set of options for the ‘config setup’ section of the
        <filename>ipsec.conf</filename> file. Defines general
        configuration parameters.
      '';
    };

    connections = mkOption {
      type = types.attrsOf (types.attrsOf types.str);
      default = {};
      example = {
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
      };
      description = ''
        A set of connections and their options for the ‘conn xxx’
        sections of the <filename>ipsec.conf</filename> file.
      '';
    };

    ca = mkOption {
      type = types.attrsOf (types.attrsOf types.str);
      default = {};
      example = {
        strongswan = {
          auto   = "add";
          cacert = "/run/keys/strongswanCert.pem";
          crluri = "http://crl2.strongswan.org/strongswan.crl";
        };
      };
      description = ''
        A set of CAs (certification authorities) and their options for
        the ‘ca xxx’ sections of the <filename>ipsec.conf</filename>
        file.
      '';
    };
  };

  config = with cfg; mkIf enable {
    systemd.services.strongswan = {
      description = "strongSwan IPSec Service";
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [ kmod iproute iptables utillinux ]; # XXX Linux
      wants = [ "keys.target" ];
      after = [ "network.target" "keys.target" ];
      environment = {
        STRONGSWAN_CONF = strongswanConf { inherit setup connections ca secrets; };
      };
      serviceConfig = {
        ExecStart  = "${pkgs.strongswan}/sbin/ipsec start --nofork";
      };
    };
  };
}

