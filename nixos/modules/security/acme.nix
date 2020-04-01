{ config, lib, pkgs, ... }:
with lib;
let

  cfg = config.security.acme;

  certOpts = { name, ... }: {
    options = {
      webroot = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "/var/lib/acme/acme-challenges";
        description = ''
          Where the webroot of the HTTP vhost is located.
          <filename>.well-known/acme-challenge/</filename> directory
          will be created below the webroot if it doesn't exist.
          <literal>http://example.org/.well-known/acme-challenge/</literal> must also
          be available (notice unencrypted HTTP).
        '';
      };

      server = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          ACME Directory Resource URI. Defaults to let's encrypt
          production endpoint,
          https://acme-v02.api.letsencrypt.org/directory, if unset.
        '';
      };

      domain = mkOption {
        type = types.str;
        default = name;
        description = "Domain to fetch certificate for (defaults to the entry name)";
      };

      email = mkOption {
        type = types.nullOr types.str;
        default = cfg.email;
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

      keyType = mkOption {
        type = types.str;
        default = "ec384";
        description = ''
          Key type to use for private keys.
          For an up to date list of supported values check the --key-type option
          at https://go-acme.github.io/lego/usage/cli/#usage.
        '';
      };

      dnsProvider = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "route53";
        description = ''
          DNS Challenge provider. For a list of supported providers, see the "code"
          field of the DNS providers listed at https://go-acme.github.io/lego/dns/.
        '';
      };

      credentialsFile = mkOption {
        type = types.path;
        description = ''
          Path to an EnvironmentFile for the cert's service containing any required and
          optional environment variables for your selected dnsProvider.
          To find out what values you need to set, consult the documentation at
          https://go-acme.github.io/lego/dns/ for the corresponding dnsProvider.
        '';
        example = "/var/src/secrets/example.org-route53-api-token";
      };

      dnsPropagationCheck = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Toggles lego DNS propagation check, which is used alongside DNS-01
          challenge to ensure the DNS entries required are available.
        '';
      };

      ocspMustStaple = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Turns on the OCSP Must-Staple TLS extension.
          Make sure you know what you're doing! See:
          <itemizedlist>
            <listitem><para><link xlink:href="https://blog.apnic.net/2019/01/15/is-the-web-ready-for-ocsp-must-staple/" /></para></listitem>
            <listitem><para><link xlink:href="https://blog.hboeck.de/archives/886-The-Problem-with-OCSP-Stapling-and-Must-Staple-and-why-Certificate-Revocation-is-still-broken.html" /></para></listitem>
          </itemizedlist>
        '';
      };

      extraLegoRenewFlags = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          Additional flags to pass to lego renew.
        '';
      };
    };
  };

in

