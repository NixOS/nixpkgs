{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.security.acme;

  certOpts = { name, ... }: {
    options = {
      webroot = mkOption {
        type = types.str;
        example = "/var/lib/acme/acme-challenges";
        description = ''
          Where the webroot of the HTTP vhost is located.
          <filename>.well-known/acme-challenge/</filename> directory
          will be created below the webroot if it doesn't exist.
          <literal>http://example.org/.well-known/acme-challenge/</literal> must also
          be available (notice unencrypted HTTP).
        '';
      };

      domain = mkOption {
        type = types.str;
        default = name;
        description = "Domain to fetch certificate for (defaults to the entry name)";
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
        description = ''
          Give read permissions to the specified group
          (<option>security.acme.cert.&lt;name&gt;.group</option>) to read SSL private certificates.
        '';
      };

      postRun = mkOption {
        type = types.lines;
        default = "";
        example = "systemctl reload nginx.service";
        description = ''
          Commands to run after new certificates go live. Typically
          the web server and other servers using certificates need to
          be reloaded.

          Executed in the same directory with the new certificate.
        '';
      };

      plugins = mkOption {
        type = types.listOf (types.enum [
          "cert.der" "cert.pem" "chain.pem" "external.sh"
          "fullchain.pem" "full.pem" "key.der" "key.pem" "account_key.json" "account_reg.json"
        ]);
        default = [ "fullchain.pem" "full.pem" "key.pem" "account_key.json" "account_reg.json" ];
        description = ''
          Plugins to enable. With default settings simp_le will
          store public certificate bundle in <filename>fullchain.pem</filename>,
          private key in <filename>key.pem</filename> and those two previous
          files combined in <filename>full.pem</filename> in its state directory.
        '';
      };

      directory = mkOption {
        type = types.str;
        readOnly = true;
        default = "/var/lib/acme/${name}";
        description = "Directory where certificate and other state is stored.";
      };

      extraDomains = mkOption {
        type = types.attrsOf (types.nullOr types.str);
        default = {};
        example = literalExample ''
          {
            "example.org" = "/srv/http/nginx";
            "mydomain.org" = null;
          }
        '';
        description = ''
          A list of extra domain names, which are included in the one certificate to be issued, with their
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
          <manvolnum>7</manvolnum></citerefentry>.
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

      production = mkOption {
        type = types.bool;
        default = true;
        description = ''
          If set to true, use Let's Encrypt's production environment
          instead of the staging environment. The main benefit of the
          staging environment is to get much higher rate limits.

          See
          <literal>https://letsencrypt.org/docs/staging-environment</literal>
          for more detail.
        '';
      };

      certs = mkOption {
        default = { };
        type = with types; attrsOf (submodule certOpts);
        description = ''
          Attribute set of certificates to get signed and renewed. Creates
          <literal>acme-''${cert}.{service,timer}</literal> systemd units for
          each certificate defined here. Other services can add dependencies
          to those units if they rely on the certificates being present,
          or trigger restarts of the service if certificates get renewed.
        '';
        example = literalExample ''
          {
            "example.com" = {
              webroot = "/var/www/challenges/";
              email = "foo@example.com";
              extraDomains = { "www.example.com" = null; "foo.example.com" = "/var/www/foo/"; };
            };
            "bar.example.com" = {
              webroot = "/var/www/challenges/";
              email = "bar@example.com";
            };
          }
        '';
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
                lpath = "acme/${cert}";
                rights = if data.allowKeysForGroup then "750" else "700";
                cmdline = [ "-v" "-d" data.domain "--default_root" data.webroot "--valid_min" cfg.validMin ]
                          ++ optionals (data.email != null) [ "--email" data.email ]
                          ++ concatMap (p: [ "-f" p ]) data.plugins
                          ++ concatLists (mapAttrsToList (name: root: [ "-d" (if root == null then name else "${name}:${root}")]) data.extraDomains)
                          ++ optionals (!cfg.production) ["--server" "https://acme-staging.api.letsencrypt.org/directory"];
                acmeService = {
                  description = "Renew ACME Certificate for ${cert}";
                  after = [ "network.target" "network-online.target" ];
                  wants = [ "network-online.target" ];
                  # simp_le uses requests, which uses certifi under the hood,
                  # which doesn't respect the system trust store.
                  # At least in the acme test, we provision a fake CA, impersonating the LE endpoint.
                  # REQUESTS_CA_BUNDLE is a way to teach python requests to use something else
                  environment.REQUESTS_CA_BUNDLE = "/etc/ssl/certs/ca-certificates.crt";
                  serviceConfig = {
                    Type = "oneshot";
                    SuccessExitStatus = [ "0" "1" ];
                    User = data.user;
                    Group = data.group;
                    PrivateTmp = true;
                    StateDirectory = lpath;
                    StateDirectoryMode = rights;
                    WorkingDirectory = "/var/lib/${lpath}";
                    ExecStart = "${pkgs.simp_le}/bin/simp_le ${escapeShellArgs cmdline}";
                    ExecStopPost =
                      let
                        script = pkgs.writeScript "acme-post-stop" ''
                          #!${pkgs.runtimeShell} -e
                          ${data.postRun}
                        '';
                      in
                        "+${script}";
                  };

                };
                selfsignedService = {
                  description = "Create preliminary self-signed certificate for ${cert}";
                  path = [ pkgs.openssl ];
                  script =
                    ''
                      workdir="$(mktemp -d)"

                      # Create CA
                      openssl genrsa -des3 -passout pass:xxxx -out $workdir/ca.pass.key 2048
                      openssl rsa -passin pass:xxxx -in $workdir/ca.pass.key -out $workdir/ca.key
                      openssl req -new -key $workdir/ca.key -out $workdir/ca.csr \
                        -subj "/C=UK/ST=Warwickshire/L=Leamington/O=OrgName/OU=Security Department/CN=example.com"
                      openssl x509 -req -days 1 -in $workdir/ca.csr -signkey $workdir/ca.key -out $workdir/ca.crt

                      # Create key
                      openssl genrsa -des3 -passout pass:xxxx -out $workdir/server.pass.key 2048
                      openssl rsa -passin pass:xxxx -in $workdir/server.pass.key -out $workdir/server.key
                      openssl req -new -key $workdir/server.key -out $workdir/server.csr \
                        -subj "/C=UK/ST=Warwickshire/L=Leamington/O=OrgName/OU=IT Department/CN=example.com"
                      openssl x509 -req -days 1 -in $workdir/server.csr -CA $workdir/ca.crt \
                        -CAkey $workdir/ca.key -CAserial $workdir/ca.srl -CAcreateserial \
                        -out $workdir/server.crt

                      # Copy key to destination
                      cp $workdir/server.key /var/lib/${lpath}/key.pem

                      # Create fullchain.pem (same format as "simp_le ... -f fullchain.pem" creates)
                      cat $workdir/{server.crt,ca.crt} > "/var/lib/${lpath}/fullchain.pem"

                      # Create full.pem for e.g. lighttpd
                      cat $workdir/{server.key,server.crt,ca.crt} > "/var/lib/${lpath}/full.pem"

                      # Give key acme permissions
                      chown '${data.user}:${data.group}' "/var/lib/${lpath}/"{key,fullchain,full}.pem
                      chmod ${rights} "/var/lib/${lpath}/"{key,fullchain,full}.pem
                    '';
                  serviceConfig = {
                    Type = "oneshot";
                    PrivateTmp = true;
                    StateDirectory = lpath;
                    User = data.user;
                    Group = data.group;
                  };
                  unitConfig = {
                    # Do not create self-signed key when key already exists
                    ConditionPathExists = "!/var/lib/${lpath}/key.pem";
                  };
                };
              in (
                [ { name = "acme-${cert}"; value = acmeService; } ]
                ++ optional cfg.preliminarySelfsigned { name = "acme-selfsigned-${cert}"; value = selfsignedService; }
              );
          servicesAttr = listToAttrs services;
        in
          servicesAttr;

      systemd.tmpfiles.rules =
        flip mapAttrsToList cfg.certs
        (cert: data: "d ${data.webroot}/.well-known/acme-challenge - ${data.user} ${data.group}");

      systemd.timers = flip mapAttrs' cfg.certs (cert: data: nameValuePair
        ("acme-${cert}")
        ({
          description = "Renew ACME Certificate for ${cert}";
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = cfg.renewInterval;
            Unit = "acme-${cert}.service";
            Persistent = "yes";
            AccuracySec = "5m";
            RandomizedDelaySec = "1h";
          };
        })
      );

      systemd.targets.acme-selfsigned-certificates = mkIf cfg.preliminarySelfsigned {};
      systemd.targets.acme-certificates = {};
    })

  ];

  meta = {
    maintainers = with lib.maintainers; [ abbradar fpletz globin ];
    doc = ./acme.xml;
  };
}
