{ config, lib, pkgs, options, ... }:
with lib;
let
  cfg = config.security.acme;

  # Used to calculate timer accuracy for coalescing
  numCerts = length (builtins.attrNames cfg.certs);
  _24hSecs = 60 * 60 * 24;

  # There are many services required to make cert renewals work.
  # They all follow a common structure:
  #   - They inherit this commonServiceConfig
  #   - They all run as the acme user
  #   - They all use BindPath and StateDirectory where possible
  #     to set up a sort of build environment in /tmp
  # The Group can vary depending on what the user has specified in
  # security.acme.certs.<cert>.group on some of the services.
  commonServiceConfig = {
      Type = "oneshot";
      User = "acme";
      Group = mkDefault "acme";
      UMask = 0027;
      StateDirectoryMode = 750;
      ProtectSystem = "full";
      PrivateTmp = true;

      WorkingDirectory = "/tmp";
  };

  # In order to avoid race conditions creating the CA for selfsigned certs,
  # we have a separate service which will create the necessary files.
  selfsignCAService = {
    description = "Generate self-signed certificate authority";

    path = with pkgs; [ minica ];

    unitConfig = {
      ConditionPathExists = "!/var/lib/acme/.minica/key.pem";
    };

    serviceConfig = commonServiceConfig // {
      StateDirectory = "acme/.minica";
      BindPaths = "/var/lib/acme/.minica:/tmp/ca";
    };

    # Working directory will be /tmp
    script = ''
      minica \
        --ca-key ca/key.pem \
        --ca-cert ca/cert.pem \
        --domains selfsigned.local

      chmod 600 ca/*
    '';
  };

  # Previously, all certs were owned by whatever user was configured in
  # config.security.acme.certs.<cert>.user. Now everything is owned by and
  # run by the acme user.
  userMigrationService = {
    description = "Fix owner and group of all ACME certificates";

    script = with builtins; concatStringsSep "\n" (mapAttrsToList (cert: data: ''
      for fixpath in /var/lib/acme/${escapeShellArg cert} /var/lib/acme/.lego/${escapeShellArg cert}; do
        if [ -d "$fixpath" ]; then
          chmod -R u=rwX,g=rX,o= "$fixpath"
          chown -R acme:${data.group} "$fixpath"
        fi
      done
    '') certConfigs);

    # We don't want this to run every time a renewal happens
    serviceConfig.RemainAfterExit = true;
  };

  certToConfig = cert: data: let
    acmeServer = if data.server != null then data.server else cfg.server;
    useDns = data.dnsProvider != null;
    destPath = "/var/lib/acme/${cert}";
    selfsignedDeps = optionals (cfg.preliminarySelfsigned) [ "acme-selfsigned-${cert}.service" ];

    # Minica and lego have a "feature" which replaces * with _. We need
    # to make this substitution to reference the output files from both programs.
    # End users never see this since we rename the certs.
    keyName = builtins.replaceStrings ["*"] ["_"] data.domain;

    # FIXME when mkChangedOptionModule supports submodules, change to that.
    # This is a workaround
    extraDomains = data.extraDomainNames ++ (
      optionals
      (data.extraDomains != "_mkMergedOptionModule")
      (builtins.attrNames data.extraDomains)
    );

    # Create hashes for cert data directories based on configuration
    # Flags are separated to avoid collisions
    hashData = with builtins; ''
      ${concatStringsSep " " data.extraLegoFlags} -
      ${concatStringsSep " " data.extraLegoRunFlags} -
      ${concatStringsSep " " data.extraLegoRenewFlags} -
      ${toString acmeServer} ${toString data.dnsProvider}
      ${toString data.ocspMustStaple} ${data.keyType}
    '';
    mkHash = with builtins; val: substring 0 20 (hashString "sha256" val);
    certDir = mkHash hashData;
    domainHash = mkHash "${concatStringsSep " " extraDomains} ${data.domain}";
    othersHash = mkHash "${toString acmeServer} ${data.keyType} ${data.email}";
    accountDir = "/var/lib/acme/.lego/accounts/" + othersHash;

    protocolOpts = if useDns then (
      [ "--dns" data.dnsProvider ]
      ++ optionals (!data.dnsPropagationCheck) [ "--dns.disable-cp" ]
      ++ optionals (data.dnsResolver != null) [ "--dns.resolvers" data.dnsResolver ]
    ) else (
      [ "--http" "--http.webroot" data.webroot ]
    );

    commonOpts = [
      "--accept-tos" # Checking the option is covered by the assertions
      "--path" "."
      "-d" data.domain
      "--email" data.email
      "--key-type" data.keyType
    ] ++ protocolOpts
      ++ optionals (acmeServer != null) [ "--server" acmeServer ]
      ++ concatMap (name: [ "-d" name ]) extraDomains
      ++ data.extraLegoFlags;

    # Although --must-staple is common to both modes, it is not declared as a
    # mode-agnostic argument in lego and thus must come after the mode.
    runOpts = escapeShellArgs (
      commonOpts
      ++ [ "run" ]
      ++ optionals data.ocspMustStaple [ "--must-staple" ]
      ++ data.extraLegoRunFlags
    );
    renewOpts = escapeShellArgs (
      commonOpts
      ++ [ "renew" "--reuse-key" ]
      ++ optionals data.ocspMustStaple [ "--must-staple" ]
      ++ data.extraLegoRenewFlags
    );

  in {
    inherit accountDir selfsignedDeps;

    webroot = data.webroot;
    group = data.group;

    renewTimer = {
      description = "Renew ACME Certificate for ${cert}";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.renewInterval;
        Unit = "acme-${cert}.service";
        Persistent = "yes";

        # Allow systemd to pick a convenient time within the day
        # to run the check.
        # This allows the coalescing of multiple timer jobs.
        # We divide by the number of certificates so that if you
        # have many certificates, the renewals are distributed over
        # the course of the day to avoid rate limits.
        AccuracySec = "${toString (_24hSecs / numCerts)}s";

        # Skew randomly within the day, per https://letsencrypt.org/docs/integration-guide/.
        RandomizedDelaySec = "24h";
      };
    };

    selfsignService = {
      description = "Generate self-signed certificate for ${cert}";
      after = [ "acme-selfsigned-ca.service" "acme-fixperms.service" ];
      requires = [ "acme-selfsigned-ca.service" "acme-fixperms.service" ];

      path = with pkgs; [ minica ];

      unitConfig = {
        ConditionPathExists = "!/var/lib/acme/${cert}/key.pem";
      };

      serviceConfig = commonServiceConfig // {
        Group = data.group;

        StateDirectory = "acme/${cert}";

        BindPaths = "/var/lib/acme/.minica:/tmp/ca /var/lib/acme/${cert}:/tmp/${keyName}";
      };

      # Working directory will be /tmp
      # minica will output to a folder sharing the name of the first domain
      # in the list, which will be ${data.domain}
      script = ''
        minica \
          --ca-key ca/key.pem \
          --ca-cert ca/cert.pem \
          --domains ${escapeShellArg (builtins.concatStringsSep "," ([ data.domain ] ++ extraDomains))}

        # Create files to match directory layout for real certificates
        cd '${keyName}'
        cp ../ca/cert.pem chain.pem
        cat cert.pem chain.pem > fullchain.pem
        cat key.pem fullchain.pem > full.pem

        chmod 640 *

        # Group might change between runs, re-apply it
        chown 'acme:${data.group}' *
      '';
    };

    renewService = {
      description = "Renew ACME certificate for ${cert}";
      after = [ "network.target" "network-online.target" "acme-fixperms.service" "nss-lookup.target" ] ++ selfsignedDeps;
      wants = [ "network-online.target" "acme-fixperms.service" ] ++ selfsignedDeps;

      # https://github.com/NixOS/nixpkgs/pull/81371#issuecomment-605526099
      wantedBy = optionals (!config.boot.isContainer) [ "multi-user.target" ];

      path = with pkgs; [ lego coreutils diffutils ];

      serviceConfig = commonServiceConfig // {
        Group = data.group;

        # AccountDir dir will be created by tmpfiles to ensure correct permissions
        # And to avoid deletion during systemctl clean
        # acme/.lego/${cert} is listed so that it is deleted during systemctl clean
        StateDirectory = "acme/${cert} acme/.lego/${cert} acme/.lego/${cert}/${certDir}";

        # Needs to be space separated, but can't use a multiline string because that'll include newlines
        BindPaths =
          "${accountDir}:/tmp/accounts " +
          "/var/lib/acme/${cert}:/tmp/out " +
          "/var/lib/acme/.lego/${cert}/${certDir}:/tmp/certificates ";

        # Only try loading the credentialsFile if the dns challenge is enabled
        EnvironmentFile = mkIf useDns data.credentialsFile;

        # Run as root (Prefixed with +)
        ExecStartPost = "+" + (pkgs.writeShellScript "acme-postrun" ''
          cd /var/lib/acme/${escapeShellArg cert}
          if [ -e renewed ]; then
            rm renewed
            ${data.postRun}
          fi
        '');
      };

      # Working directory will be /tmp
      script = ''
        set -euo pipefail

        echo '${domainHash}' > domainhash.txt

        # Check if we can renew
        # Certificates and account credentials must exist
        if [ -e 'certificates/${keyName}.key' -a -e 'certificates/${keyName}.crt' -a "$(ls -1 accounts)" ]; then

          # When domains are updated, there's no need to do a full
          # Lego run, but it's likely renew won't work if days is too low.
          if [ -e certificates/domainhash.txt ] && cmp -s domainhash.txt certificates/domainhash.txt; then
            lego ${renewOpts} --days ${toString cfg.validMinDays}
          else
            # Any number > 90 works, but this one is over 9000 ;-)
            lego ${renewOpts} --days 9001
          fi

        # Otherwise do a full run
        else
          lego ${runOpts}
        fi

        mv domainhash.txt certificates/
        chmod 640 certificates/*
        chmod -R u=rwX,g=,o= accounts/*

        # Group might change between runs, re-apply it
        chown 'acme:${data.group}' certificates/*

        # Copy all certs to the "real" certs directory
        CERT='certificates/${keyName}.crt'
        if [ -e "$CERT" ] && ! cmp -s "$CERT" out/fullchain.pem; then
          touch out/renewed
          echo Installing new certificate
          cp -vp 'certificates/${keyName}.crt' out/fullchain.pem
          cp -vp 'certificates/${keyName}.key' out/key.pem
          cp -vp 'certificates/${keyName}.issuer.crt' out/chain.pem
          ln -sf fullchain.pem out/cert.pem
          cat out/key.pem out/fullchain.pem > out/full.pem
        fi
      '';
    };
  };

  certConfigs = mapAttrs certToConfig cfg.certs;

  certOpts = { name, ... }: {
    options = {
      # user option has been removed
      user = mkOption {
        visible = false;
        default = "_mkRemovedOptionModule";
      };

      # allowKeysForGroup option has been removed
      allowKeysForGroup = mkOption {
        visible = false;
        default = "_mkRemovedOptionModule";
      };

      # extraDomains was replaced with extraDomainNames
      extraDomains = mkOption {
        visible = false;
        default = "_mkMergedOptionModule";
      };

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
          ACME Directory Resource URI. Defaults to Let's Encrypt's
          production endpoint,
          <link xlink:href="https://acme-v02.api.letsencrypt.org/directory"/>, if unset.
        '';
      };

      domain = mkOption {
        type = types.str;
        default = name;
        description = "Domain to fetch certificate for (defaults to the entry name).";
      };

      email = mkOption {
        type = types.nullOr types.str;
        default = cfg.email;
        description = "Contact email address for the CA to be able to reach you.";
      };

      group = mkOption {
        type = types.str;
        default = "acme";
        description = "Group running the ACME client.";
      };

      postRun = mkOption {
        type = types.lines;
        default = "";
        example = "cp full.pem backup.pem";
        description = ''
          Commands to run after new certificates go live. Note that
          these commands run as the root user.

          Executed in the same directory with the new certificate.
        '';
      };

      directory = mkOption {
        type = types.str;
        readOnly = true;
        default = "/var/lib/acme/${name}";
        description = "Directory where certificate and other state is stored.";
      };

      extraDomainNames = mkOption {
        type = types.listOf types.str;
        default = [];
        example = literalExample ''
          [
            "example.org"
            "mydomain.org"
          ]
        '';
        description = ''
          A list of extra domain names, which are included in the one certificate to be issued.
        '';
      };

      keyType = mkOption {
        type = types.str;
        default = "ec256";
        description = ''
          Key type to use for private keys.
          For an up to date list of supported values check the --key-type option
          at <link xlink:href="https://go-acme.github.io/lego/usage/cli/#usage"/>.
        '';
      };

      dnsProvider = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "route53";
        description = ''
          DNS Challenge provider. For a list of supported providers, see the "code"
          field of the DNS providers listed at <link xlink:href="https://go-acme.github.io/lego/dns/"/>.
        '';
      };

      dnsResolver = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "1.1.1.1:53";
        description = ''
          Set the resolver to use for performing recursive DNS queries. Supported:
          host:port. The default is to use the system resolvers, or Google's DNS
          resolvers if the system's cannot be determined.
        '';
      };

      credentialsFile = mkOption {
        type = types.path;
        description = ''
          Path to an EnvironmentFile for the cert's service containing any required and
          optional environment variables for your selected dnsProvider.
          To find out what values you need to set, consult the documentation at
          <link xlink:href="https://go-acme.github.io/lego/dns/"/> for the corresponding dnsProvider.
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

      extraLegoFlags = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          Additional global flags to pass to all lego commands.
        '';
      };

      extraLegoRenewFlags = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          Additional flags to pass to lego renew.
        '';
      };

      extraLegoRunFlags = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          Additional flags to pass to lego run.
        '';
      };
    };
  };

in {

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
          ACME Directory Resource URI. Defaults to Let's Encrypt's
          production endpoint,
          <link xlink:href="https://acme-v02.api.letsencrypt.org/directory"/>, if unset.
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
          Accept the CA's terms of service. The default provider is Let's Encrypt,
          you can find their ToS at <link xlink:href="https://letsencrypt.org/repository/"/>.
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
              extraDomainNames = [ "www.example.com" "foo.example.com" ];
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

  imports = [
    (mkRemovedOptionModule [ "security" "acme" "production" ] ''
      Use security.acme.server to define your staging ACME server URL instead.

      To use the let's encrypt staging server, use security.acme.server =
      "https://acme-staging-v02.api.letsencrypt.org/directory".
    ''
    )
    (mkRemovedOptionModule [ "security" "acme" "directory" ] "ACME Directory is now hardcoded to /var/lib/acme and its permisisons are managed by systemd. See https://github.com/NixOS/nixpkgs/issues/53852 for more info.")
    (mkRemovedOptionModule [ "security" "acme" "preDelay" ] "This option has been removed. If you want to make sure that something executes before certificates are provisioned, add a RequiredBy=acme-\${cert}.service to the service you want to execute before the cert renewal")
    (mkRemovedOptionModule [ "security" "acme" "activationDelay" ] "This option has been removed. If you want to make sure that something executes before certificates are provisioned, add a RequiredBy=acme-\${cert}.service to the service you want to execute before the cert renewal")
    (mkChangedOptionModule [ "security" "acme" "validMin" ] [ "security" "acme" "validMinDays" ] (config: config.security.acme.validMin / (24 * 3600)))
  ];

  config = mkMerge [
    (mkIf (cfg.certs != { }) {

      # FIXME Most of these custom warnings and filters for security.acme.certs.* are required
      # because using mkRemovedOptionModule/mkChangedOptionModule with attrsets isn't possible.
      warnings = filter (w: w != "") (mapAttrsToList (cert: data: if data.extraDomains != "_mkMergedOptionModule" then ''
        The option definition `security.acme.certs.${cert}.extraDomains` has changed
        to `security.acme.certs.${cert}.extraDomainNames` and is now a list of strings.
        Setting a custom webroot for extra domains is not possible, instead use separate certs.
      '' else "") cfg.certs);

      assertions = let
        certs = attrValues cfg.certs;
      in [
        {
          assertion = cfg.email != null || all (certOpts: certOpts.email != null) certs;
          message = ''
            You must define `security.acme.certs.<name>.email` or
            `security.acme.email` to register with the CA. Note that using
            many different addresses for certs may trigger account rate limits.
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
      ] ++ (builtins.concatLists (mapAttrsToList (cert: data: [
        {
          assertion = data.user == "_mkRemovedOptionModule";
          message = ''
            The option definition `security.acme.certs.${cert}.user' no longer has any effect; Please remove it.
            Certificate user is now hard coded to the "acme" user. If you would
            like another user to have access, consider adding them to the
            "acme" group or changing security.acme.certs.${cert}.group.
          '';
        }
        {
          assertion = data.allowKeysForGroup == "_mkRemovedOptionModule";
          message = ''
            The option definition `security.acme.certs.${cert}.allowKeysForGroup' no longer has any effect; Please remove it.
            All certs are readable by the configured group. If this is undesired,
            consider changing security.acme.certs.${cert}.group to an unused group.
          '';
        }
        # * in the cert value breaks building of systemd services, and makes
        # referencing them as a user quite weird too. Best practice is to use
        # the domain option.
        {
          assertion = ! hasInfix "*" cert;
          message = ''
            The cert option path `security.acme.certs.${cert}.dnsProvider`
            cannot contain a * character.
            Instead, set `security.acme.certs.${cert}.domain = "${cert}";`
            and remove the wildcard from the path.
          '';
        }
        {
          assertion = data.dnsProvider == null || data.webroot == null;
          message = ''
            Options `security.acme.certs.${cert}.dnsProvider` and
            `security.acme.certs.${cert}.webroot` are mutually exclusive.
          '';
        }
      ]) cfg.certs));

      users.users.acme = {
        home = "/var/lib/acme";
        group = "acme";
        isSystemUser = true;
      };

      users.groups.acme = {};

      systemd.services = {
        "acme-fixperms" = userMigrationService;
      } // (mapAttrs' (cert: conf: nameValuePair "acme-${cert}" conf.renewService) certConfigs)
        // (optionalAttrs (cfg.preliminarySelfsigned) ({
        "acme-selfsigned-ca" = selfsignCAService;
      } // (mapAttrs' (cert: conf: nameValuePair "acme-selfsigned-${cert}" conf.selfsignService) certConfigs)));

      systemd.timers = mapAttrs' (cert: conf: nameValuePair "acme-${cert}" conf.renewTimer) certConfigs;

      # .lego and .lego/accounts specified to fix any incorrect permissions
      systemd.tmpfiles.rules = [
        "d /var/lib/acme/.lego - acme acme"
        "d /var/lib/acme/.lego/accounts - acme acme"
      ] ++ (unique (concatMap (conf: [
          "d ${conf.accountDir} - acme acme"
        ] ++ (optional (conf.webroot != null) "d ${conf.webroot}/.well-known/acme-challenge - acme ${conf.group}")
      ) (attrValues certConfigs)));

      # Create some targets which can be depended on to be "active" after cert renewals
      systemd.targets = mapAttrs' (cert: conf: nameValuePair "acme-finished-${cert}" {
        wantedBy = [ "default.target" ];
        requires = [ "acme-${cert}.service" ] ++ conf.selfsignedDeps;
        after = [ "acme-${cert}.service" ] ++ conf.selfsignedDeps;
      }) certConfigs;
    })
  ];

  meta = {
    maintainers = lib.teams.acme.members;
    doc = ./acme.xml;
  };
}
