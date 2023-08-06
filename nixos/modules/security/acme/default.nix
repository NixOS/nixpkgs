{ config, lib, pkgs, options, ... }:
with lib;
let
  cfg = config.security.acme;
  opt = options.security.acme;
  user = if cfg.useRoot then "root" else "acme";

  # Used to calculate timer accuracy for coalescing
  numCerts = length (builtins.attrNames cfg.certs);
  _24hSecs = 60 * 60 * 24;

  # Used to make unique paths for each cert/account config set
  mkHash = with builtins; val: substring 0 20 (hashString "sha256" val);
  mkAccountHash = acmeServer: data: mkHash "${toString acmeServer} ${data.keyType} ${data.email}";
  accountDirRoot = "/var/lib/acme/.lego/accounts/";

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
    User = user;
    Group = mkDefault "acme";
    UMask = "0022";
    StateDirectoryMode = "750";
    ProtectSystem = "strict";
    ReadWritePaths = [
      "/var/lib/acme"
    ];
    PrivateTmp = true;

    WorkingDirectory = "/tmp";

    CapabilityBoundingSet = [ "" ];
    DevicePolicy = "closed";
    LockPersonality = true;
    MemoryDenyWriteExecute = true;
    NoNewPrivileges = true;
    PrivateDevices = true;
    ProtectClock = true;
    ProtectHome = true;
    ProtectHostname = true;
    ProtectControlGroups = true;
    ProtectKernelLogs = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectProc = "invisible";
    ProcSubset = "pid";
    RemoveIPC = true;
    RestrictAddressFamilies = [
      "AF_INET"
      "AF_INET6"
    ];
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    SystemCallArchitectures = "native";
    SystemCallFilter = [
      # 1. allow a reasonable set of syscalls
      "@system-service @resources"
      # 2. and deny unreasonable ones
      "~@privileged"
      # 3. then allow the required subset within denied groups
      "@chown"
    ];
  };

  # In order to avoid race conditions creating the CA for selfsigned certs,
  # we have a separate service which will create the necessary files.
  selfsignCAService = {
    description = "Generate self-signed certificate authority";

    path = with pkgs; [ minica ];

    unitConfig = {
      ConditionPathExists = "!/var/lib/acme/.minica/key.pem";
      StartLimitIntervalSec = 0;
    };

    serviceConfig = commonServiceConfig // {
      StateDirectory = "acme/.minica";
      BindPaths = "/var/lib/acme/.minica:/tmp/ca";
      UMask = "0077";
    };

    # Working directory will be /tmp
    script = ''
      minica \
        --ca-key ca/key.pem \
        --ca-cert ca/cert.pem \
        --domains selfsigned.local
    '';
  };

  # Ensures that directories which are shared across all certs
  # exist and have the correct user and group, since group
  # is configurable on a per-cert basis.
  userMigrationService = let
    script = with builtins; ''
      chown -R ${user} .lego/accounts
    '' + (concatStringsSep "\n" (mapAttrsToList (cert: data: ''
      for fixpath in ${escapeShellArg cert} .lego/${escapeShellArg cert}; do
        if [ -d "$fixpath" ]; then
          chmod -R u=rwX,g=rX,o= "$fixpath"
          chown -R ${user}:${data.group} "$fixpath"
        fi
      done
    '') certConfigs));
  in {
    description = "Fix owner and group of all ACME certificates";

    serviceConfig = commonServiceConfig // {
      # We don't want this to run every time a renewal happens
      RemainAfterExit = true;

      # These StateDirectory entries negate the need for tmpfiles
      StateDirectory = [ "acme" "acme/.lego" "acme/.lego/accounts" ];
      StateDirectoryMode = 755;
      WorkingDirectory = "/var/lib/acme";

      # Run the start script as root
      ExecStart = "+" + (pkgs.writeShellScript "acme-fixperms" script);
    };
  };

  certToConfig = cert: data: let
    acmeServer = data.server;
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
    certDir = mkHash hashData;
    # TODO remove domainHash usage entirely. Waiting on go-acme/lego#1532
    domainHash = mkHash "${concatStringsSep " " extraDomains} ${data.domain}";
    accountHash = (mkAccountHash acmeServer data);
    accountDir = accountDirRoot + accountHash;

    protocolOpts = if useDns then (
      [ "--dns" data.dnsProvider ]
      ++ optionals (!data.dnsPropagationCheck) [ "--dns.disable-cp" ]
      ++ optionals (data.dnsResolver != null) [ "--dns.resolvers" data.dnsResolver ]
    ) else if data.listenHTTP != null then [ "--http" "--http.port" data.listenHTTP ]
    else [ "--http" "--http.webroot" data.webroot ];

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
      ++ [ "renew" "--no-random-sleep" ]
      ++ optionals data.ocspMustStaple [ "--must-staple" ]
      ++ data.extraLegoRenewFlags
    );

    # We need to collect all the ACME webroots to grant them write
    # access in the systemd service.
    webroots =
      lib.remove null
        (lib.unique
            (builtins.map
            (certAttrs: certAttrs.webroot)
            (lib.attrValues config.security.acme.certs)));
  in {
    inherit accountHash cert selfsignedDeps;

    group = data.group;

    renewTimer = {
      description = "Renew ACME Certificate for ${cert}";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = data.renewInterval;
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
        FixedRandomDelay = true;
      };
    };

    selfsignService = {
      description = "Generate self-signed certificate for ${cert}";
      after = [ "acme-selfsigned-ca.service" "acme-fixperms.service" ];
      requires = [ "acme-selfsigned-ca.service" "acme-fixperms.service" ];

      path = with pkgs; [ minica ];

      unitConfig = {
        ConditionPathExists = "!/var/lib/acme/${cert}/key.pem";
        StartLimitIntervalSec = 0;
      };

      serviceConfig = commonServiceConfig // {
        Group = data.group;
        UMask = "0027";

        StateDirectory = "acme/${cert}";

        BindPaths = [
          "/var/lib/acme/.minica:/tmp/ca"
          "/var/lib/acme/${cert}:/tmp/${keyName}"
        ];
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

        # Group might change between runs, re-apply it
        chown '${user}:${data.group}' *

        # Default permissions make the files unreadable by group + anon
        # Need to be readable by group
        chmod 640 *
      '';
    };

    renewService = {
      description = "Renew ACME certificate for ${cert}";
      after = [ "network.target" "network-online.target" "acme-fixperms.service" "nss-lookup.target" ] ++ selfsignedDeps;
      wants = [ "network-online.target" "acme-fixperms.service" ] ++ selfsignedDeps;

      # https://github.com/NixOS/nixpkgs/pull/81371#issuecomment-605526099
      wantedBy = optionals (!config.boot.isContainer) [ "multi-user.target" ];

      path = with pkgs; [ lego coreutils diffutils openssl ];

      serviceConfig = commonServiceConfig // {
        Group = data.group;

        # Keep in mind that these directories will be deleted if the user runs
        # systemctl clean --what=state
        # acme/.lego/${cert} is listed for this reason.
        StateDirectory = [
          "acme/${cert}"
          "acme/.lego/${cert}"
          "acme/.lego/${cert}/${certDir}"
          "acme/.lego/accounts/${accountHash}"
        ];

        ReadWritePaths = commonServiceConfig.ReadWritePaths ++ webroots;

        # Needs to be space separated, but can't use a multiline string because that'll include newlines
        BindPaths = [
          "${accountDir}:/tmp/accounts"
          "/var/lib/acme/${cert}:/tmp/out"
          "/var/lib/acme/.lego/${cert}/${certDir}:/tmp/certificates"
        ];

        # Only try loading the credentialsFile if the dns challenge is enabled
        EnvironmentFile = mkIf useDns data.credentialsFile;

        # Run as root (Prefixed with +)
        ExecStartPost = "+" + (pkgs.writeShellScript "acme-postrun" ''
          cd /var/lib/acme/${escapeShellArg cert}
          if [ -e renewed ]; then
            rm renewed
            ${data.postRun}
            ${optionalString (data.reloadServices != [])
                "systemctl --no-block try-reload-or-restart ${escapeShellArgs data.reloadServices}"
            }
          fi
        '');
      } // optionalAttrs (data.listenHTTP != null && toInt (last (splitString ":" data.listenHTTP)) < 1024) {
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
      };

      # Working directory will be /tmp
      script = ''
        ${optionalString data.enableDebugLogs "set -x"}
        set -euo pipefail

        # This reimplements the expiration date check, but without querying
        # the acme server first. By doing this offline, we avoid errors
        # when the network or DNS are unavailable, which can happen during
        # nixos-rebuild switch.
        is_expiration_skippable() {
          pem=$1

          # This function relies on set -e to exit early if any of the
          # conditions or programs fail.

          [[ -e $pem ]]

          expiration_line="$(
            set -euxo pipefail
            openssl x509 -noout -enddate <$pem \
                  | grep notAfter \
                  | sed -e 's/^notAfter=//'
          )"
          [[ -n "$expiration_line" ]]

          expiration_date="$(date -d "$expiration_line" +%s)"
          now="$(date +%s)"
          expiration_s=$[expiration_date - now]
          expiration_days=$[expiration_s / (3600 * 24)]   # rounds down

          [[ $expiration_days -gt ${toString data.validMinDays} ]]
        }

        ${optionalString (data.webroot != null) ''
          # Ensure the webroot exists. Fixing group is required in case configuration was changed between runs.
          # Lego will fail if the webroot does not exist at all.
          (
            mkdir -p '${data.webroot}/.well-known/acme-challenge' \
            && chgrp '${data.group}' ${data.webroot}/.well-known/acme-challenge
          ) || (
            echo 'Please ensure ${data.webroot}/.well-known/acme-challenge exists and is writable by acme:${data.group}' \
            && exit 1
          )
        ''}

        echo '${domainHash}' > domainhash.txt

        # Check if we can renew.
        # We can only renew if the list of domains has not changed.
        # We also need an account key. Avoids #190493
        if cmp -s domainhash.txt certificates/domainhash.txt && [ -e 'certificates/${keyName}.key' -a -e 'certificates/${keyName}.crt' -a -n "$(find accounts -name '${data.email}.key')" ]; then

          # Even if a cert is not expired, it may be revoked by the CA.
          # Try to renew, and silently fail if the cert is not expired.
          # Avoids #85794 and resolves #129838
          if ! lego ${renewOpts} --days ${toString data.validMinDays}; then
            if is_expiration_skippable out/full.pem; then
              echo 1>&2 "nixos-acme: Ignoring failed renewal because expiration isn't within the coming ${toString data.validMinDays} days"
            else
              # High number to avoid Systemd reserved codes.
              exit 11
            fi
          fi

        # Otherwise do a full run
        elif ! lego ${runOpts}; then
          # Produce a nice error for those doing their first nixos-rebuild with these certs
          echo Failed to fetch certificates. \
            This may mean your DNS records are set up incorrectly. \
            ${optionalString (cfg.preliminarySelfsigned) "Selfsigned certs are in place and dependant services will still start."}
          # Exit 10 so that users can potentially amend SuccessExitStatus to ignore this error.
          # High number to avoid Systemd reserved codes.
          exit 10
        fi

        mv domainhash.txt certificates/

        # Group might change between runs, re-apply it
        chown '${user}:${data.group}' certificates/*

        # Copy all certs to the "real" certs directory
        if ! cmp -s 'certificates/${keyName}.crt' out/fullchain.pem; then
          touch out/renewed
          echo Installing new certificate
          cp -vp 'certificates/${keyName}.crt' out/fullchain.pem
          cp -vp 'certificates/${keyName}.key' out/key.pem
          cp -vp 'certificates/${keyName}.issuer.crt' out/chain.pem
          ln -sf fullchain.pem out/cert.pem
          cat out/key.pem out/fullchain.pem > out/full.pem
        fi

        # By default group will have no access to the cert files.
        # This chmod will fix that.
        chmod 640 out/*
      '';
    };
  };

  certConfigs = mapAttrs certToConfig cfg.certs;

  # These options can be specified within
  # security.acme.defaults or security.acme.certs.<name>
  inheritableModule = isDefaults: { config, ... }: let
    defaultAndText = name: default: {
      # When ! isDefaults then this is the option declaration for the
      # security.acme.certs.<name> path, which has the extra inheritDefaults
      # option, which if disabled means that we can't inherit it
      default = if isDefaults || ! config.inheritDefaults then default else cfg.defaults.${name};
      # The docs however don't need to depend on inheritDefaults, they should
      # stay constant. Though notably it wouldn't matter much, because to get
      # the option information, a submodule with name `<name>` is evaluated
      # without any definitions.
      defaultText = if isDefaults then default else literalExpression "config.security.acme.defaults.${name}";
    };
  in {
    options = {
      validMinDays = mkOption {
        type = types.int;
        inherit (defaultAndText "validMinDays" 30) default defaultText;
        description = lib.mdDoc "Minimum remaining validity before renewal in days.";
      };

      renewInterval = mkOption {
        type = types.str;
        inherit (defaultAndText "renewInterval" "daily") default defaultText;
        description = lib.mdDoc ''
          Systemd calendar expression when to check for renewal. See
          {manpage}`systemd.time(7)`.
        '';
      };

      enableDebugLogs = mkEnableOption (lib.mdDoc "debug logging for this certificate") // {
        inherit (defaultAndText "enableDebugLogs" true) default defaultText;
      };

      webroot = mkOption {
        type = types.nullOr types.str;
        inherit (defaultAndText "webroot" null) default defaultText;
        example = "/var/lib/acme/acme-challenge";
        description = lib.mdDoc ''
          Where the webroot of the HTTP vhost is located.
          {file}`.well-known/acme-challenge/` directory
          will be created below the webroot if it doesn't exist.
          `http://example.org/.well-known/acme-challenge/` must also
          be available (notice unencrypted HTTP).
        '';
      };

      server = mkOption {
        type = types.nullOr types.str;
        inherit (defaultAndText "server" null) default defaultText;
        description = lib.mdDoc ''
          ACME Directory Resource URI. Defaults to Let's Encrypt's
          production endpoint,
          <https://acme-v02.api.letsencrypt.org/directory>, if unset.
        '';
      };

      email = mkOption {
        type = types.nullOr types.str;
        inherit (defaultAndText "email" null) default defaultText;
        description = lib.mdDoc ''
          Email address for account creation and correspondence from the CA.
          It is recommended to use the same email for all certs to avoid account
          creation limits.
        '';
      };

      group = mkOption {
        type = types.str;
        inherit (defaultAndText "group" "acme") default defaultText;
        description = lib.mdDoc "Group running the ACME client.";
      };

      reloadServices = mkOption {
        type = types.listOf types.str;
        inherit (defaultAndText "reloadServices" []) default defaultText;
        description = lib.mdDoc ''
          The list of systemd services to call `systemctl try-reload-or-restart`
          on.
        '';
      };

      postRun = mkOption {
        type = types.lines;
        inherit (defaultAndText "postRun" "") default defaultText;
        example = "cp full.pem backup.pem";
        description = lib.mdDoc ''
          Commands to run after new certificates go live. Note that
          these commands run as the root user.

          Executed in the same directory with the new certificate.
        '';
      };

      keyType = mkOption {
        type = types.str;
        inherit (defaultAndText "keyType" "ec256") default defaultText;
        description = lib.mdDoc ''
          Key type to use for private keys.
          For an up to date list of supported values check the --key-type option
          at <https://go-acme.github.io/lego/usage/cli/#usage>.
        '';
      };

      dnsProvider = mkOption {
        type = types.nullOr types.str;
        inherit (defaultAndText "dnsProvider" null) default defaultText;
        example = "route53";
        description = lib.mdDoc ''
          DNS Challenge provider. For a list of supported providers, see the "code"
          field of the DNS providers listed at <https://go-acme.github.io/lego/dns/>.
        '';
      };

      dnsResolver = mkOption {
        type = types.nullOr types.str;
        inherit (defaultAndText "dnsResolver" null) default defaultText;
        example = "1.1.1.1:53";
        description = lib.mdDoc ''
          Set the resolver to use for performing recursive DNS queries. Supported:
          host:port. The default is to use the system resolvers, or Google's DNS
          resolvers if the system's cannot be determined.
        '';
      };

      credentialsFile = mkOption {
        type = types.nullOr types.path;
        inherit (defaultAndText "credentialsFile" null) default defaultText;
        description = lib.mdDoc ''
          Path to an EnvironmentFile for the cert's service containing any required and
          optional environment variables for your selected dnsProvider.
          To find out what values you need to set, consult the documentation at
          <https://go-acme.github.io/lego/dns/> for the corresponding dnsProvider.
        '';
        example = "/var/src/secrets/example.org-route53-api-token";
      };

      dnsPropagationCheck = mkOption {
        type = types.bool;
        inherit (defaultAndText "dnsPropagationCheck" true) default defaultText;
        description = lib.mdDoc ''
          Toggles lego DNS propagation check, which is used alongside DNS-01
          challenge to ensure the DNS entries required are available.
        '';
      };

      ocspMustStaple = mkOption {
        type = types.bool;
        inherit (defaultAndText "ocspMustStaple" false) default defaultText;
        description = lib.mdDoc ''
          Turns on the OCSP Must-Staple TLS extension.
          Make sure you know what you're doing! See:

          - <https://blog.apnic.net/2019/01/15/is-the-web-ready-for-ocsp-must-staple/>
          - <https://blog.hboeck.de/archives/886-The-Problem-with-OCSP-Stapling-and-Must-Staple-and-why-Certificate-Revocation-is-still-broken.html>
        '';
      };

      extraLegoFlags = mkOption {
        type = types.listOf types.str;
        inherit (defaultAndText "extraLegoFlags" []) default defaultText;
        description = lib.mdDoc ''
          Additional global flags to pass to all lego commands.
        '';
      };

      extraLegoRenewFlags = mkOption {
        type = types.listOf types.str;
        inherit (defaultAndText "extraLegoRenewFlags" []) default defaultText;
        description = lib.mdDoc ''
          Additional flags to pass to lego renew.
        '';
      };

      extraLegoRunFlags = mkOption {
        type = types.listOf types.str;
        inherit (defaultAndText "extraLegoRunFlags" []) default defaultText;
        description = lib.mdDoc ''
          Additional flags to pass to lego run.
        '';
      };
    };
  };

  certOpts = { name, config, ... }: {
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

      directory = mkOption {
        type = types.str;
        readOnly = true;
        default = "/var/lib/acme/${name}";
        description = lib.mdDoc "Directory where certificate and other state is stored.";
      };

      domain = mkOption {
        type = types.str;
        default = name;
        description = lib.mdDoc "Domain to fetch certificate for (defaults to the entry name).";
      };

      extraDomainNames = mkOption {
        type = types.listOf types.str;
        default = [];
        example = literalExpression ''
          [
            "example.org"
            "mydomain.org"
          ]
        '';
        description = lib.mdDoc ''
          A list of extra domain names, which are included in the one certificate to be issued.
        '';
      };

      # This setting must be different for each configured certificate, otherwise
      # two or more renewals may fail to bind to the address. Hence, it is not in
      # the inheritableOpts.
      listenHTTP = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = ":1360";
        description = lib.mdDoc ''
          Interface and port to listen on to solve HTTP challenges
          in the form [INTERFACE]:PORT.
          If you use a port other than 80, you must proxy port 80 to this port.
        '';
      };

      inheritDefaults = mkOption {
        default = true;
        example = true;
        description = lib.mdDoc "Whether to inherit values set in `security.acme.defaults` or not.";
        type = lib.types.bool;
      };
    };
  };

in {

  options = {
    security.acme = {
      preliminarySelfsigned = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
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
        description = lib.mdDoc ''
          Accept the CA's terms of service. The default provider is Let's Encrypt,
          you can find their ToS at <https://letsencrypt.org/repository/>.
        '';
      };

      useRoot = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to use the root user when generating certs. This is not recommended
          for security + compatibility reasons. If a service requires root owned certificates
          consider following the guide on "Using ACME with services demanding root
          owned certificates" in the NixOS manual, and only using this as a fallback
          or for testing.
        '';
      };

      defaults = mkOption {
        type = types.submodule (inheritableModule true);
        description = lib.mdDoc ''
          Default values inheritable by all configured certs. You can
          use this to define options shared by all your certs. These defaults
          can also be ignored on a per-cert basis using the
          {option}`security.acme.certs.''${cert}.inheritDefaults` option.
        '';
      };

      certs = mkOption {
        default = { };
        type = with types; attrsOf (submodule [ (inheritableModule false) certOpts ]);
        description = lib.mdDoc ''
          Attribute set of certificates to get signed and renewed. Creates
          `acme-''${cert}.{service,timer}` systemd units for
          each certificate defined here. Other services can add dependencies
          to those units if they rely on the certificates being present,
          or trigger restarts of the service if certificates get renewed.
        '';
        example = literalExpression ''
          {
            "example.com" = {
              webroot = "/var/lib/acme/acme-challenge/";
              email = "foo@example.com";
              extraDomainNames = [ "www.example.com" "foo.example.com" ];
            };
            "bar.example.com" = {
              webroot = "/var/lib/acme/acme-challenge/";
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
    '')
    (mkRemovedOptionModule [ "security" "acme" "directory" ] "ACME Directory is now hardcoded to /var/lib/acme and its permissions are managed by systemd. See https://github.com/NixOS/nixpkgs/issues/53852 for more info.")
    (mkRemovedOptionModule [ "security" "acme" "preDelay" ] "This option has been removed. If you want to make sure that something executes before certificates are provisioned, add a RequiredBy=acme-\${cert}.service to the service you want to execute before the cert renewal")
    (mkRemovedOptionModule [ "security" "acme" "activationDelay" ] "This option has been removed. If you want to make sure that something executes before certificates are provisioned, add a RequiredBy=acme-\${cert}.service to the service you want to execute before the cert renewal")
    (mkChangedOptionModule [ "security" "acme" "validMin" ] [ "security" "acme" "defaults" "validMinDays" ] (config: config.security.acme.validMin / (24 * 3600)))
    (mkChangedOptionModule [ "security" "acme" "validMinDays" ] [ "security" "acme" "defaults" "validMinDays" ] (config: config.security.acme.validMinDays))
    (mkChangedOptionModule [ "security" "acme" "renewInterval" ] [ "security" "acme" "defaults" "renewInterval" ] (config: config.security.acme.renewInterval))
    (mkChangedOptionModule [ "security" "acme" "email" ] [ "security" "acme" "defaults" "email" ] (config: config.security.acme.email))
    (mkChangedOptionModule [ "security" "acme" "server" ] [ "security" "acme" "defaults" "server" ] (config: config.security.acme.server))
    (mkChangedOptionModule [ "security" "acme" "enableDebugLogs" ] [ "security" "acme" "defaults" "enableDebugLogs" ] (config: config.security.acme.enableDebugLogs))
  ];

  config = mkMerge [
    (mkIf (cfg.certs != { }) {

      # FIXME Most of these custom warnings and filters for security.acme.certs.* are required
      # because using mkRemovedOptionModule/mkChangedOptionModule with attrsets isn't possible.
      warnings = filter (w: w != "") (mapAttrsToList (cert: data: optionalString (data.extraDomains != "_mkMergedOptionModule") ''
        The option definition `security.acme.certs.${cert}.extraDomains` has changed
        to `security.acme.certs.${cert}.extraDomainNames` and is now a list of strings.
        Setting a custom webroot for extra domains is not possible, instead use separate certs.
      '') cfg.certs);

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
        {
          assertion = data.webroot == null || data.listenHTTP == null;
          message = ''
            Options `security.acme.certs.${cert}.webroot` and
            `security.acme.certs.${cert}.listenHTTP` are mutually exclusive.
          '';
        }
        {
          assertion = data.listenHTTP == null || data.dnsProvider == null;
          message = ''
            Options `security.acme.certs.${cert}.listenHTTP` and
            `security.acme.certs.${cert}.dnsProvider` are mutually exclusive.
          '';
        }
        {
          assertion = data.dnsProvider != null || data.webroot != null || data.listenHTTP != null;
          message = ''
            One of `security.acme.certs.${cert}.dnsProvider`,
            `security.acme.certs.${cert}.webroot`, or
            `security.acme.certs.${cert}.listenHTTP` must be provided.
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

      systemd.targets = let
        # Create some targets which can be depended on to be "active" after cert renewals
        finishedTargets = mapAttrs' (cert: conf: nameValuePair "acme-finished-${cert}" {
          wantedBy = [ "default.target" ];
          requires = [ "acme-${cert}.service" ];
          after = [ "acme-${cert}.service" ];
        }) certConfigs;

        # Create targets to limit the number of simultaneous account creations
        # How it works:
        # - Pick a "leader" cert service, which will be in charge of creating the account,
        #   and run first (requires + after)
        # - Make all other cert services sharing the same account wait for the leader to
        #   finish before starting (requiredBy + before).
        # Using a target here is fine - account creation is a one time event. Even if
        # systemd clean --what=state is used to delete the account, so long as the user
        # then runs one of the cert services, there won't be any issues.
        accountTargets = mapAttrs' (hash: confs: let
          leader = "acme-${(builtins.head confs).cert}.service";
          dependantServices = map (conf: "acme-${conf.cert}.service") (builtins.tail confs);
        in nameValuePair "acme-account-${hash}" {
          requiredBy = dependantServices;
          before = dependantServices;
          requires = [ leader ];
          after = [ leader ];
        }) (groupBy (conf: conf.accountHash) (attrValues certConfigs));
      in finishedTargets // accountTargets;
    })
  ];

  meta = {
    maintainers = lib.teams.acme.members;
    doc = ./default.md;
  };
}
