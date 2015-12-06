{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.simp_le;

  certOpts = { ... }: {
    options = {
      webroot = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Where the webroot of the HTTP vhost is located.";
      };

      validMin = mkOption {
        type = types.int;
        default = 2592000;
        description = "Minimum remaining validity before renewal in seconds.";
      };

      renewInterval = mkOption {
        type = types.str;
        default = "weekly";
        description = "Systemd calendar expression when to check for renewal. See systemd.time(7).";
      };

      email = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Contact email address for the CA to be able to reach you.";
      };

      plugins = mkOption {
        type = types.listOf (types.enum [
          "cert.der" "cert.pem" "chain.der" "chain.pem" "external_pem.sh"
          "fullchain.der" "fullchain.pem" "key.der" "key.pem"
        ]);
        default = [ "fullchain.pem" "key.pem" ];
        description = "Plugins to enable.";
      };

      extraDomains = mkOption {
        default = [ ];
        type = types.listOf types.str;
        description = "More domains to include in the certificate.";
        example = [ "example.com" "foo.example.com:/var/www/foo" ];
      };
    };
  };

in

{

  ###### interface

  options = {
    services.simp_le = {
      directory = mkOption {
        default = "/etc/ssl";
        type = types.str;
        description = ''
          Directory where certs will be stored by default.
        '';
      };

      certs = mkOption {
        default = { };
        type = types.loaOf types.optionSet;
        description = ''
          Attribute set of certificates to get signed and renewed.
        '';
        options = [ certOpts ];
        example = {
          "foo.example.com" = {
            webroot = "/var/www/challenges/";
            email = "foo@example.com";
            extraDomains = [ "www.example.com" "example.com" ];
          };
          "bar.example.com" = {
            webroot = "/var/www/challenges/";
            email = "bar@example.com";
          };
        };
      };
    };
  };

  ###### implementation
  config = mkIf (cfg.certs != { }) {

    systemd.services = flip mapAttrs' cfg.certs (cert: data: nameValuePair
      ("simp_le-${cert}")
      ({
        description = "simp_le cert renewal for ${cert}";
        after = [ "network.target" ];
        serviceConfig = {
          Type = "oneshot";
          SuccessExitStatus = "0 1";
        };
        preStart = ''
          mkdir -p "${cfg.directory}/${cert}"
        '';
        script = ''
          WEBROOT="${optionalString (data.webroot == null) data.webroot}"
          cd "${cfg.directory}/${cert}"
          ${pkgs.simp_le}/bin/simp_le -v \
            ${concatMapStringsSep " " (p: "-f ${p}") data.plugins} \
            -d ${cert} --default_root "$WEBROOT" \
            ${concatMapStringsSep " " (p: "-d ${p}") data.extraDomains} \
            ${optionalString (data.email != null) "--email ${data.email}"} \
            --valid_min ${toString data.validMin}
        '';
      })
    );

    systemd.timers = flip mapAttrs' cfg.certs (cert: data: nameValuePair
      ("simp_le-${cert}")
      ({
        description = "timer for simp_le cert renewal of ${cert}";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = data.renewInterval;
          Unit = "simp_le-${cert}.service";
        };
      })
    );

  };

}
