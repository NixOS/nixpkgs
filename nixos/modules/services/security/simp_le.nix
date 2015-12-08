{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.simp_le;

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

      user = mkOption {
        type = types.str;
        default = "root";
        description = "User under which simp_le would run.";
      };

      group = mkOption {
        type = types.str;
        default = "root";
        description = "Group under which simp_le would run.";
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
          "cert.der" "cert.pem" "chain.der" "chain.pem" "external_pem.sh"
          "fullchain.der" "fullchain.pem" "key.der" "key.pem" "account_key.json"
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
    services.simp_le = {
      directory = mkOption {
        default = "/var/lib/simp_le";
        type = types.str;
        description = ''
          Directory where certs and other state will be stored by default.
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
  config = mkIf (cfg.certs != { }) {

    systemd.services = flip mapAttrs' cfg.certs (cert: data:
      let
        cpath = "${cfg.directory}/${cert}";
        cmdline = [ "-v" "-d" cert "--default_root" data.webroot "--valid_min" data.validMin ]
                  ++ optionals (data.email != null) [ "--email" data.email ]
                  ++ concatMap (p: [ "-f" p ]) data.plugins
                  ++ concatLists (mapAttrsToList (name: root: [ "-d" (if root == null then name else "${name}:${root}")]) data.extraDomains);

      in nameValuePair
      ("simp_le-${cert}")
      ({
        description = "simp_le cert renewal for ${cert}";
        after = [ "network.target" ];
        serviceConfig = {
          Type = "oneshot";
          SuccessExitStatus = [ "0" "1" ];
        };
        path = [ pkgs.simp_le pkgs.sudo ];
        preStart = ''
          mkdir -p '${cfg.directory}'
          if [ ! -d '${cpath}' ]; then
            mkdir -m 700 '${cpath}'
            chown '${data.user}:${data.group}' '${cpath}'
          fi
        '';
        script = ''
          cd '${cpath}'
          set +e
          sudo -u '${data.user}' -- simp_le ${concatMapStringsSep " " (arg: escapeShellArg (toString arg)) cmdline}
          EXITCODE=$?
          set -e
          if [ "$EXITCODE" = "0" ]; then
            ${data.postRun}
          else
            exit "$EXITCODE"
          fi
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
