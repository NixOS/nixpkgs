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

      preliminarySelfsigned = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether a preliminary self-signed certificate should be generated before
          doing ACME requests. This can be useful when certificates are required in
          a webserver, but ACME needs the webserver to make its requests.

          With preliminary self-signed certificate the webserver can be started and
          can later reload the correct ACME certificates.
        '';
      };

      certs = mkOption {
        default = { };
        type = with types; loaOf (submodule certOpts);
        description = ''
          Attribute set of certificates to get signed and renewed.
        '';
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

      systemd.services = let
          services = concatLists servicesLists;
          servicesLists = mapAttrsToList certToServices cfg.certs;
          certToServices = cert: data:
              let
                cpath = "${cfg.directory}/${cert}";
                rights = if data.allowKeysForGroup then "750" else "700";
                cmdline = [ "-v" "-d" cert "--default_root" data.webroot "--valid_min" cfg.validMin ]
                          ++ optionals (data.email != null) [ "--email" data.email ]
                          ++ concatMap (p: [ "-f" p ]) data.plugins
                          ++ concatLists (mapAttrsToList (name: root: [ "-d" (if root == null then name else "${name}:${root}")]) data.extraDomains);
                acmeService = {
                  description = "Renew ACME Certificate for ${cert}";
                  after = [ "network.target" "network-online.target" ];
                  wants = [ "network-online.target" ];
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
                    chown '${data.user}:${data.group}' '${cfg.directory}'
                    if [ ! -d '${cpath}' ]; then
                      mkdir '${cpath}'
                    fi
                    chmod ${rights} '${cpath}'
                    chown -R '${data.user}:${data.group}' '${cpath}'
                  '';
                  script = ''
                    cd '${cpath}'
                    set +e
                    simp_le ${escapeShellArgs cmdline}
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

                  before = [ "acme-certificates.target" ];
                  wantedBy = [ "acme-certificates.target" ];
                };
                selfsignedService = {
                  description = "Create preliminary self-signed certificate for ${cert}";
                  preStart = ''
                      if [ ! -d '${cpath}' ]
                      then
                        mkdir -p '${cpath}'
                        chmod ${rights} '${cpath}'
                        chown '${data.user}:${data.group}' '${cpath}'
                      fi
                  '';
                  script = 
                    ''
                      # Create self-signed key
                      workdir="/run/acme-selfsigned-${cert}"
                      ${pkgs.openssl.bin}/bin/openssl genrsa -des3 -passout pass:x -out $workdir/server.pass.key 2048
                      ${pkgs.openssl.bin}/bin/openssl rsa -passin pass:x -in $workdir/server.pass.key -out $workdir/server.key
                      ${pkgs.openssl.bin}/bin/openssl req -new -key $workdir/server.key -out $workdir/server.csr \
                        -subj "/C=UK/ST=Warwickshire/L=Leamington/O=OrgName/OU=IT Department/CN=example.com"
                      ${pkgs.openssl.bin}/bin/openssl x509 -req -days 1 -in $workdir/server.csr -signkey $workdir/server.key -out $workdir/server.crt

                      # Move key to destination
                      mv $workdir/server.key ${cpath}/key.pem
                      mv $workdir/server.crt ${cpath}/fullchain.pem

                      # Clean up working directory
                      rm $workdir/server.csr
                      rm $workdir/server.pass.key

                      # Give key acme permissions
                      chmod ${rights} '${cpath}/key.pem'
                      chown '${data.user}:${data.group}' '${cpath}/key.pem'
                      chmod ${rights} '${cpath}/fullchain.pem'
                      chown '${data.user}:${data.group}' '${cpath}/fullchain.pem'
                    '';
                  serviceConfig = {
                    Type = "oneshot";
                    RuntimeDirectory = "acme-selfsigned-${cert}";
                    PermissionsStartOnly = true;
                    User = data.user;
                    Group = data.group;
                  };
                  unitConfig = {
                    # Do not create self-signed key when key already exists
                    ConditionPathExists = "!${cpath}/key.pem";
                  };
                  before = [
                    "acme-selfsigned-certificates.target"
                  ];
                  wantedBy = [
                    "acme-selfsigned-certificates.target"
                  ];
                };
              in (
                [ { name = "acme-${cert}"; value = acmeService; } ]
                ++
                (if cfg.preliminarySelfsigned
                  then [ { name = "acme-selfsigned-${cert}"; value = selfsignedService; } ]
                  else []
                )
              );
          servicesAttr = listToAttrs services;
          nginxAttr = {
            nginx = {
              after = [ "acme-selfsigned-certificates.target" ];
              wants = [ "acme-selfsigned-certificates.target" "acme-certificates.target" ];
            };
          };
        in
          servicesAttr //
          (if config.services.nginx.enable then nginxAttr else {});

      systemd.timers = flip mapAttrs' cfg.certs (cert: data: nameValuePair
        ("acme-${cert}")
        ({
          description = "Renew ACME Certificate for ${cert}";
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = cfg.renewInterval;
            Unit = "acme-${cert}.service";
            Persistent = "yes";
          };
        })
      );

      systemd.targets."acme-selfsigned-certificates" = mkIf cfg.preliminarySelfsigned {};
      systemd.targets."acme-certificates" = {};
    })

  ];

  meta = {
    maintainers = with lib.maintainers; [ abbradar fpletz globin ];
    doc = ./acme.xml;
  };
}
