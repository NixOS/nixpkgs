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

  # Schema for one `[filter.check.<name>]` entry. The `type` field
  # selects which built-in check the rest of the entry is interpreted
  # as; the other fields are type-specific. Everything besides `type`
  # defaults to `null` and is only emitted in the rendered TOML when
  # the user has set a value, so an empty typed entry (other than
  # `type`) doesn't pollute the config with `allow = []` placeholders
  # the daemon would treat as the literal allow-list.
  checkType = lib.types.submodule (
    { name, ... }: {
      options = {
        type = lib.mkOption {
          type = lib.types.enum [
            "allowed_ip"
            "path"
            "reverse_dns"
            "identifiers"
            "eab"
            "ipam"
            "custom"
          ];
          description = ''
            Which built-in check this is. The remaining fields are
            interpreted by the chosen type — the module does not
            enforce that the right fields are set, only that an
            unsupported type fails at evaluation rather than at
            daemon startup. See [the upstream filter docs](https://acme-proxy.github.io/acme-proxy/filters/checks.html)
            for the per-type semantics.
          '';
        };
        stages = lib.mkOption {
          type = lib.types.listOf (
            lib.types.enum [
              "connection"
              "identifiers"
            ]
          );
          default = [ ];
          description = ''
            Hooks at which to evaluate this check. Empty uses the
            type's built-in default.
          '';
        };
        allow = lib.mkOption {
          type = lib.types.nullOr (lib.types.listOf lib.types.str);
          default = null;
          description = ''
            Glob patterns that allow the request (e.g. CIDR for
            `allowed_ip`, URL paths for `path`).
          '';
        };
        deny = lib.mkOption {
          type = lib.types.nullOr (lib.types.listOf lib.types.str);
          default = null;
          description = ''
            Glob patterns that deny the request.
          '';
        };
        allowRegex = lib.mkOption {
          type = lib.types.nullOr (lib.types.listOf lib.types.str);
          default = null;
          description = ''
            Regular-expression versions of `allow`. Type-specific.
          '';
        };
        denyRegex = lib.mkOption {
          type = lib.types.nullOr (lib.types.listOf lib.types.str);
          default = null;
          description = ''
            Regular-expression versions of `deny`. Type-specific.
          '';
        };
        kids = lib.mkOption {
          type = lib.types.nullOr (lib.types.listOf lib.types.str);
          default = null;
          description = ''
            Exact ACME EAB key IDs allowed. Only meaningful for
            `type = "eab"`.
          '';
        };
        requireActive = lib.mkOption {
          type = lib.types.nullOr lib.types.bool;
          default = null;
          description = ''
            Require the EAB credential to be active. Only
            meaningful for `type = "eab"`.
          '';
        };
        allowedTypes = lib.mkOption {
          type = lib.types.nullOr (lib.types.listOf lib.types.str);
          default = null;
          description = ''
            Identifier types allowed. Only meaningful for
            `type = "identifiers"`.
          '';
        };
        allowWildcards = lib.mkOption {
          type = lib.types.nullOr lib.types.bool;
          default = null;
          description = ''
            Allow wildcard identifiers. Only meaningful for
            `type = "identifiers"`.
          '';
        };
        scriptPath = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            Absolute path to a custom check script. Required for
            `type = "custom"`.
          '';
        };
        timeoutMs = lib.mkOption {
          type = lib.types.nullOr lib.types.int;
          default = null;
          description = ''
            Per-check timeout in milliseconds. Default is
            type-specific.
          '';
        };
        passStdin = lib.mkOption {
          type = lib.types.nullOr lib.types.bool;
          default = null;
          description = ''
            Pipe request context to the custom script on stdin.
            Only meaningful for `type = "custom"`.
          '';
        };
        requireForwardConfirm = lib.mkOption {
          type = lib.types.nullOr lib.types.bool;
          default = null;
          description = ''
            Require the trusted-proxy header to confirm the
            original address. Only meaningful for
            `type = "reverse_dns"`.
          '';
        };
        args = lib.mkOption {
          type = lib.types.nullOr (lib.types.listOf lib.types.str);
          default = null;
          description = ''
            Extra positional arguments to pass to the custom
            script. Only meaningful for `type = "custom"`.
          '';
        };
      };
    }
  );

  # Schema for one `[filter.rule.<name>]` entry: a single boolean
  # expression over check names, evaluated upstream against the
  # request context.
  ruleType = lib.types.submodule {
    options = {
      when = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = "tenant-eab and not no-wildcards";
        description = ''
          Boolean expression over `[filter.check.<name>]`
          identifiers (with `and`, `or`, `not`, and parentheses)
          that, when true, makes the rule match. The empty
          string always matches. See [the upstream condition
          language](https://acme-proxy.github.io/acme-proxy/filters/policy.html)
          for the exact grammar — the policy parser is strict and
          rejects the rule at startup on a syntax error.
        '';
      };
      decision = lib.mkOption {
        type = lib.types.enum [
          "allow"
          "deny"
        ];
        description = ''
          Decision when this rule matches. Rendered as the TOML
          key `then`.
        '';
      };
      message = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Human-readable message recorded in logs when this
          rule matches.
        '';
      };
    };
  };

  # The schema for one profile declared through `services.acme-proxy.profiles`.
  # Translated into a `[profiles.<name>]` TOML table by `profileToTOML` below;
  # everything the user supplied under `settings.profiles.<name>` and the
  # typed option are merged at the rendered-config stage.
  profileType = lib.types.submodule {
    options = {
      signer = {
        backend = lib.mkOption {
          type = lib.types.enum [
            "local_ca"
            "relay"
            "custom"
          ];
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
            type = lib.types.enum [
              "bypass"
              "dns01"
              "http01"
            ];
            default = "bypass";
            defaultText = lib.literalExpression ''"bypass"'';
            description = ''
              How this proxy satisfies the upstream CA's domain-control
              check. `"bypass"` is only appropriate when the upstream
              trusts this server (a private CA, or another acme-proxy
              with `challenge.bypass = true`).
            '';
          };
          accountKeyPath = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            example = "actalis.key";
            description = ''
              Path (relative to the daemon's working directory, which the
              module sets to `dataDir`) of the file holding the
              ACME account key registered with the upstream CA. The
              rendered TOML key is `account_key_path`.

              `null` (the default) keeps the upstream default
              `upstream_account.key` — which is **the same path every
              other `relay` profile without an explicit override also
              resolves to**. Two `relay` profiles that share this path
              are allowed only if their `[signer]` sections are
              byte-for-byte identical; the module asserts this at
              evaluation. To run two independent relay accounts, set
              this to a per-profile filename.
            '';
          };
          contact = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            example = [ "mailto:admin@example.com" ];
            description = ''
              Contact URIs sent with `newAccount` to the upstream
              CA. The CA uses them for expiry warnings and policy
              notices, so each entry should usually be a
              `"mailto:..."` address that a human reads. Rendered as
              `[signer.relay] contact`. The empty list (the default)
              registers an account without any contacts.
            '';
          };
          pollIntervalMs = lib.mkOption {
            type = lib.types.int;
            default = 2000;
            defaultText = lib.literalExpression "2000";
            description = ''
              How often to poll an upstream order/authorization while
              it resolves, in milliseconds. Rendered as
              `[signer.relay] poll_interval_ms`.
            '';
          };
          pollTimeoutSecs = lib.mkOption {
            type = lib.types.int;
            default = 300;
            defaultText = lib.literalExpression "300";
            description = ''
              Total budget, in seconds, for one upstream issuance
              before the local order is marked invalid. Rendered as
              `[signer.relay] poll_timeout_secs`. The DNS-01
              {option}`services.acme-proxy.profiles.<name>.signer.relay.dns01.propagation.delaySecs`
              runs once per identifier in the order, so a multi-name
              order needs this set above `delaySecs × N` plus the
              time the upstream itself takes.
            '';
          };
          eab = {
            kid = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                External Account Binding key id issued by the
                upstream CA's operator, used to register this
                proxy's upstream account. Rendered as
                `[signer.relay.eab] kid`. Empty (the default) means
                "no configuration-file credential" — the daemon then
                expects a `.kid` sidecar from a previous
                registration, or one supplied through
                `ACME_PROXY_PROFILES__<NAME>__SIGNER__RELAY__EAB__KID`
                in one of this profile's
                {option}`services.acme-proxy.profiles.<name>.environmentFiles`.
                Setting `kid` non-empty requires `hmacKey` non-empty
                too; the module asserts this at evaluation time,
                mirroring the upstream startup error.
              '';
            };
            hmacKey = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                **Sensitive.** External Account Binding shared secret
                in base64 — url-safe, unpadded url-safe, or standard
                base64 are all accepted upstream. Rendered as
                `[signer.relay.eab] hmac_key`. Empty (the default)
                means "no configuration-file credential" — see `kid`
                above for the override paths.

                Prefer the env-var override mechanism — put
                `ACME_PROXY_PROFILES__<NAME>__SIGNER__RELAY__EAB__HMAC_KEY=<base64>`
                in one of this profile's
                {option}`services.acme-proxy.profiles.<name>.environmentFiles`,
                where `<NAME>` is the attribute name of this
                profile — over hard-coding the value here, which
                would put the secret in the Nix store. The
                `PROFILES__<NAME>__` prefix scopes the value to
                **this** profile only. The unscoped form
                `ACME_PROXY_SIGNER__RELAY__EAB__HMAC_KEY=...` sets
                the global value and is then inherited by every
                other profile that does not override it at the same
                path, so a credential intended for one profile
                would register upstream accounts for all of them.
              '';
            };
          };
          dns01 = {
            provider = lib.mkOption {
              type = lib.types.enum [ "rfc2136" ];
              default = "rfc2136";
              defaultText = lib.literalExpression ''"rfc2136"'';
              description = ''
                DNS-01 provider used to publish the TXT records the
                upstream CA asks for. Only `"rfc2136"` is implemented
                upstream; the option is typed as enum rather than as
                a free string so an unsupported value fails at
                evaluation rather than at daemon startup.
              '';
            };
            challengeAlias = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              example = "_acme-challenge.tldp.net.";
              description = ''
                Optional DNS-01 challenge label that the relay
                publishes and cleans up, overriding the default
                `_acme-challenge.<identifier>`. Rendered as
                `[signer.relay.dns01] challenge_alias`. The label
                must lie inside the configured `rfc2136.zone` (the
                daemon refuses to start otherwise), must not start
                with `_acme-challenge.` (the prefix is reserved for
                the default), and must not be a wildcard — the
                module asserts the last two at evaluation time.
                `null` (the default) keeps the upstream default
                `_acme-challenge.<identifier>`.

                The CA queries `_acme-challenge.<identifier>.<zone>`
                for the real identifier's zone, not the alias zone —
                so the alias is only useful when every identifier
                zone has a CNAME chain that ends at it. Each
                identifier's zone must be publicly delegated and
                resolvable from the public internet; the rfc2136
                server (and the zone it serves) does not need to be
                the public NS for that zone, but the alias target
                must be, otherwise the CA sees NXDOMAIN and the
                challenge fails. A wildcard like
                `*._acme-challenge   IN   CNAME   _acme-challenge.tldp.net.`
                in each identifier zone (with the trailing dot on
                the target so it isn't resolved relative to that
                zone) is the usual layout.
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
                  # Read the secret out of band — see environmentFiles.
                '';
                description = ''
                  TSIG key secret in **standard** base64 (as
                  `dnssec-keygen` and BIND emit it; not base64url).
                  Empty (the default) is a startup error upstream.

                  Prefer the env-var override mechanism — put
                  `ACME_PROXY_PROFILES__<NAME>__SIGNER__RELAY__DNS01__RFC2136__TSIG_KEY_SECRET=<base64>`
                  in one of this profile's `environmentFiles`, where
                  `<NAME>` is the attribute name of this profile under
                  {option}`services.acme-proxy.profiles` — over hard-coding
                  the value here, which would put the secret in the
                  Nix store.

                  The `PROFILES__<NAME>__` prefix scopes the value to
                  **this** profile only. The unscoped form
                  `ACME_PROXY_SIGNER__RELAY__DNS01__RFC2136__TSIG_KEY_SECRET=...`
                  sets the global value and is then inherited by every
                  other profile that does not override it at the same
                  path, which means a TSIG key intended for one profile
                  would sign DNS-01 challenges for all of them.
                '';
              };
              tsigAlgorithm = lib.mkOption {
                type = lib.types.enum [
                  "hmac-sha256"
                  "hmac-sha384"
                  "hmac-sha512"
                ];
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
                type = lib.types.enum [
                  "none"
                  "delay"
                ];
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
                  {option}`services.acme-proxy.profiles.<name>.signer.relay.pollTimeoutSecs`
                  (the relay's per-attempt budget), and the delay
                  runs once per name in the order — raise that
                  budget accordingly for a multi-name order.
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
          certPath = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            example = "actalis-ca.pem";
            description = ''
              Path (relative to the daemon's working directory, which the
              module sets to `dataDir`) of the issued CA certificate file.
              Rendered as `[signer.local_ca] cert_path`. `null` keeps the
              upstream default `ca.pem` — which is **the same path every
              other `local_ca` profile without an explicit override also
              resolves to**. Two `local_ca` profiles that share any of
              `cert_path`/`key_path`/`crl_path` are allowed only if their
              `[signer]` sections are byte-for-byte identical; the module
              asserts this at evaluation. To run two independent local
              CAs, set these to per-profile filenames.
            '';
          };
          keyPath = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            example = "actalis-ca.key";
            description = ''
              Path of the local CA's private key. Rendered as
              `[signer.local_ca] key_path`. See
              {option}`services.acme-proxy.profiles.<name>.signer.localCa.certPath`
              for the shared-defaults caveat.
            '';
          };
          crlPath = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            example = "actalis-ca.crl";
            description = ''
              Path of the local CA's certificate revocation list.
              Rendered as `[signer.local_ca] crl_path`. See
              {option}`services.acme-proxy.profiles.<name>.signer.localCa.certPath`
              for the shared-defaults caveat.
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
          type = lib.types.listOf (
            lib.types.enum [
              "http-01"
              "dns-01"
              "tls-alpn-01"
            ]
          );
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
          type = lib.types.enum [
            "allow"
            "deny"
          ];
          default = "deny";
          defaultText = lib.literalExpression ''"deny"'';
          description = ''
            Decision when an applicable rule was evaluated and none
            matched.
          '';
        };
        trustedProxies = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          example = [
            "10.0.0.0/8"
            "192.168.0.0/16"
          ];
          description = ''
            CIDR ranges whose `X-Forwarded-For` header is
            honored for this profile. Overrides the global
            {option}`services.acme-proxy.filter.trustedProxies`
            for this profile only. Per-profile override of
            `[filter] trusted_proxies` — only `rules`, `default`,
            and `trusted_proxies` are per-profile overrideable
            upstream; the rest of `[filter]` (the check and rule
            libraries) is global.
          '';
        };
        check = lib.mkOption {
          type = lib.types.attrsOf checkType;
          default = { };
          description = ''
            Library of named filter checks local to this profile.
            They are merged per-name with the global
            {option}`services.acme-proxy.settings.filter.check`
            and {option}`services.acme-proxy.filter.check`
            libraries; the profile's definition wins on collision.
            Use this for checks that are inherently profile-scoped
            (for example `type = "eab"` checks tied to one CA).
          '';
        };
        rule = lib.mkOption {
          type = lib.types.attrsOf ruleType;
          default = { };
          description = ''
            Library of named filter rules local to this profile.
            They are merged per-name with the global
            {option}`services.acme-proxy.settings.filter.rule`
            and {option}`services.acme-proxy.filter.rule`
            libraries; the profile's definition wins on collision.
          '';
        };
      };

      eab = {
        enabled = lib.mkOption {
          type = lib.types.bool;
          default = false;
          defaultText = lib.literalExpression "false";
          description = ''
            Refuse `newAccount` requests without a valid EAB
            credential. Per-profile override of `[eab] enabled`.
            The credentials themselves are managed out-of-band
            via `acme-proxy eab create|list|show|revoke` so a
            revocation takes effect without restarting the
            daemon — they never live in {file}`config.toml`.
          '';
        };
      };

      environmentFiles = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [ ];
        example = [
          "/var/lib/secrets/acme-proxy/common.env"
          "/var/lib/secrets/acme-proxy/actalis.env"
        ];
        description = ''
          Absolute paths to one or more files in systemd `EnvironmentFile=`
          format (`KEY=value`, one per line). All listed files are loaded
          into the acme-proxy service's environment at activation time, in
          the order given. Values can then be referenced through upstream's
          `ACME_PROXY_*` env-var override mechanism (e.g.
          `ACME_PROXY_SIGNER__RELAY__EAB__HMAC_KEY=...` in a file overrides
          `[signer.relay.eab] hmac_key` at startup). Files are joined in
          systemd's usual last-wins fashion — when the same variable is
          defined in multiple files, the one listed later wins — so prefer
          unique names.

          WARNING — environment values are not profile-scoped by default.
          The acme-proxy daemon overlays each profile on top of the
          GLOBAL section, so a key using the unscoped form below sets the
          global value and is then inherited by every other profile that
          does not set its own value at the same path:

            - `ACME_PROXY_SIGNER__...`           (EAB HMAC key, DNS-01 TSIG secret, PKCS#11 PIN, ...)
            - `ACME_PROXY_PROXY__HTTP_URL`       (proxy credentials in userinfo)
            - `ACME_PROXY_PROXY__HTTPS_URL`      (proxy credentials in userinfo)

          For per-profile secrets, use the scoped form, which binds
          directly to `[profiles.<NAME>.signer.*]` and is invisible to
          every other profile:

            - `ACME_PROXY_PROFILES__<NAME>__SIGNER__RELAY__EAB__HMAC_KEY=...`
            - `ACME_PROXY_PROFILES__<NAME>__SIGNER__RELAY__DNS01__RFC2136__TSIG_KEY_SECRET=...`
            - `ACME_PROXY_PROFILES__<NAME>__SIGNER__LOCAL_CA__PKCS11__PIN=...`

          where `<NAME>` is the attribute name of this profile under
          {option}`services.acme-proxy.profiles`.

          For values that should be visible to every profile (non-secret
          defaults, an egress proxy URL), use the daemon-wide
          {option}`services.acme-proxy.environmentFiles` instead.

          Files are read directly from the host filesystem by systemd at
          activation; they are **not** stored in the Nix store, so they
          can be provisioned out of band — by hand, with a configuration
          management tool, or whatever you prefer. Source files should
          live outside the Nix store at stable paths, owned by `root:root`
          with mode `0400` (or `0440` for a dedicated management group).
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
        contact = profile.signer.relay.contact;
        poll_interval_ms = profile.signer.relay.pollIntervalMs;
        poll_timeout_secs = profile.signer.relay.pollTimeoutSecs;
      }
      // lib.optionalAttrs (profile.signer.relay.accountKeyPath != null) {
        account_key_path = profile.signer.relay.accountKeyPath;
      }
      // lib.optionalAttrs (profile.signer.relay.eab.kid != ""
        && profile.signer.relay.eab.hmacKey != "") {
        # Gated on both fields being non-empty — same reason the
        # `tsig_key_secret` slot below is gated: upstream's
        # "TOML field present (even empty) > env var" precedence
        # would silently block the
        # `ACME_PROXY_PROFILES__<NAME>__SIGNER__RELAY__EAB__KID` /
        # `...__EAB__HMAC_KEY` env-var overrides otherwise. The
        # eval-time assertion below catches the case where the
        # user has set exactly one of the two fields.
        eab = {
          kid = profile.signer.relay.eab.kid;
          hmac_key = profile.signer.relay.eab.hmacKey;
        };
      }
      // lib.optionalAttrs (profile.signer.relay.challengeStrategy == "dns01") {
        dns01 = {
          provider = profile.signer.relay.dns01.provider;
        }
        // lib.optionalAttrs (profile.signer.relay.dns01.challengeAlias != null) {
          challenge_alias = profile.signer.relay.dns01.challengeAlias;
        }
        // {
          # `tsig_key_secret` is gated so the upstream env-var override
          # (`ACME_PROXY_SIGNER__RELAY__DNS01__RFC2136__TSIG_KEY_SECRET`
          # from the profile's `environmentFiles`) actually wins; upstream's
          # precedence is "TOML field present (even empty) > env var",
          # so emitting `tsig_key_secret = ""` would silently block the
          # override. The eval-time assertion below catches the case
          # where neither path is configured.
          rfc2136 = {
            server = profile.signer.relay.dns01.rfc2136.server;
            zone = profile.signer.relay.dns01.rfc2136.zone;
            tsig_key_name = profile.signer.relay.dns01.rfc2136.tsigKeyName;
            tsig_algorithm = profile.signer.relay.dns01.rfc2136.tsigAlgorithm;
          }
          // lib.optionalAttrs (profile.signer.relay.dns01.rfc2136.tsigKeySecret != "") {
            tsig_key_secret = profile.signer.relay.dns01.rfc2136.tsigKeySecret;
          };
          propagation = {
            mode = profile.signer.relay.dns01.propagation.mode;
            delay_secs = profile.signer.relay.dns01.propagation.delaySecs;
          };
        };
      };
      signerSection = {
        backend = profile.signer.backend;
      }
      // lib.optionalAttrs (profile.signer.backend == "relay") { relay = relaySection; }
      // lib.optionalAttrs (profile.signer.backend == "local_ca") {
        local_ca = {
          leaf_validity_days = profile.signer.localCa.leafValidityDays;
        }
        // lib.optionalAttrs (profile.signer.localCa.certPath != null) {
          cert_path = profile.signer.localCa.certPath;
        }
        // lib.optionalAttrs (profile.signer.localCa.keyPath != null) {
          key_path = profile.signer.localCa.keyPath;
        }
        // lib.optionalAttrs (profile.signer.localCa.crlPath != null) {
          crl_path = profile.signer.localCa.crlPath;
        };
      }
      //
        lib.optionalAttrs (profile.signer.backend == "custom" && profile.signer.custom.scriptPath != null)
          {
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
        trusted_proxies = profile.filter.trustedProxies;
      }
      // lib.optionalAttrs (profile.filter.check != { }) {
        check = lib.mapAttrs (_: checkToTOML) profile.filter.check;
      }
      // lib.optionalAttrs (profile.filter.rule != { }) {
        rule = lib.mapAttrs (_: ruleToTOML) profile.filter.rule;
      };
      eab = {
        enabled = profile.eab.enabled;
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
  # typed `[signer]` / `[challenge]` / `[filter]` / `[eab]` sections win
  # over the user's free-form versions; any other top-level keys the
  # user supplied at the lower level (e.g. `[ipam]`, `[notify]`) are
  # preserved. Empty merged sections are dropped so the TOML on disk
  # does not contain placeholders the daemon would parse as the
  # all-defaults `[signer] backend = "local_ca"` profile — that would
  # silently make any free-form-only profile a `local_ca` issuer.
  knownSections = [
    "signer"
    "challenge"
    "filter"
    "eab"
  ];
  mergedProfiles = lib.genAttrs (lib.attrNames (typedProfiles // userProfiles)) (
    name:
    let
      typedP = typedProfiles.${name} or { };
      userP = userProfiles.${name} or { };
      freeOnlyKeys = lib.filterAttrs (k: _: !(builtins.elem k knownSections)) userP;
      signerMerged = (userP.signer or { }) // (typedP.signer or { });
      challengeMerged = (userP.challenge or { }) // (typedP.challenge or { });
      filterMerged =
        let
          base = (userP.filter or { }) // (typedP.filter or { });
          checkMerged = (userP.filter.check or { }) // (typedP.filter.check or { });
          ruleMerged = (userP.filter.rule or { }) // (typedP.filter.rule or { });
        in
        base
        // lib.optionalAttrs (checkMerged != { }) { check = checkMerged; }
        // lib.optionalAttrs (ruleMerged != { }) { rule = ruleMerged; };
      eabMerged = (userP.eab or { }) // (typedP.eab or { });
    in
    freeOnlyKeys
    // lib.optionalAttrs (signerMerged != { }) { signer = signerMerged; }
    // lib.optionalAttrs (challengeMerged != { }) { challenge = challengeMerged; }
    // lib.optionalAttrs (filterMerged != { }) { filter = filterMerged; }
    // lib.optionalAttrs (eabMerged != { }) { eab = eabMerged; }
  );

  # Top-level [filter] rendering. Scalar keys (`rules`, `default`,
  # `trusted_proxies`, `forwarded_header`) come from the typed
  # option when the user set them (`!= null`) and otherwise from
  # the free-form `settings.filter`; the check and rule sub-tables
  # merge per-name (typed entries win on collision, free-form-only
  # entries survive). Any other top-level key the user supplied
  # free-form (e.g. an upstream field the module does not yet
  # type) is preserved.
  userTopFilter = cfg.settings.filter or { };

  emitFilterScalar =
    tomlKey: typedValue:
    let
      v = if typedValue != null then typedValue else userTopFilter.${tomlKey} or null;
    in
    lib.optionalAttrs (v != null) { ${tomlKey} = v; };

  checkToTOML =
    c:
    {
      type = c.type;
    }
    // lib.optionalAttrs (c.stages != [ ]) { stages = c.stages; }
    // lib.optionalAttrs (c.allow != null) { allow = c.allow; }
    // lib.optionalAttrs (c.deny != null) { deny = c.deny; }
    // lib.optionalAttrs (c.allowRegex != null) { allow_regex = c.allowRegex; }
    // lib.optionalAttrs (c.denyRegex != null) { deny_regex = c.denyRegex; }
    // lib.optionalAttrs (c.kids != null) { kids = c.kids; }
    // lib.optionalAttrs (c.requireActive != null) { require_active = c.requireActive; }
    // lib.optionalAttrs (c.allowedTypes != null) { allowed_types = c.allowedTypes; }
    // lib.optionalAttrs (c.allowWildcards != null) { allow_wildcards = c.allowWildcards; }
    // lib.optionalAttrs (c.scriptPath != null) { script_path = c.scriptPath; }
    // lib.optionalAttrs (c.timeoutMs != null) { timeout_ms = c.timeoutMs; }
    // lib.optionalAttrs (c.passStdin != null) { pass_stdin = c.passStdin; }
    // lib.optionalAttrs (c.requireForwardConfirm != null) {
      require_forward_confirm = c.requireForwardConfirm;
    }
    // lib.optionalAttrs (c.args != null) { args = c.args; };

  ruleToTOML =
    r:
    {
      when = r.when;
    }
    // {
      "then" = r.decision;
    }
    // lib.optionalAttrs (r.message != null) { message = r.message; };

  typedChecks = lib.mapAttrs (_: checkToTOML) cfg.filter.check;
  typedRules = lib.mapAttrs (_: ruleToTOML) cfg.filter.rule;
  checkMerged = (userTopFilter.check or { }) // typedChecks;
  ruleMerged = (userTopFilter.rule or { }) // typedRules;

  freeFilterOther = lib.filterAttrs (
    k: _:
    !(builtins.elem k [
      "rules"
      "default"
      "trusted_proxies"
      "forwarded_header"
      "check"
      "rule"
    ])
  ) userTopFilter;

  topLevelFilterSection =
    freeFilterOther
    // emitFilterScalar "rules" cfg.filter.rules
    // emitFilterScalar "default" cfg.filter.default
    // emitFilterScalar "trusted_proxies" cfg.filter.trustedProxies
    // emitFilterScalar "forwarded_header" cfg.filter.forwardedHeader
    // lib.optionalAttrs (checkMerged != { }) { check = checkMerged; }
    // lib.optionalAttrs (ruleMerged != { }) { rule = ruleMerged; };

  # Explicit `[database]` table. Upstream's built-in default is the relative
  # `sqlite://sqlite.db`, resolved against the daemon's cwd (= dataDir). The
  # module always writes an absolute `sqlite://${dataDir}/sqlite.db` instead,
  # so the file path is unambiguous in the rendered config and the user has a
  # single knob — `settings.database.url` — to point it elsewhere (a different
  # on-disk path, or a `postgres://...` URL for a multi-node deployment). Any
  # other field the user supplies under `settings.database` is preserved.
  databaseTable = (cfg.settings.database or { }) // {
    url = cfg.settings.database.url or "sqlite://${cfg.dataDir}/sqlite.db";
  };

  # The rendered TOML configuration. Overrides `settings.profiles` and
  # `settings.filter` with the merged result so that whatever the user
  # typed (or didn't) lands in the file the daemon reads. When no
  # profiles are declared at all, `profiles` is omitted entirely so
  # the daemon refuses to start with a missing-profiles error rather
  # than silently starting with none. `filter` is omitted only when
  # nothing was declared at all (typed or free-form). `database` is
  # always present — see `databaseTable` above.
  renderedSettings =
    cfg.settings
    // {
      database = databaseTable;
    }
    // lib.optionalAttrs (mergedProfiles != { }) { profiles = mergedProfiles; }
    // lib.optionalAttrs (topLevelFilterSection != { }) { filter = topLevelFilterSection; };
  configFile = tomlFormat.generate "acme-proxy.toml" renderedSettings;

  # Per-profile sanity checks. Four families of mismatch are caught:
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
  #
  #   * `signer.relay.challengeStrategy = "dns01"` with any required
  #     `[signer.relay.dns01.rfc2136]` field left empty — the daemon
  #     will refuse to start upstream at `newOrder` time with a TSIG /
  #     BIND error; better to fail at Nix eval so the user sees which
  #     profile. `tsig_key_secret` is special: it can legitimately be
  #     empty in TOML when the value comes through the env-var override
  #     mechanism. The secret can live in any of these files:
  #       - a per-profile `environmentFiles` entry
  #         (`ACME_PROXY_PROFILES__<NAME>__SIGNER__RELAY__DNS01__RFC2136__TSIG_KEY_SECRET=...`
  #         — scoped, no cross-profile leak)
  #       - the daemon-wide `services.acme-proxy.environmentFiles` list
  #         (same `PROFILES__<NAME>__` form is still the right choice when
  #         only one profile needs DNS-01; the unscoped form is also
  #         possible but would set the global value and be inherited by
  #         every other profile that does not override it)
  #     so the assertion accepts `tsigKeySecret != ""` OR
  #     `p.environmentFiles != []` OR `cfg.environmentFiles != []`.
  #
  #   * `signer.backend = "custom"` with `signer.custom.scriptPath = null`
  #     — `profileToTOML` only emits the `[signer.custom]` table when a
  #     script path is set, so the backend would have no signer script to
  #     dispatch to.
  profileAssertions = lib.concatLists (
    lib.mapAttrsToList (
      name: p:
      let
        isRelayWithDns01 = p.signer.backend == "relay" && p.signer.relay.challengeStrategy == "dns01";
      in
      [
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
        {
          assertion = !(isRelayWithDns01 && p.signer.relay.dns01.rfc2136.server == "");
          message = ''
            services.acme-proxy: profile "${name}" has
            `signer.relay.challengeStrategy = "dns01"` but
            `signer.relay.dns01.rfc2136.server = ""`. Set it to the
            `host:port` of the authoritative DNS server that accepts
            RFC 2136 updates from this proxy, or change
            `signer.relay.challengeStrategy` to `"bypass"` or `"http01"`.
          '';
        }
        {
          assertion = !(isRelayWithDns01 && p.signer.relay.dns01.rfc2136.zone == "");
          message = ''
            services.acme-proxy: profile "${name}" has
            `signer.relay.challengeStrategy = "dns01"` but
            `signer.relay.dns01.rfc2136.zone = ""`. Set it to the zone
            the dynamic update targets (with the trailing dot, e.g.
            `"example.com."`), or change `signer.relay.challengeStrategy`.
          '';
        }
        {
          assertion = !(isRelayWithDns01 && p.signer.relay.dns01.rfc2136.tsigKeyName == "");
          message = ''
            services.acme-proxy: profile "${name}" has
            `signer.relay.challengeStrategy = "dns01"` but
            `signer.relay.dns01.rfc2136.tsigKeyName = ""`. Set it to
            the TSIG key name matching the `key "<name>" { ... };`
            clause in `named.conf` on the authoritative server, or
            change `signer.relay.challengeStrategy`.
          '';
        }
        {
          assertion =
            !(isRelayWithDns01
              && p.signer.relay.dns01.rfc2136.tsigKeySecret == ""
              && p.environmentFiles == [ ]
              && cfg.environmentFiles == [ ]);
          message = ''
            services.acme-proxy: profile "${name}" has
            `signer.relay.challengeStrategy = "dns01"` but no TSIG
            secret is reachable — `signer.relay.dns01.rfc2136.tsigKeySecret`
            is empty and both the profile's `environmentFiles` and the
            daemon-wide `services.acme-proxy.environmentFiles` are
            unset (the lists are empty).

            Set `tsigKeySecret` to the secret in standard base64 (as
            `dnssec-keygen` and BIND emit it), or add a file containing
            `ACME_PROXY_PROFILES__${name}__SIGNER__RELAY__DNS01__RFC2136__TSIG_KEY_SECRET=<base64>`
            to the profile's `environmentFiles` (or to the daemon-wide
            `services.acme-proxy.environmentFiles` if multiple profiles
            genuinely share the same TSIG key). The `PROFILES__<NAME>__`
            prefix scopes the value to this profile; the unscoped form
            `ACME_PROXY_SIGNER__RELAY__DNS01__RFC2136__TSIG_KEY_SECRET=...`
            would set the global value and leak into every other profile
            that does not override it.
          '';
        }
        {
          assertion = !(isRelayWithDns01 && p.signer.relay.dns01.challengeAlias != null
            && (lib.hasPrefix "*." p.signer.relay.dns01.challengeAlias
              || lib.hasPrefix "_acme-challenge." p.signer.relay.dns01.challengeAlias));
          message = ''
            services.acme-proxy: profile "${name}" sets
            `signer.relay.dns01.challengeAlias = "${
              # `challengeAlias` is `nullOr str`; the assertion gate only
              # fires this message when it is non-null, but the module
              # framework deep-force-evaluates every assertion's message
              # when *any* assertion fails, so a raw `"${...}"` would
              # crash with "cannot coerce null to a string" before the
              # actual failed-assertion list is printed. Render `null`
              # as a placeholder so the formatter always sees a string.
              if p.signer.relay.dns01.challengeAlias == null then "<unset>" else p.signer.relay.dns01.challengeAlias
            }"`
            but the daemon refuses to start on this value: a wildcard
            prefix (`*.`) is not allowed, and the `_acme-challenge.`
            prefix is reserved for the default label that the relay
            already publishes. Either drop the option (the default
            `_acme-challenge.<identifier>` is what you want in most
            cases), or pick a different label inside the configured
            `rfc2136.zone`.
          '';
        }
        {
          assertion = p.signer.backend != "custom" || p.signer.custom.scriptPath != null;
          message = "services.acme-proxy: profile \"${name}\" has signer.backend = \"custom\" but signer.custom.scriptPath is unset. Set it to the absolute path of the signing script.";
        }
        {
          assertion = !(p.signer.backend == "relay"
            && (p.signer.relay.eab.kid != "") != (p.signer.relay.eab.hmacKey != ""));
          message = ''
            services.acme-proxy: profile "${name}" sets only one of
            `[signer.relay.eab] kid` and `[signer.relay.eab] hmac_key`
            (typed values: `kid = "${
              if p.signer.relay.eab.kid == "" then "<empty>" else "<set>"
            }"`, `hmacKey = "${
              if p.signer.relay.eab.hmacKey == "" then "<empty>" else "<set>"
            }"`). The daemon refuses to start when exactly one of the
            two is configured; both must be empty (no
            configuration-file credential) or both non-empty.

            Prefer the env-var override mechanism — set
            `ACME_PROXY_PROFILES__${name}__SIGNER__RELAY__EAB__KID`
            and
            `ACME_PROXY_PROFILES__${name}__SIGNER__RELAY__EAB__HMAC_KEY`
            in one of this profile's `environmentFiles` (or in the
            daemon-wide `services.acme-proxy.environmentFiles`) — over
            putting them in configuration, since `hmacKey` ends up in
            the Nix store. The `PROFILES__<NAME>__` prefix scopes
            each value to **this** profile only; the unscoped form
            would set the global value and be inherited by every
            other profile that does not override it.
          '';
        }
      ]
    ) cfg.profiles
  );

  # Per-profile filter checks. A typed check that has the same name as a
  # global check is refused at eval time: upstream merges the two per-key,
  # so the global check would silently stop being selectable for that
  # profile. An `eab`-typed check under a profile whose `eab.enabled` is
  # false is also refused, because upstream fails at startup in that case.
  filterAssertions =
    let
      globalCheckNames = lib.attrNames ((cfg.settings.filter.check or { }) // cfg.filter.check);
    in
    lib.concatLists (
      lib.mapAttrsToList (
        name: p:
        let
          profileCheckNames = lib.attrNames p.filter.check;
          shadowed = lib.filter (n: builtins.elem n globalCheckNames) profileCheckNames;
          eabChecks = lib.filter (n: p.filter.check.${n}.type == "eab") profileCheckNames;
        in
        lib.optional (shadowed != [ ]) {
          assertion = false;
          message = ''
            services.acme-proxy: profile "${name}" declares typed filter check(s) that shadow global filter check(s): ${lib.concatStringsSep ", " shadowed}.
            Per-profile checks merge per-key with global checks upstream, so the global check is no longer selectable for this profile. Rename the profile check or remove the global one.
          '';
        }
        ++ lib.optional (p.eab.enabled == false && eabChecks != [ ]) {
          assertion = false;
          message = ''
            services.acme-proxy: profile "${name}" has `eab.enabled = false` but declares EAB-typed filter check(s): ${lib.concatStringsSep ", " eabChecks}.
            Upstream treats an `eab` check under a profile whose `eab.enabled` is false as a startup error. Either enable EAB for this profile or change the check type.
          '';
        }
      ) cfg.profiles
    );

  # Per-profile signer-path conflict check. The acme-proxy daemon refuses to
  # start when two profiles share a path their `[signer]` section owns but
  # their `[signer]` sections differ (the daemon would otherwise have two
  # backends writing to the same file). Mirroring that check at eval time
  # turns the failure from a runtime crash into a NixOS assertion.
  #
  #   - `relay` contributes `account_key_path` (default
  #     `upstream_account.key`),
  #   - `local_ca` contributes `cert_path`/`key_path`/`crl_path`
  #     (defaults `ca.pem`/`ca.key`/`ca.crl`),
  #   - `custom` contributes nothing (the daemon never opens a file for it).
  #
  # Two profiles sharing a path **with byte-for-byte identical `[signer]`
  # sections** is supported upstream: the daemon shares one backend instance
  # between them. We only fire when the shared-path group contains more than
  # one distinct signer table.
  signerPathAssertions =
    let
      # Upstream defaults for the file paths a `[signer]` section can own.
      # The module never sets these, so the daemon reads its own defaults
      # when the user did not override them through `settings.profiles.*`.
      signerDefaults = {
        relay = {
          account_key_path = "upstream_account.key";
        };
        local_ca = {
          cert_path = "ca.pem";
          key_path = "ca.key";
          crl_path = "ca.crl";
        };
      };

      # Resolve the (path, field) pairs a single profile would own at
      # startup. Defaults from `signerDefaults` are only applied when the
      # user did not set the field, so a user override is respected even
      # when it matches an upstream default.
      profileEntries = name: signer:
        let
          backend = signer.backend or "local_ca";
          def = signerDefaults.${backend} or { };
        in
        if backend == "relay" then [
          {
            profile = name;
            field = "relay.account_key_path";
            path = signer.relay.account_key_path or def.account_key_path;
            signerTable = signer;
          }
        ]
        else if backend == "local_ca" then [
          {
            profile = name;
            field = "local_ca.cert_path";
            path = signer.local_ca.cert_path or def.cert_path;
            signerTable = signer;
          }
          {
            profile = name;
            field = "local_ca.key_path";
            path = signer.local_ca.key_path or def.key_path;
            signerTable = signer;
          }
          {
            profile = name;
            field = "local_ca.crl_path";
            path = signer.local_ca.crl_path or def.crl_path;
            signerTable = signer;
          }
        ]
        else [ ];

      # Flatten every (profile, field) pair over the post-merge profile map.
      # `custom` profiles contribute nothing and never appear below.
      allEntries = lib.concatLists (
        lib.mapAttrsToList (name: p: profileEntries name (p.signer or { })) mergedProfiles
      );

      # Group by path; a group is a conflict iff the profiles sharing it
      # declare structurally different `[signer]` tables.
      byPath = lib.groupBy (e: e.path) allEntries;
      conflicts = lib.filterAttrs (_: es:
        builtins.length (lib.unique (map (e: e.signerTable) es)) > 1
      ) byPath;
    in
    lib.mapAttrsToList (path: es: {
      assertion = false;
      message = ''
        services.acme-proxy: profiles ${lib.concatStringsSep ", " (map (e: "\"${e.profile}\"") es)} share the `[signer]`-owned file path `${path}` (${lib.concatStringsSep ", " (lib.unique (map (e: "`${e.field}`") es))}) but their `[signer]` sections differ.
        The acme-proxy daemon refuses to start with "two backends over one file would overwrite each other's state". Either give each profile its own path (e.g. set `services.acme-proxy.settings.profiles.<name>.signer.${(lib.head es).field}` to a profile-specific filename), or make the profiles' `[signer]` sections byte-for-byte identical so they share one upstream account or one CA — the docs note two such profiles share one backend instance, which is both supported and cheaper.
      '';
    }) conflicts;

  # ----- Top-level / per-profile config-shape checks the daemon enforces
  # at startup but that the typed schema does not (or cannot) catch. The
  # shape is intentionally narrow: each entry mirrors one startup error
  # message from `crates/core/src/config/` and `crates/policy/src/filter/build.rs`.
  # Numbers in the inline comments match the gap list in the audit.

  # (1) Profile names must match `^[a-z0-9-]+$`; the daemon refuses others.
  profileNameAssertions = let
    nameRe = "^[a-z0-9-]+$";
    bad = lib.filter (n: builtins.match nameRe n == null) (lib.attrNames mergedProfiles);
  in lib.optional (bad != [ ]) {
    assertion = false;
    message = ''
      services.acme-proxy: profile name(s) ${lib.concatStringsSep ", " (map (n: "`\"${n}\"`") bad)} do not match the upstream pattern `${nameRe}`.
      The acme-proxy daemon refuses to start with "profile name must match `[a-z0-9-]+`". Rename them.
    '';
  };

  # (2) `filter.rules` references must name an existing `[filter.rule.<n>]`,
  # and each name must match the daemon's regex and avoid the policy-language
  # reserved words. Applies both top-level and per-profile (per-profile
  # rules are evaluated against the per-profile rule library).
  filterRulesAssertions = let
    nameRe = "^[a-z0-9-]+$";
    reserved = [ "and" "or" "not" ];
    checkOne = label: rules: ruleLib: let
      # The global `services.acme-proxy.filter.rules` is
      # `nullOr (listOf str)` with `null` meaning "not set"; a free-form
      # profile table may omit `rules` entirely. Both mean "no rules
      # referenced" for this check.
      names = if rules == null then [ ] else rules;
      ruleDefs = if ruleLib == null then { } else ruleLib;
      defined = lib.attrNames ruleDefs;
      undefined = lib.filter (n: !(builtins.elem n defined)) names;
      invalid = lib.filter (n: builtins.match nameRe n == null || builtins.elem n reserved) names;
    in (lib.optional (undefined != [ ]) {
      assertion = false;
      message = ''
        services.acme-proxy: ${label} `filter.rules` references undefined rule name(s) ${lib.concatStringsSep ", " (map (n: "`\"${n}\"`") undefined)}.
        The daemon refuses to start. Either add a `[filter.rule.<name>]` table for each, or remove the reference.
      '';
    }) ++ (lib.optional (invalid != [ ]) {
      assertion = false;
      message = ''
        services.acme-proxy: ${label} `filter.rules` contains name(s) ${lib.concatStringsSep ", " (map (n: "`\"${n}\"`") invalid)} that don't match the upstream regex `${nameRe}` or are reserved (${lib.concatStringsSep ", " reserved}).
        The daemon refuses to start. Rename them — the policy language uses `and` / `or` / `not` as operators, not as rule names.
      '';
    });
  in (checkOne "top-level" cfg.filter.rules cfg.filter.rule)
  ++ lib.concatLists (lib.mapAttrsToList (name: p: let
    flt = p.filter or { };
  in checkOne "profile `\"${name}\"`" (flt.rules or [ ]) (flt.rule or { })) mergedProfiles);

  # (3) `challenge.enabled` must be non-empty per profile. The typed default
  # is `[ "http-01" ]`, so a typed profile cannot violate this — the check
  # only catches free-form overrides that clear the list.
  challengeEnabledAssertions = lib.concatLists (lib.mapAttrsToList (name: p: let
    enabled = (p.challenge or { }).enabled or null;
  in lib.optional (enabled == [ ]) {
    assertion = false;
    message = ''
      services.acme-proxy: profile "${name}" has empty `challenge.enabled` (override under `settings.profiles."${name}".challenge.enabled = []`).
      The acme-proxy daemon refuses to start. Add at least one of `"http-01"`, `"dns-01"`, `"tls-alpn-01"`, or remove the override (the typed default is `[ "http-01" ]`).
    '';
  }) mergedProfiles);

  # (7) `filter.check.<n>.type ∈ { "allowed_ip", "path" }` requires at least
  # one of `allow` / `deny` non-null. The typed submodule allows both to be
  # null (they default to `null` so the daemon's type-specific defaults
  # apply), so without this check the daemon flat-out refuses to start
  # for these two check types in particular. Applies to both the top-level
  # and per-profile check libraries.
  checkAllowDenyAssertions = let
    checkOne = label: c: lib.optional
      ((c.type == "allowed_ip" || c.type == "path")
        && (c.allow or null) == null
        && (c.deny or null) == null)
      {
        assertion = false;
        message = ''
          services.acme-proxy: ${label} `[filter.check]` of type `"${c.type}"` has both `allow` and `deny` unset.
          The acme-proxy daemon refuses to start. Set at least one of `allow` or `deny` to a non-empty glob list, or change `type`.
        '';
      };
  in lib.concatLists (lib.mapAttrsToList (n: c: checkOne "top-level" c) cfg.filter.check)
  ++ lib.concatLists (lib.mapAttrsToList (name: p: let
    flt = p.filter or { };
  in lib.concatLists (lib.mapAttrsToList (n: c: checkOne "profile `\"${name}\"`" c) (flt.check or { }))) mergedProfiles);

  # (8) `filter.trustedProxies` entries must parse as a bare IP address or
  # CIDR. The typed option is `listOf str`, so any string passes Nix-side;
  # the daemon crashes on `1.2.3.4/33` or `not-an-ip` at startup. Validate
  # each entry before it lands in the rendered config. Applies both
  # top-level and per-profile.
  isValidCidrOrAddress = s: let
    # Parse "addr" or "addr/prefix" (no `?` non-capturing group in
    # `builtins.match`, so the slash+prefix is its own capturing group
    # at index 1; the prefix number is at index 2).
    parsed = builtins.match "([^/]+)(/([0-9]+))?" s;
  in if parsed == null then false
     else let
       addr = builtins.elemAt parsed 0;
       prefix = builtins.elemAt parsed 2;
       # IPv4: 4 octets each 0..255.
       v4 = let
         m = builtins.match "([0-9]{1,3})\\.([0-9]{1,3})\\.([0-9]{1,3})\\.([0-9]{1,3})" addr;
         octetsOk = m != null
           && (let octets = map lib.toInt m;
               in builtins.all (o: o >= 0 && o <= 255) octets);
       in octetsOk;
       # IPv6: hex groups + colons, must contain at least one colon.
       # (The `ipnetwork` crate in the daemon accepts the full RFC
       # grammar; we only need to catch the common typo class — a value
       # that obviously isn't a network address.)
       v6 = lib.hasInfix ":" addr
         && builtins.match "[0-9a-fA-F:]+" addr != null;
       maxPfx = if v4 then 32 else if v6 then 128 else null;
       pfxOk = prefix == null
         || (maxPfx != null
             && (let p = lib.toInt prefix; in p >= 0 && p <= maxPfx));
     in (v4 || v6) && pfxOk;
  trustedProxiesAssertions = let
    checkOne = label: xs: let
      # The global `services.acme-proxy.filter.trustedProxies` is
      # `nullOr (listOf str)` with `null` meaning "not set"; a free-form
      # profile table may omit the key entirely.
      entries = if xs == null then [ ] else xs;
      bad = lib.filter (e: !(isValidCidrOrAddress (toString e))) entries;
    in lib.optional (bad != [ ]) {
      assertion = false;
      message = ''
        services.acme-proxy: ${label} `filter.trustedProxies` contains ${lib.concatStringsSep ", " (map (e: "`\"${toString e}\"`") bad)} — not a valid IP address or CIDR.
        The acme-proxy daemon refuses to start. Use a bare IP (`10.0.0.1`, `2001:db8::1`) or CIDR (`10.0.0.0/8`, `2001:db8::/32`).
      '';
    };
  in (checkOne "top-level" cfg.filter.trustedProxies)
  ++ lib.concatLists (lib.mapAttrsToList (name: p: let
    flt = p.filter or { };
  in checkOne "profile `\"${name}\"`" (flt.trustedProxies or [ ])) mergedProfiles);

  # Helpers for the bind-address checks (4/5/6) below. Strip a trailing
  # `:PORT` (handling `[host]:port` for IPv6) and return the host portion.
  # Used by `isLoopbackBind`; not exposed outside this let-block.
  bindHost = addr: let
    m = builtins.match "(.*):([0-9]+)" addr;
  in if m == null then addr else builtins.elemAt m 0;
  isLoopbackBind = addr: let
    h = bindHost addr;
  in h == "127.0.0.1" || lib.hasPrefix "127." h || h == "::1" || h == "[::1]";
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

        The module always writes a `[database]` table with
        `url = "sqlite://''${dataDir}/sqlite.db"` — the daemon's
        working directory is {option}`services.acme-proxy.dataDir`, so this
        places the SQLite file under it. Override `settings.database.url`
        to relocate it (e.g. a different on-disk path, or a
        `postgres://user:pass@host/db` URL for a multi-node deployment).
        Any other field under `settings.database` is forwarded as-is.

        Relative paths inside the configuration — `[server.tls] cert_path`/
        `key_path`, `[signer.local_ca] cert_path`/`key_path`/`crl_path`,
        `[signer.relay] account_key_path`, and the autogenerated TLS material
        — are resolved against {option}`services.acme-proxy.dataDir`
        because the service runs with it as its working directory.

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

    environmentFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      example = [ "/etc/acme-proxy/shared.env" ];
      description = ''
        Absolute paths to one or more files in systemd `EnvironmentFile=`
        format (`KEY=value`, one per line). Loaded into the acme-proxy
        service's environment at activation time, in the order given,
        **before** every profile's own
        {option}`services.acme-proxy.profiles.<name>.environmentFiles`.
        Use this option for `KEY=value` pairs that should be visible to
        every profile — non-secret defaults (e.g. `ACME_PROXY_LOG__LEVEL`)
        or upstream credentials that genuinely apply to the whole daemon
        (e.g. a single egress proxy).

        WARNING — environment values are not profile-scoped by default.
        The acme-proxy daemon overlays each profile on top of the
        GLOBAL section, so a key using the unscoped form below sets the
        global value and is then inherited by every other profile that
        does not set its own value at the same path:

          - `ACME_PROXY_SIGNER__...`           (EAB HMAC key, DNS-01 TSIG secret, PKCS#11 PIN, ...)
          - `ACME_PROXY_PROXY__HTTP_URL`       (proxy credentials in userinfo)
          - `ACME_PROXY_PROXY__HTTPS_URL`      (proxy credentials in userinfo)

        For per-profile secrets, declare them in the profile's own
        `environmentFiles` using the scoped form, which binds directly
        to `[profiles.<NAME>.signer.*]` and is invisible to every other
        profile:

          - `ACME_PROXY_PROFILES__<NAME>__SIGNER__RELAY__EAB__HMAC_KEY=...`
          - `ACME_PROXY_PROFILES__<NAME>__SIGNER__RELAY__DNS01__RFC2136__TSIG_KEY_SECRET=...`
          - `ACME_PROXY_PROFILES__<NAME>__SIGNER__LOCAL_CA__PKCS11__PIN=...`

        where `<NAME>` is the attribute name of the profile under
        {option}`services.acme-proxy.profiles`.

        Files are joined in systemd's usual last-wins fashion — when the
        same variable is defined in multiple files, the one listed later
        wins. Per-profile files are listed after these top-level files,
        so a per-profile file with the same key overrides a top-level
        one. Prefer unique names; do not rely on this.

        Files are read directly from the host filesystem by systemd at
        activation; they are **not** stored in the Nix store, so they
        can be provisioned out of band — by hand, with a configuration
        management tool, or whatever you prefer. Source files should
        live outside the Nix store at stable paths, owned by `root:root`
        with mode `0400` (or `0440` for a dedicated management group).
      '';
    };

    filter = lib.mkOption {
      type = lib.types.submodule {
        options = {
          rules = lib.mkOption {
            type = lib.types.nullOr (lib.types.listOf lib.types.str);
            default = null;
            example = [
              "allow-internal"
              "default-deny"
            ];
            description = ''
              Names of `[filter.rule.<name>]` tables to evaluate
              in order at the global level. First match wins. A
              profile's
              {option}`services.acme-proxy.profiles.<name>.filter.rules`
              overrides this list for the profile's identifiers.
            '';
          };
          default = lib.mkOption {
            type = lib.types.nullOr (
              lib.types.enum [
                "allow"
                "deny"
              ]
            );
            default = null;
            defaultText = lib.literalExpression ''"deny"'';
            description = ''
              Decision when no rule matched. Upstream's default
              is `"deny"`. A profile's
              {option}`services.acme-proxy.profiles.<name>.filter.default`
              overrides this for the profile.
            '';
          };
          trustedProxies = lib.mkOption {
            type = lib.types.nullOr (lib.types.listOf lib.types.str);
            default = null;
            example = [
              "10.0.0.0/8"
              "192.168.0.0/16"
            ];
            description = ''
              CIDR ranges whose `forwardedHeader` is honored
              globally. Honored by the `reverse_dns` check and
              any other check that consults the client address.
              A profile's
              {option}`services.acme-proxy.profiles.<name>.filter.trustedProxies`
              overrides this for the profile.
            '';
          };
          forwardedHeader = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            defaultText = lib.literalExpression ''"x-forwarded-for"'';
            description = ''
              Header name carrying the original client address
              when the request comes through a trusted proxy.
              Global only — upstream does not expose this as a
              per-profile override.
            '';
          };
          check = lib.mkOption {
            type = lib.types.attrsOf checkType;
            default = { };
            description = ''
              Library of named filter checks. Per-profile rules
              may reference any name in this global set; checks
              themselves are not per-profile overrideable.
            '';
          };
          rule = lib.mkOption {
            type = lib.types.attrsOf ruleType;
            default = { };
            description = ''
              Library of named filter rules. Per-profile
              `rules` lists which of these to apply; the
              definitions themselves are not per-profile
              overrideable.
            '';
          };
        };
      };
      default = { };
      example = lib.literalExpression ''
        {
          default = "deny";
          trustedProxies = [ "10.0.0.0/8" ];
          check.internal-ips = {
            type = "allowed_ip";
            allow = [ "10.0.0.0/8" ];
          };
          rule.allow-internal = {
            when = "check.internal-ips";
            decision = "allow";
          };
        }
      '';
      description = ''
        Global `[filter]` section, the policy engine that decides
        whether to serve a request before any profile logic runs.
        The check and rule sub-tables are libraries shared by all
        profiles; per-profile
        {option}`services.acme-proxy.profiles.<name>.filter.{rules,
        default, trustedProxies}` overrides the matching key for
        that profile (only `rules`, `default`, and `trusted_proxies`
        are per-profile overrideable upstream).

        Equivalent to declaring the same fields through
        {option}`services.acme-proxy.settings.filter`; the typed
        option is preferred because it surfaces upstream's schema
        and gives Nix-time errors on typos.
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
    environment.systemPackages = [ cfg.package ];

    # The daemon reads its configuration through the systemd credential
    # installed below, but the rendered file is also exposed at the
    # documented path so admins and tooling can inspect it on the host.
    environment.etc."acme-proxy/config.toml".source = configFile;

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
      {
        assertion = builtins.all (entries: builtins.all (e: lib.hasPrefix "/" (toString e)) entries) (
          lib.mapAttrsToList (_: p: p.environmentFiles) cfg.profiles
        );
        message = "services.acme-proxy: every entry of environmentFiles must be an absolute path.";
      }
    ]
    ++ profileAssertions
    ++ filterAssertions
    ++ signerPathAssertions
    ++ profileNameAssertions
    ++ filterRulesAssertions
    ++ challengeEnabledAssertions
    ++ checkAllowDenyAssertions
    ++ trustedProxiesAssertions
    ++ [
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
      # (4) `admin.bind_address` must differ from `server.bind_address`.
      {
        assertion = !(adminEnabled && adminBind == serverBind);
        message = ''
          services.acme-proxy: `settings.admin.bind_address` ("${adminBind}") is the same as `settings.server.bind_address` ("${serverBind}").
          The acme-proxy daemon refuses to start with "admin bind address must differ from server bind address". Set `settings.admin.bind_address` to a different value (or `settings.admin.enabled = false` to disable the admin listener).
        '';
      }
      # (5) `metrics.bind_address` must differ from `server.bind_address`
      # and (when admin is also enabled) from `admin.bind_address`.
      {
        assertion = !(metricsEnabled && metricsBind == serverBind);
        message = ''
          services.acme-proxy: `settings.metrics.bind_address` ("${metricsBind}") is the same as `settings.server.bind_address` ("${serverBind}").
          The acme-proxy daemon refuses to start with "metrics bind address must differ from server bind address". Set `settings.metrics.bind_address` to a different value (or `settings.metrics.enabled = false` to disable the metrics listener).
        '';
      }
      {
        assertion = !(adminEnabled && metricsEnabled && metricsBind == adminBind);
        message = ''
          services.acme-proxy: `settings.metrics.bind_address` ("${metricsBind}") is the same as `settings.admin.bind_address` ("${adminBind}").
          The acme-proxy daemon refuses to start with "metrics bind address must differ from admin bind address". Set `settings.metrics.bind_address` to a different value.
        '';
      }
      # (6) A non-loopback admin listener requires `admin.tls.enabled = true`.
      {
        assertion = !(adminEnabled
          && !(isLoopbackBind adminBind)
          && !(cfg.settings.admin.tls.enabled or false));
        message = ''
          services.acme-proxy: `settings.admin.bind_address` ("${adminBind}") is not loopback (e.g. 127.0.0.1, ::1) but `settings.admin.tls.enabled` is not true.
          The acme-proxy daemon refuses to start. Either bind the admin listener to a loopback address or set `settings.admin.tls.enabled = true` (and configure `settings.admin.tls.cert_path` / `key_path` — the daemon will generate a self-signed pair if both are absent, but only when TLS is explicitly enabled).
        '';
      }
    ];

    systemd.services.acme-proxy = {
      description = "acme-proxy ACME (RFC 8555) server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      restartTriggers = [
        configFile
      ]
      ++ lib.map toString cfg.environmentFiles
      ++ lib.concatMap (p: lib.map toString p.environmentFiles) (
        lib.mapAttrsToList (_: p: p) cfg.profiles
      );

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
        StateDirectoryMode = "0700";
        WorkingDirectory = cfg.dataDir;
        LoadCredential = "config.toml:${configFile}";
        # %d is the unit's credentials directory (systemd.exec(5)), which is
        # where LoadCredential above installs the rendered file. Do not use
        # %C here: that is the cache directory root (/var/cache), which does
        # not exist, and the daemon then silently starts with built-in
        # defaults instead of the configured profiles.
        Environment = "ACME_PROXY_CONFIG=%d/config.toml";
        # EnvironmentFile= entries: first the daemon-wide list declared
        # through `services.acme-proxy.environmentFiles`, then the union
        # of all per-profile `environmentFiles`. systemd reads the files
        # at activation as root, in the order given, and exposes the
        # resulting KEY=value pairs as environment variables inside the
        # unit. Two files (across the daemon-wide list, across profiles,
        # or within the same profile's list) that set the same variable
        # collide in systemd's usual last-wins fashion — keep names
        # unique, and prefer the `ACME_PROXY_PROFILES__<NAME>__` form
        # for per-profile secrets so they do not leak into other profiles
        # via the global section.
        EnvironmentFile =
          lib.map toString cfg.environmentFiles
          ++ lib.concatMap (p: lib.map toString p.environmentFiles) (
            lib.mapAttrsToList (_: p: p) cfg.profiles
          );
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
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        PrivateDevices = true;
        MemoryDenyWriteExecute = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectClock = true;
        RemoveIPC = true;
        DeviceAllow = [
          "/dev/null rw"
          "/dev/urandom r"
        ];
        DevicePolicy = "strict";
        CapabilityBoundingSet = "";
        AmbientCapabilities = "";
      };
    };

    networking.firewall.allowedTCPPorts = lib.concatLists [
      (lib.optional (cfg.openFirewall && serverPort != null) serverPort)
      (lib.optional (cfg.openAdminFirewall && adminPort != null) adminPort)
      (lib.optional (cfg.openMetricsFirewall && metricsPort != null) metricsPort)
    ];
  };
}
