{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.security.acme;

  certOpts = { ... }: {
    options = {
      webroot = mkOption {
        type = types.str;
        description = ''
          Where the webroot of the HTTP vhost is located.
          <filename>.well-known/acme-challenge/</filename> directory
          will be created automatically if it doesn't exist.
          <literal>http://example.org/.well-known/acme-challenge/</literal> must also
          be available (notice unencrypted HTTP).
        '';
      };

      email = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Contact email address for the CA to be able to reach you.";
      };

      user = mkOption {
        type = types.str;
        default = "root";
        description = "User running the ACME client.";
      };

      group = mkOption {
        type = types.str;
        default = "root";
        description = "Group running the ACME client.";
      };

      allowKeysForGroup = mkOption {
        type = types.bool;
        default = false;
        description = "Give read permissions to the specified group to read SSL private certificates.";
      };

      postRun = mkOption {
        type = types.lines;
        default = "";
        example = "systemctl reload nginx.service";
        description = ''
          Commands to run after certificates are re-issued. Typically
          the web server and other servers using certificates need to
          be reloaded.
        '';
      };

      plugins = mkOption {
        type = types.listOf (types.enum [
          "cert.der" "cert.pem" "chain.pem" "external.sh"
          "fullchain.pem" "full.pem" "key.der" "key.pem" "account_key.json"
        ]);
        default = [ "fullchain.pem" "key.pem" "account_key.json" ];
        description = ''
          Plugins to enable. With default settings simp_le will
          store public certificate bundle in <filename>fullchain.pem</filename>
          and private key in <filename>key.pem</filename> in its state directory.
        '';
      };

      extraDomains = mkOption {
        type = types.attrsOf (types.nullOr types.str);
        default = {};
        example = {
          "example.org" = "/srv/http/nginx";
          "mydomain.org" = null;
        };
        description = ''
          Extra domain names for which certificates are to be issued, with their
          own server roots if needed.
        '';
      };
    };
  };

in

{

  ###### interface

  options = {
    security.acme = {
      directory = mkOption {
        default = "/var/lib/acme";
        type = types.str;
        description = ''
          Directory where certs and other state will be stored by default.
        '';
      };

      validMin = mkOption {
        type = types.int;
        default = 30 * 24 * 3600;
        description = "Minimum remaining validity before renewal in seconds.";
      };

      renewInterval = mkOption {
        type = types.str;
        default = "weekly";
        description = ''
          Systemd calendar expression when to check for renewal. See
          <citerefentry><refentrytitle>systemd.time</refentrytitle>
          <manvolnum>5</manvolnum></citerefentry>.
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
          "example.com" = {
            webroot = "/var/www/challenges/";
            email = "foo@example.com";
            extraDomains = { "www.example.com" = null; "foo.example.com" = "/var/www/foo/"; };
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
  config = mkMerge [
    (mkIf (cfg.certs != { }) {

      systemd.services = flip mapAttrs' cfg.certs (cert: data:
        let
          cpath = "${cfg.directory}/${cert}";
          rights = if data.allowKeysForGroup then "750" else "700";
          cmdline = [ "-v" "-d" cert "--default_root" data.webroot "--valid_min" cfg.validMin ]
                    ++ optionals (data.email != null) [ "--email" data.email ]
                    ++ concatMap (p: [ "-f" p ]) data.plugins
                    ++ concatLists (mapAttrsToList (name: root: [ "-d" (if root == null then name else "${name}:${root}")]) data.extraDomains);

        in nameValuePair
        ("acme-${cert}")
        ({
          description = "Renew ACME Certificate for ${cert}";
          after = [ "network.target" ];
          serviceConfig = {
            Type = "oneshot";
            SuccessExitStatus = [ "0" "1" ];
            PermissionsStartOnly = true;
            User = data.user;
            Group = data.group;
            PrivateTmp = true;
          };
          path = [ pkgs.simp_le ];
          preStart = ''
            mkdir -p '${cfg.directory}'
            if [ ! -d '${cpath}' ]; then
              mkdir '${cpath}'
            fi
            chmod ${rights} '${cpath}'
            chown -R '${data.user}:${data.group}' '${cpath}'
          '';
          script = ''
            cd '${cpath}'
            set +e
            simp_le ${concatMapStringsSep " " (arg: escapeShellArg (toString arg)) cmdline}
            EXITCODE=$?
            set -e
            echo "$EXITCODE" > /tmp/lastExitCode
            exit "$EXITCODE"
          '';
          postStop = ''
            if [ -e /tmp/lastExitCode ] && [ "$(cat /tmp/lastExitCode)" = "0" ]; then
              echo "Executing postRun hook..."
              ${data.postRun}
            fi
          '';
        })
      );

      systemd.timers = flip mapAttrs' cfg.certs (cert: data: nameValuePair
        ("acme-${cert}")
        ({
          description = "Renew ACME Certificate for ${cert}";
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = cfg.renewInterval;
            Unit = "acme-${cert}.service";
          };
        })
      );
    })

    { meta.maintainers = with lib.maintainers; [ abbradar fpletz globin ];
      meta.doc = ./acme.xml;
    }
  ];

}
