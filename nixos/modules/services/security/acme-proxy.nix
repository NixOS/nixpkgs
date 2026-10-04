{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.acme-proxy;
  tomlFormat = pkgs.formats.toml { };

  # Extract the trailing ":PORT" from a bind address like "[::]:3000" or
  # "127.0.0.1:3001". Returns null on anything that doesn't look like host:port.
  parsePort =
    addr:
    let
      m = builtins.match ".*:([0-9]+)" (toString addr);
    in
    if m == null then null else lib.toInt (builtins.elemAt m 0);

  # Defaults pulled from upstream config.toml.example at the same version as
  # the package. They are only used to guess firewall ports.
  serverBind = cfg.settings.server.bind_address or "[::]:3000";
  adminBind = cfg.settings.admin.bind_address or "127.0.0.1:3001";
  metricsBind = cfg.settings.metrics.bind_address or "127.0.0.1:3002";

  adminEnabled = cfg.settings.admin.enabled or false;
  metricsEnabled = cfg.settings.metrics.enabled or false;

  serverPort = parsePort serverBind;
  adminPort = if adminEnabled then parsePort adminBind else null;
  metricsPort = if metricsEnabled then parsePort metricsBind else null;

  # The schema for one profile declared through `services.acme-proxy.profiles`.
  # Translated into a `[profiles.<name>]` TOML table by `profileToTOML` below;
  # everything the user supplied under `settings.profiles.<name>` and the
  # typed option are merged at the rendered-config stage.
  profileType = lib.types.submodule {
    options = {
      signer = {
        backend = lib.mkOption {
          type = lib.types.enum [ "local_ca" "relay" "custom" ];
          default = "local_ca";
          defaultText = lib.literalExpression ''"local_ca"'';
          description = "The issuance backend this profile uses.";
        };
        relay = {
          directoryUrl = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = ''
              Upstream ACME directory URL. Required when
              `signer.backend = "relay"`; the daemon refuses to start
              otherwise.
            '';
          };
          challengeStrategy = lib.mkOption {
            type = lib.types.enum [ "bypass" "dns01" "http01" ];
            default = "bypass";
            defaultText = lib.literalExpression ''"bypass"'';
            description = ''
              How this proxy satisfies the upstream CA's domain-control
              check. `"bypass"` is only appropriate when the upstream
              trusts this server (a private CA, or another acme-proxy
              with `challenge.bypass = true`).
            '';
          };
          dns01 = {
            provider = lib.mkOption {
              type = lib.types.enum [ "rfc2136" ];
              default = "rfc2136";
              defaultText = lib.literalExpression ''"rfc2136"'';
              description = ''
                DNS-01 provider used to publish the TXT records the
                upstream CA asks for. Only `"rfc2136"` is implemented
                upstream; the option is typed as enum rather than as a
                free string so an unsupported value fails at
                evaluation rather than at daemon startup.
              '';
            };
            rfc2136 = {
              server = lib.mkOption {
                type = lib.types.str;
                default = "";
                example = "ns1.example.com:53";
                description = ''
                  `host:port` of the authoritative DNS server that
                  accepts RFC 2136 dynamic updates from this proxy.
                '';
              };
              zone = lib.mkOption {
                type = lib.types.str;
                default = "";
                example = "example.com.";
                description = ''
                  Zone being updated, with the trailing dot. The
                  server must `allow-update { key "<name>"; };` the
                  corresponding zone.
                '';
              };
              tsigKeyName = lib.mkOption {
                type = lib.types.str;
                default = "";
                example = "acme-proxy-key";
                description = ''
                  TSIG key name, matching the `key "<name>" { ... };`
                  clause in `named.conf` on the authoritative server.
                '';
              };
              tsigKeySecret = lib.mkOption {
                type = lib.types.str;
                default = "";
                example = ''
                  # Read the secret out of band — see secretsFile.
                '';
                description = ''
                  TSIG key secret in **standard** base64 (as
                  `dnssec-keygen` and BIND emit it; not base64url).
                  Empty (the default) is a startup error upstream.

                  Prefer the env-var override mechanism — put
                  `ACME_PROXY_SIGNER__RELAY__DNS01__RFC2136__TSIG_KEY_SECRET=<base64>`
                  in the profile's `secretsFile` — over hard-coding
                  the value here, which would put the secret in the
                  Nix store.
                '';
              };
              tsigAlgorithm = lib.mkOption {
                type = lib.types.enum [ "hmac-sha256" "hmac-sha384" "hmac-sha512" ];
                default = "hmac-sha256";
                defaultText = lib.literalExpression ''"hmac-sha256"'';
                description = ''
                  TSIG HMAC algorithm. `hmac-md5` is deliberately
                  not offered upstream. The default matches what
                  `dnssec-keygen -a hmac-sha256` produces.
                '';
              };
            };
            propagation = {
              mode = lib.mkOption {
                type = lib.types.enum [ "none" "delay" ];
                default = "none";
                defaultText = lib.literalExpression ''"none"'';
                description = ''
                  What to wait for between the dynamic update and
                  asking the upstream CA to validate the record.
                  `"none"` triggers validation right after the
                  update (right when the update server is itself
                  what the CA asks). `"delay"` sleeps
                  `delaySecs` first — for a provider that accepts an
                  update before serving it, or for secondaries that
                  lag the primary.
                '';
              };
              delaySecs = lib.mkOption {
                type = lib.types.int;
                default = 30;
                defaultText = lib.literalExpression "30";
                description = ''
                  Sleep before validation when `mode = "delay"`.
                  Must be less than
                  `poll_timeout_secs` (the relay's per-attempt
                  budget), and the delay runs once per name in the
                  order — raise that budget accordingly for a
                  multi-name order.
                '';
              };
            };
          };
        };
        localCa = {
          leafValidityDays = lib.mkOption {
            type = lib.types.int;
            default = 90;
            defaultText = lib.literalExpression "90";
            description = ''
              Validity period in days of the certificates signed by the
              local CA. Distinct from the order object's lifetime
              (see `order.validity_seconds` in the global
              {option}`services.acme-proxy.settings`).
            '';
          };
        };
        custom = {
          scriptPath = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = ''
              Absolute path to an external signing script. Required when
              `signer.backend = "custom"`. The script is invoked once
              per issuance/revocation as documented upstream.
            '';
          };
        };
      };
      challenge = {
        enabled = lib.mkOption {
          type = lib.types.listOf (lib.types.enum [ "http-01" "dns-01" "tls-alpn-01" ]);
          default = [ "http-01" ];
          defaultText = lib.literalExpression ''[ "http-01" ]'';
          description = ''
            Challenge types offered by this profile's new-authorization
            objects, in the order they appear. A wildcard identifier
            can only be proved with `"dns-01"`.
          '';
        };
        bypass = lib.mkOption {
          type = lib.types.bool;
          default = false;
          defaultText = lib.literalExpression "false";
          description = ''
            Mark every challenge valid with no network check. Anyone
            who can reach this server can obtain a certificate for any
            name; the {option}`filter` section is then the only access
            control.
          '';
        };
      };
      filter = {
        rules = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = ''
            Names of `[filter.rule.<name>]` tables to evaluate, in
            order. First match wins. Empty disables filtering
            entirely (the daemon logs a `filter_disabled` warning
            at startup).
          '';
        };
        default = lib.mkOption {
          type = lib.types.enum [ "allow" "deny" ];
          default = "deny";
          defaultText = lib.literalExpression ''"deny"'';
          description = ''
            Decision when an applicable rule was evaluated and none
            matched.
          '';
        };
      };

      secretsFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/var/lib/secrets/acme-proxy/actalis.env";
        description = ''
          Absolute path to a file in systemd EnvironmentFile format
          (`KEY=value`, one per line). Loaded into the acme-proxy
          service's environment at activation time. Values can then
          be referenced through upstream's `ACME_PROXY_*` env-var
          override mechanism (e.g.
          `ACME_PROXY_SIGNER__RELAY__EAB__HMAC_KEY=...` in the file
          overrides `[signer.relay.eab] hmac_key` at startup). Two
          profiles that set the same variable override each other in
          systemd's usual last-wins fashion, so prefer unique names.

          The file is read directly from the host filesystem by
          systemd at activation; it is **not** stored in the Nix
          store, so it can be provisioned out of band — by hand,
          with a configuration management tool, or whatever you
          prefer. Source files should live outside the Nix store at
          a stable path, owned by `root:root` with mode `0400`
          (or `0440` for a dedicated management group).
        '';
      };
    };
  };

  # Translate a typed profile (the submodule) into the `[profiles.<name>]`
  # TOML table that ends up on disk. Only the keys the submodule knows
  # about are emitted here; user free-form keys are merged in by
  # `mergedProfiles` below.
  profileToTOML =
    profile:
    let
      relaySection = {
        directory_url = profile.signer.relay.directoryUrl;
        challenge_strategy = profile.signer.relay.challengeStrategy;
      }
      // lib.optionalAttrs (profile.signer.relay.challengeStrategy == "dns01") {
        dns01 = {
          provider = profile.signer.relay.dns01.provider;
          rfc2136 = {
            server = profile.signer.relay.dns01.rfc2136.server;
            zone = profile.signer.relay.dns01.rfc2136.zone;
            tsig_key_name = profile.signer.relay.dns01.rfc2136.tsigKeyName;
            tsig_key_secret = profile.signer.relay.dns01.rfc2136.tsigKeySecret;
            tsig_algorithm = profile.signer.relay.dns01.rfc2136.tsigAlgorithm;
          };
          propagation = {
            mode = profile.signer.relay.dns01.propagation.mode;
            delay_secs = profile.signer.relay.dns01.propagation.delaySecs;
          };
        };
      };
      signerSection =
        { backend = profile.signer.backend; }
        // lib.optionalAttrs (profile.signer.backend == "relay") {
          relay = relaySection;
        }
        // lib.optionalAttrs (profile.signer.backend == "local_ca") {
          local_ca = {
            leaf_validity_days = profile.signer.localCa.leafValidityDays;
          };
        }
        // lib.optionalAttrs (profile.signer.backend == "custom" && profile.signer.custom.scriptPath != null) {
          custom = {
            script_path = profile.signer.custom.scriptPath;
          };
        };
    in
    {
      signer = signerSection;
      challenge = {
        enabled = profile.challenge.enabled;
        bypass = profile.challenge.bypass;
      };
      filter = {
        rules = profile.filter.rules;
        default = profile.filter.default;
      };
    };

  typedProfiles = lib.mapAttrs (_: profileToTOML) cfg.profiles;

  # Free-form tables the user put under `settings.profiles.<name>` without
  # going through the typed option. Read straight from `cfg.settings` —
  # we deliberately do NOT write back to it from this module, so reading
  # and writing the same attribute (and the fixed-point cycle that would
  # entail) never happens.
  userProfiles = cfg.settings.profiles or { };

  # Final `[profiles.<name>]` tables written to config.toml. For each
  # profile name that appears in either typed or free-form input, the
  # typed `[signer]` / `[challenge]` / `[filter]` sections win over the
  # user's free-form versions; any other top-level keys the user supplied
  # at the lower level (e.g. `[ipam]`, `[eab]`, `[notify]`) are preserved.
  # Empty merged sections are dropped so the TOML on disk does not
  # contain placeholders the daemon would parse as the all-defaults
  # `[signer] backend = "local_ca"` profile — that would silently make
  # any free-form-only profile a `local_ca` issuer.
  knownSections = [
    "signer"
    "challenge"
    "filter"
  ];
  mergedProfiles = lib.genAttrs (lib.attrNames (typedProfiles // userProfiles)) (name:
    let
      typedP = typedProfiles.${name} or { };
      userP = userProfiles.${name} or { };
      freeOnlyKeys = lib.filterAttrs (k: _: !(builtins.elem k knownSections)) userP;
      signerMerged = (userP.signer or { }) // (typedP.signer or { });
      challengeMerged = (userP.challenge or { }) // (typedP.challenge or { });
      filterMerged = (userP.filter or { }) // (typedP.filter or { });
    in
    freeOnlyKeys
    // lib.optionalAttrs (signerMerged != { }) { signer = signerMerged; }
    // lib.optionalAttrs (challengeMerged != { }) { challenge = challengeMerged; }
    // lib.optionalAttrs (filterMerged != { }) { filter = filterMerged; }
  );

  # The rendered TOML configuration. Overrides `settings.profiles` with
  # the merged result so that whatever the user typed (or didn't) lands
  # in the file the daemon reads. When no profiles are declared at all,
  # `profiles` is omitted entirely so the daemon refuses to start with
  # a missing-profiles error rather than silently starting with none.
  renderedSettings = cfg.settings // lib.optionalAttrs (mergedProfiles != { }) {
    profiles = mergedProfiles;
  };
  configFile = tomlFormat.generate "acme-proxy.toml" renderedSettings;

  # Per-profile sanity checks. Two directions of mismatch are caught:
  #
  #   * `signer.backend = "relay"` with `signer.relay.directoryUrl = ""`
  #     — the daemon will refuse to start anyway, but a Nix-time error
  #     tells the user *which* profile is broken instead of a runtime
  #     complaint from a service the user may not know reads `signer.*`.
  #
  #   * `signer.backend != "relay"` (the default is `"local_ca"`) with
  #     `signer.relay.directoryUrl` non-empty — a silent footgun, since
  #     `profileToTOML` only emits the `[signer.relay]` table when
  #     `backend == "relay"`, so the user's relay config is dropped on
  #     the way to the rendered config file.
  profileAssertions = lib.concatLists (lib.mapAttrsToList
    (name: p: [
      {
        assertion = !(p.signer.backend == "relay" && p.signer.relay.directoryUrl == "");
        message = ''
          services.acme-proxy: profile "${name}" has
          `signer.backend = "relay"` but `signer.relay.directoryUrl = ""`;
          the daemon refuses to start without a directory URL. Set
          `signer.relay.directoryUrl` to the upstream CA's directory
          (e.g. `https://acme-v02.api.letsencrypt.org/directory`), or
          change `signer.backend` to something other than `"relay"`.
        '';
      }
      {
        assertion = !(p.signer.backend != "relay" && p.signer.relay.directoryUrl != "");
        message = ''
          services.acme-proxy: profile "${name}" sets
          `signer.relay.directoryUrl = "${p.signer.relay.directoryUrl}"`
          but `signer.backend = "${p.signer.backend}"` (not `"relay"`).
          Because `[signer.relay]` is only emitted when
          `signer.backend = "relay"`, the relay configuration would be
          silently dropped from the rendered TOML and the daemon would
          start as a `${p.signer.backend}` profile. Either set
          `signer.backend = "relay"`, or remove the relay settings.
        '';
      }
    ])
    cfg.profiles);