{

  ###### interface
  imports = [
    (mkRemovedOptionModule [ "security" "acme" "production" ] ''
      Use security.acme.server to define your staging ACME server URL instead.

      To use the let's encrypt staging server, use security.acme.server =
      "https://acme-staging-v02.api.letsencrypt.org/directory".
    ''
    )
    (mkRemovedOptionModule [ "security" "acme" "directory"] "ACME Directory is now hardcoded to /var/lib/acme and its permisisons are managed by systemd. See https://github.com/NixOS/nixpkgs/issues/53852 for more info.")
    (mkRemovedOptionModule [ "security" "acme" "preDelay"] "This option has been removed. If you want to make sure that something executes before certificates are provisioned, add a RequiredBy=acme-\${cert}.service to the service you want to execute before the cert renewal")
    (mkRemovedOptionModule [ "security" "acme" "activationDelay"] "This option has been removed. If you want to make sure that something executes before certificates are provisioned, add a RequiredBy=acme-\${cert}.service to the service you want to execute before the cert renewal")
    (mkChangedOptionModule [ "security" "acme" "validMin"] [ "security" "acme" "validMinDays"] (config: config.security.acme.validMin / (24 * 3600)))
  ];
  options = {
    security.acme = {

      validMinDays = mkOption {
        type = types.int;
        default = 30;
        description = "Minimum remaining validity before renewal in days.";
      };

      email = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Contact email address for the CA to be able to reach you.";
      };

      renewInterval = mkOption {
        type = types.str;
        default = "daily";
        description = ''
          Systemd calendar expression when to check for renewal. See
          <citerefentry><refentrytitle>systemd.time</refentrytitle>
          <manvolnum>7</manvolnum></citerefentry>.
        '';
      };

      server = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          ACME Directory Resource URI. Defaults to let's encrypt
          production endpoint,
          <literal>https://acme-v02.api.letsencrypt.org/directory</literal>, if unset.
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

      acceptTerms = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Accept the CA's terms of service. The default provier is Let's Encrypt,
          you can find their ToS at https://letsencrypt.org/repository/
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

      assertions = let
        certs = (mapAttrsToList (k: v: v) cfg.certs);
      in [
        {
          assertion = all (certOpts: certOpts.dnsProvider == null || certOpts.webroot == null) certs;
          message = ''
            Options `security.acme.certs.<name>.dnsProvider` and
            `security.acme.certs.<name>.webroot` are mutually exclusive.
          '';
        }
        {
          assertion = cfg.email != null || all (certOpts: certOpts.email != null) certs;
          message = ''
            You must define `security.acme.certs.<name>.email` or
            `security.acme.email` to register with the CA.
          '';
        }
        {
          assertion = cfg.acceptTerms;
          message = ''
            You must accept the CA's terms of service before using
            the ACME module by setting `security.acme.acceptTerms`
            to `true`. For Let's Encrypt's ToS see https://letsencrypt.org/repository/
          '';
        }
      ];

      systemd.services = let
          services = concatLists servicesLists;
          servicesLists = mapAttrsToList certToServices cfg.certs;
          certToServices = cert: data:
              let
                # StateDirectory must be relative, and will be created under /var/lib by systemd
                lpath = "acme/${cert}";
                apath = "/var/lib/${lpath}";
                spath = "/var/lib/acme/.lego";
                fileMode = if data.allowKeysForGroup then "640" else "600";
                globalOpts = [ "-d" data.domain "--email" data.email "--path" "." "--key-type" data.keyType ]
                          ++ optionals (cfg.acceptTerms) [ "--accept-tos" ]
                          ++ optionals (data.dnsProvider != null && !data.dnsPropagationCheck) [ "--dns.disable-cp" ]
                          ++ concatLists (mapAttrsToList (name: root: [ "-d" name ]) data.extraDomains)
                          ++ (if data.dnsProvider != null then [ "--dns" data.dnsProvider ] else [ "--http" "--http.webroot" data.webroot ])
                          ++ optionals (cfg.server != null || data.server != null) ["--server" (if data.server == null then cfg.server else data.server)];
                certOpts = optionals data.ocspMustStaple [ "--must-staple" ];
                runOpts = escapeShellArgs (globalOpts ++ [ "run" ] ++ certOpts);
                renewOpts = escapeShellArgs (globalOpts ++
                  [ "renew" "--days" (toString cfg.validMinDays) ] ++
                  certOpts ++ data.extraLegoRenewFlags);
                acmeService = {
                  description = "Renew ACME Certificate for ${cert}";
                  after = [ "network.target" "network-online.target" ];
                  wants = [ "network-online.target" ];
                  wantedBy = [ "multi-user.target" ];
                  serviceConfig = {
                    Type = "oneshot";
                    # With RemainAfterExit the service is considered active even
                    # after the main process having exited, which means when it
                    # gets changed, the activation phase restarts it, meaning
                    # the permissions of the StateDirectory get adjusted
                    # according to the specified group
                    RemainAfterExit = true;
                    User = data.user;
                    Group = data.group;
                    PrivateTmp = true;
                    StateDirectory = "acme/.lego ${lpath}";
                    StateDirectoryMode = if data.allowKeysForGroup then "750" else "700";
                    WorkingDirectory = spath;
                    # Only try loading the credentialsFile if the dns challenge is enabled
                    EnvironmentFile = if data.dnsProvider != null then data.credentialsFile else null;
                    ExecStart = pkgs.writeScript "acme-start" ''
                      #!${pkgs.runtimeShell} -e
                      ${pkgs.lego}/bin/lego ${renewOpts} || ${pkgs.lego}/bin/lego ${runOpts}
                    '';
                    ExecStartPost =
                      let
                        keyName = builtins.replaceStrings ["*"] ["_"] data.domain;
                        script = pkgs.writeScript "acme-post-start" ''
                          #!${pkgs.runtimeShell} -e
                          cd ${apath}

                          # Test that existing cert is older than new cert
                          KEY=${spath}/certificates/${keyName}.key
                          if [ -e $KEY -a $KEY -nt key.pem ]; then
                            cp -p ${spath}/certificates/${keyName}.key key.pem
                            cp -p ${spath}/certificates/${keyName}.crt fullchain.pem
                            cp -p ${spath}/certificates/${keyName}.issuer.crt chain.pem
                            ln -sf fullchain.pem cert.pem
                            cat key.pem fullchain.pem > full.pem
                          fi

                          chmod ${fileMode} *.pem
                          chown '${data.user}:${data.group}' *.pem

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
                      cp $workdir/server.key ${apath}/key.pem

                      # Create fullchain.pem (same format as "simp_le ... -f fullchain.pem" creates)
                      cat $workdir/{server.crt,ca.crt} > "${apath}/fullchain.pem"

                      # Create full.pem for e.g. lighttpd
                      cat $workdir/{server.key,server.crt,ca.crt} > "${apath}/full.pem"

                      # Give key acme permissions
                      chown '${data.user}:${data.group}' "${apath}/"{key,fullchain,full}.pem
                      chmod ${fileMode} "${apath}/"{key,fullchain,full}.pem
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
                    ConditionPathExists = "!${apath}/key.pem";
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
        map (data: "d ${data.webroot}/.well-known/acme-challenge - ${data.user} ${data.group}") (filter (data: data.webroot != null) (attrValues cfg.certs));

      systemd.timers = let
        # Allow systemd to pick a convenient time within the day
        # to run the check.
        # This allows the coalescing of multiple timer jobs.
        # We divide by the number of certificates so that if you
        # have many certificates, the renewals are distributed over
        # the course of the day to avoid rate limits.
        numCerts = length (attrNames cfg.certs);
        _24hSecs = 60 * 60 * 24;
        AccuracySec = "${toString (_24hSecs / numCerts)}s";
      in flip mapAttrs' cfg.certs (cert: data: nameValuePair
        ("acme-${cert}")
        ({
          description = "Renew ACME Certificate for ${cert}";
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = cfg.renewInterval;
            Unit = "acme-${cert}.service";
            Persistent = "yes";
            inherit AccuracySec;
            # Skew randomly within the day, per https://letsencrypt.org/docs/integration-guide/.
            RandomizedDelaySec = "24h";
          };
        })
      );

      systemd.targets.acme-selfsigned-certificates = mkIf cfg.preliminarySelfsigned {};
      systemd.targets.acme-certificates = {};
    })

  ];

  meta = {
    maintainers = with lib.maintainers; [ abbradar fpletz globin m1cr0man ];
    doc = ./acme.xml;
  };
}
