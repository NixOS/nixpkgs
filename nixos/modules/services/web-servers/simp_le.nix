{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.simp_le;

  cmdline = toString (
    optionals (cfg.email != null) [ "--email" (escapeShellArg cfg.email) ]
    ++ concatMap (x: [ "-f" x ]) cfg.plugins
    ++ concatLists (mapAttrsToList (name: root: [ "-d" "${name}:${escapeShellArg root}" ]) cfg.domains)
  );

in {

  options = {
    services.simp_le = {
      email = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Email address of domains administrator; used by CA to send
          warning emails.
        '';
      };

      plugins = mkOption {
        type = types.listOf types.str;
        default = [ "account_key.json" "key.pem" "fullchain.pem" ];
        description = ''
          Input/output plugins for simp_le. With default settings simp_le will
          store public certificate bundle in <filename>fullchain.pem</filename>
          and private key in <filename>key.pem</filename> in its state directory.
        '';
      };

      domains = mkOption {
        type = types.attrsOf types.str;
        example = {
          "example.org" = "/srv/http/nginx";
          "mydomain.org" = "/srv/http/mydomain.org/nginx";
        };
        description = ''
          Domain names for which certificates are to be issued, with their
          server roots. <filename>.well-known/acme-challenge/</filename> directories
          will be created automatically in those roots if they don't exist.
          <literal>http://example.org/.well-known/acme-challenge/</literal> must also
          be available (notice unencrypted HTTP).
        '';
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

      user = mkOption {
        type = types.str;
        default = "root";
        description = ''
          User under which simp_le would run.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "root";
        description = ''
          Group under which simp_le would run.
        '';
      };

      period = mkOption {
        type = types.str;
        default = "weekly";
        description = ''
          Interval at which simp_le is runned.
        '';
      };

      stateDir = mkOption {
        type = types.str;
        default = "/var/lib/simp_le";
        description = ''
          simp_le state directory, including certificate storage.
          It is readable only by the simp_le user by default.

          Issued certificates will be stored in this directory in format
          depending on plugins.
        '';
        apply = escapeShellArg;
      };
    };
  };

  config = mkIf (builtins.length (builtins.attrNames cfg.domains) > 0) {

    systemd.services."simp_le" = {
      description = "simp_le ACME client";
      requires    = [ "network.target" ];
      serviceConfig.Type = "oneshot";

      path = [ pkgs.pythonPackages.simp_le pkgs.sudo ];
      script = ''
        if [ ! -d ${cfg.stateDir} ]; then
          mkdir -p -m 0700 ${cfg.stateDir}
          chown ${cfg.user}:${cfg.group} ${cfg.stateDir}
        fi

        cd ${cfg.stateDir}
        set +e
        sudo -u ${cfg.user} simp_le ${cmdline}
        ERRORCODE=$?
        [ "$ERRORCODE" == "1" ] && exit 0
        [ "$ERRORCODE" == "2" ] && exit 1
        set -e
        ${cfg.postRun}
      '';
    };

    systemd.timers."simp_le" = {
      timerConfig.OnCalendar = cfg.period;
      wantedBy = [ "timers.target" ];
    };

  };
}