in
{
  meta.maintainers = [ lib.maintainers.ser ];

  options.services.acme-proxy = {
    enable = lib.mkEnableOption "acme-proxy ACME (RFC 8555) server";

    package = lib.mkPackageOption pkgs "acme-proxy" { };

    settings = lib.mkOption {
      type = tomlFormat.type;
      default = { };
      example = lib.literalExpression ''
        {
          server = {
            bind_address = "127.0.0.1:3000";
            base_url = "https://ca.example.com";
          };
        }
      '';
      description = ''
        Configuration written to {file}`/etc/acme-proxy/config.toml` (TOML).
        See [the upstream example](https://github.com/acme-proxy/acme-proxy/blob/master/config.toml.example)
        for the full schema. At least one ACME profile must be declared —
        see {option}`services.acme-proxy.profiles` for the typed
        interface — or the daemon refuses to start.

        Relative paths inside the configuration — the default `[database] url`,
        `[server.tls] cert_path`/`key_path`, `[signer.local_ca] cert_path`/
        `key_path`/`crl_path`, `[signer.relay] account_key_path`, and the
        autogenerated TLS material — are resolved against
        {option}`services.acme-proxy.dataDir` because the service runs with
        it as its working directory.

        Any value can be overridden at runtime by an environment variable
        prefixed with `ACME_PROXY_` (with `__` between table segments); the
        module does not set any of those, so the configuration file is the
        only source of truth.
      '';
    };

    profiles = lib.mkOption {
      type = lib.types.attrsOf profileType;
      default = { };
      example = lib.literalExpression ''
        {
          default = {
            signer.backend = "relay";
            signer.relay.directoryUrl = "https://acme-v02.api.letsencrypt.org/directory";
          };
        }
      '';
      description = ''
        ACME profiles exposed by this server. Each profile is mounted at
        {file}`/profile/<name>` and corresponds to a
        `[profiles.<name>]` table in the configuration file. This typed
        option covers the common profile fields; anything more exotic
        (e.g. `[ipam]`, `[eab]`, `[notify]`, per-type challenge settings)
        can be added directly through
        {option}`services.acme-proxy.settings.profiles.<name>` and the two
        are merged when the rendered TOML is generated — typed fields win
        for keys the submodule covers, free-form keys survive next to
        them.

        At least one profile is required, or the daemon refuses to start.
      '';
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/acme-proxy";
      defaultText = lib.literalExpression ''"/var/lib/acme-proxy"'';
      description = ''
        Directory holding the SQLite database, the CA's key and certificate,
        the autogenerated TLS material, and any relay upstream keys. The
        service runs with this directory as its working directory, so the
        relative paths in {option}`services.acme-proxy.settings` resolve
        here. Persisted across upgrades via systemd's `StateDirectory`.
      '';
    };

    openFirewall = lib.mkEnableOption ''
      opening the TCP port the ACME listener binds to (taken from
      `settings.server.bind_address`)'';

    openAdminFirewall = lib.mkEnableOption ''
      opening the TCP port the admin web UI binds to (taken from
      `settings.admin.bind_address`; only effective when
      `settings.admin.enabled = true`)'';

    openMetricsFirewall = lib.mkEnableOption ''
      opening the TCP port the Prometheus exposition binds to (taken from
      `settings.metrics.bind_address`; only effective when
      `settings.metrics.enabled = true`)'';
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = mergedProfiles != { };
        message = ''
          services.acme-proxy: at least one ACME profile must be declared
          via `services.acme-proxy.profiles.<name>` or
          `services.acme-proxy.settings.profiles.<name>`, otherwise the
          daemon refuses to start.
        '';
      }
    ] ++ profileAssertions ++ [
      {
        assertion = !(cfg.openFirewall && serverPort == null);
        message = "services.acme-proxy: openFirewall is set but the server port could not be parsed from settings.server.bind_address.";
      }
      {
        assertion = !(cfg.openAdminFirewall && adminEnabled && adminPort == null);
        message = "services.acme-proxy: openAdminFirewall is set but the admin port could not be parsed from settings.admin.bind_address.";
      }
      {
        assertion = !(cfg.openMetricsFirewall && metricsEnabled && metricsPort == null);
        message = "services.acme-proxy: openMetricsFirewall is set but the metrics port could not be parsed from settings.metrics.bind_address.";
      }
    ];

    environment.etc."acme-proxy/config.toml".source = configFile;

    systemd.services.acme-proxy = {
      description = "acme-proxy ACME (RFC 8555) server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      restartTriggers = [ configFile ];

      serviceConfig = {
        Type = "simple";
        UMask = "0077";
        # Run as a dynamic user allocated by systemd from the 60000-64999
        # range. systemd.exec(5): when DynamicUser=yes, User= and Group= are
        # ignored, and StateDirectory is materialized below /var/lib/private
        # with a /var/lib/<name> symlink so the service sees it as
        # /var/lib/acme-proxy.
        DynamicUser = true;
        # WorkingDirectory matches StateDirectory: the binary auto-generates
        # TLS material (server.pem/key, ca.pem/key, CRL, relay keys) and the
        # SQLite database relative to cwd on first boot.
        StateDirectory = "acme-proxy";
        WorkingDirectory = cfg.dataDir;
        Environment = "ACME_PROXY_CONFIG=/etc/acme-proxy/config.toml";
        # Per-profile EnvironmentFile= entries. Each profile may declare
        # one absolute path through `secretsFile`; systemd reads the files
        # at activation as root and exposes the resulting KEY=value
        # pairs as environment variables inside the unit. Two profiles
        # that set the same variable collide in systemd's usual
        # last-wins fashion — the user is expected to keep names unique.
        EnvironmentFile = lib.concatLists (lib.mapAttrsToList
          (_: p: lib.optional (p.secretsFile != null) (toString p.secretsFile))
          cfg.profiles);
        ExecStart = lib.getExe cfg.package;
        Restart = "on-failure";
        RestartSec = "5s";

        # Hardening: this process holds the CA private key and the SQLite
        # database. Lock it down like any other TLS-credentialed service.
        NoNewPrivileges = true;
        ProtectHome = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ReadWritePaths = cfg.dataDir;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        LockPersonality = "yes";
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" "~@privileged" "~@resources" ];
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
      };
    };

    networking.firewall.allowedTCPPorts = lib.concatLists [
      (lib.optional (cfg.openFirewall && serverPort != null) serverPort)
      (lib.optional (cfg.openAdminFirewall && adminPort != null) adminPort)
      (lib.optional (cfg.openMetricsFirewall && metricsPort != null) metricsPort)
    ];
  };
}