{ config, lib, pkgs, ... }:

let
  inherit (lib) types;
  cfg = config.services.acme-dns;
in

{
  options.services.acme-dns = {
    enable = lib.mkOption {
      type = types.bool;
      default = false;
      description = let
        readme =
          "${cfg.package.meta.homepage}/blob/v${cfg.package.version}/README.md";
      in ''
        Enable the acme-dns server.

        acme-dns allows for easy and secure configuration of ACME DNS-01
        validation, which allows for the issuance of wildcard
        certificates, using ACME TLS certificates even in the absence of
        a public HTTP server, and separating out certificate renewal
        responsibilities from the web server.

        Unlike most implementations of DNS-01 challenges, acme-dns
        doesn't require dealing with DNS-provider-specific hooks or API
        keys that give total control over your DNS zones; instead, it
        implements a single-purpose DNS server to respond to
        <literal>_acme-challenge</literal> requests, and an HTTP API
        to register new domains and update the challenge records.

        To set the server up, you'll need to ensure that the nameservers
        for <option>services.acme-dns.general.domain</option> delegate
        to the machine running acme-dns; see the
        <link xlink:href="${readme}#dns-records">acme-dns
        documentation</link> for more details.

        To use the server for ACME certificates, set
        <option>security.acme.certs.*.dnsProvider</option> to
        <literal>"acme-dns"</literal> and
        <option>credentialsFile</option> to, e.g.:

        <screen>
        pkgs.writeText "lego-example.com.env" '''
          ACME_DNS_API_BASE=http://localhost:8053
          ACME_DNS_STORAGE_PATH=/var/lib/acme/example.com/acme-dns.json
        '''
        </screen>

        Note that you will have to manually add a CNAME record for the
        <literal>_acme-challenge</literal> subdomain to your main
        authoritative DNS server to complete registration; check
        <command>journalctl --unit='acme-dns-*.service'</command>
        after switching to the the new system configuration to get the
        required DNS record to copy.
      '';
    };

    package = lib.mkOption {
      type = types.package;
      default = pkgs.acme-dns;
      description = ''
        acme-dns package to use.
      '';
    };

    general = lib.mkOption {
      description = "General configuration.";
      default = {};
      type = types.submodule {
        options = {
          listen = lib.mkOption {
            type = types.str;
            description = "Interface to listen on for DNS.";
            default = ":53";
          };

          protocol = lib.mkOption {
            type = types.enum [
              "udp" "udp4" "udp6"
              "tcp" "tcp4" "tcp6"
              "both" "both4" "both6"
            ];
            description = ''
              DNS protocols to service (UDP/TCP/both, IPv4/IPv6/both).
            '';
            default = "both";
          };

          domain = lib.mkOption {
            type = types.str;
            description = ''
              Domain name to serve DNS records for, without
              trailing <literal>"."</literal>.
            '';
            example = "acme-dns.example.com";
          };

          nsname = lib.mkOption {
            type = types.nullOr types.str;
            description = ''
              The primary name server for <option>domain</option>,
              without trailing <literal>"."</literal>; used for the
              MNAME field of SOA responses.

              Defaults to <option>domain</option>, which is probably
              what you want (unless your authoritative DNS provider
              doesn't support glue records).
            '';
            default = null;
            defaultText = "config.services.acme-dns.general.domain";
            example = "acme-dns.example.com";
          };

          nsadmin = lib.mkOption {
            type = types.str;
            description = ''
              Admin email address for SOA responses in RNAME format,
              with <literal>"@"</literal> replaced by
              <literal>"."</literal> and no trailing <literal>"."</literal>.

              If your email address's local-part has a
              <literal>"."</literal> in it, escape it like so:
              <literal>firstname\.lastname.example.com</literal>
            '';
            example = "hostmaster.example.com";
          };

          records = lib.mkOption {
            type = types.listOf types.str;
            description = ''
              Static DNS records to serve.

              Make sure to add the A/AAAA/CNAME/NS records for
              <option>domain</option> to the authoritative DNS server
              for your root domain too.
            '';
            example = [
              "acme-dns.example.com. A your.ip.v4.address"
              "acme-dns.example.com. AAAA your:ip:v6::address"
              "acme-dns.example.com. NS acme-dns.example.com."
              "acme-dns.example.com. CAA 0 issue \"letsencrypt.org\""
            ];
          };

          debug = lib.mkOption {
            type = types.bool;
            description = "Enable debug messages (CORS, ...?).";
            default = false;
          };
        };
      };
    };

    database = lib.mkOption {
      description = "Database backend.";
      default = {};
      type = types.submodule {
        options = {
          engine = lib.mkOption {
            type = types.enum [ "sqlite3" "postgres" ];
            description = "Database engine.";
            default = "sqlite3";
          };

          connection = lib.mkOption {
            type = types.str;
            description = "Database connection string.";
            default = "/var/lib/acme-dns/acme-dns.db";
            # TODO: allow specification via file for passwords?
            example = "postgres://acme-dns@localhost/acme-dns";
          };
        };
      };
    };

    api = lib.mkOption {
      description = "HTTP API configuration.";
      default = {};
      type = types.submodule {
        options = {
          ip = lib.mkOption {
            type = types.str;
            description = "Host to listen on.";
            default = "localhost";
          };

          port = lib.mkOption {
            type = types.int;
            description = "Port to listen on.";
            default = 8053;
          };

          disable_registration = lib.mkOption {
            type = types.bool;
            description = ''
              Disables the registration endpoint. Note that this will
              prevent new domains in the client configurations from
              being automatically registered, so ensure that
              <literal>acme-dns-*.service</literal> succeed before
              you enable this.
            '';
            default = false;
          };

          tls = lib.mkOption {
            # `cert` is deliberately not supported, as it's a hazard for
            # bootstrapping when the certificate expires; see
            # https://github.com/joohoi/acme-dns/blob/v0.8/README.md#https-api.
            #
            # If you really want to use it, this can be overridden
            # with `extraConfig`.
            type = types.enum [ "none" "letsencrypt" "letsencryptstaging" ];
            description = ''
              TLS backend to use. You should set this to
              <option>letsencrypt</option> if exposing the API over
              the internet.
            '';
            default = "none";
          };

          acme_cache_dir = lib.mkOption {
            type = types.path;
            description = ''
              Directory to store ACME data for the HTTP API TLS
              certificate in when <option>tls = "letsencrypt"</option>.
            '';
            default = "/var/lib/acme-dns/api-certs";
            internal = true;
          };

          corsorigins = lib.mkOption {
            type = types.listOf types.str;
            description = "CORS allowed origins.";
            default = [ "*" ];
          };

          use_header = lib.mkOption {
            type = types.bool;
            description = ''
              Get client IP from HTTP header
              (see <option>header_name</option>).
            '';
            default = false;
          };

          header_name = lib.mkOption {
            type = types.str;
            description = "HTTP header name for <option>use_header</option>.";
            default = "X-Forwarded-For";
          };
        };
      };
    };

    logconfig = lib.mkOption {
      description = "Logging configuration.";
      default = {};
      type = types.submodule {
        options = {
          loglevel = lib.mkOption {
            type = types.enum [ "debug" "info" "warning" "error" ];
            description = "Minimum logging level.";
            default = "debug";
          };

          logtype = lib.mkOption {
            type = types.enum [ "stdout" ];
            default = "stdout";
            # not currently customizable upstream
            internal = true;
          };

          logformat = lib.mkOption {
            type = types.enum [ "text" "json" ];
            description = "Logging format.";
            default = "text";
          };
        };
      };
    };

    extraConfig = lib.mkOption {
      # TODO: use YAML type instead
      type = types.attrs;
      description = "Unchecked additional configuration.";
      default = {};
    };

    configText = lib.mkOption {
      type = types.nullOr types.lines;
      description = ''
        Literal TOML configuration text. Overrides other configuration
        options if set.
      '';
      default = null;
    };
  };

  config = let
    configFile = if cfg.configText != null
      then pkgs.writeText "acme-dns.toml" cfg.configText
      else let
        baseConfig = {
          general = cfg.general //
            lib.optionalAttrs (cfg.general.nsname == null)
              { nsname = cfg.general.domain; };
          inherit (cfg) database;
          # TODO: https://github.com/joohoi/acme-dns/issues/218
          api = cfg.api // { port = toString cfg.api.port; };
          inherit (cfg) logconfig;
        };

        fullConfig = lib.recursiveUpdate baseConfig cfg.extraConfig;
      in pkgs.runCommand "acme-dns.toml" {} ''
        ${pkgs.remarshal}/bin/json2toml -o $out \
          <<<${lib.escapeShellArg (builtins.toJSON fullConfig)}
      '';
  in lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !lib.hasInfix "@" cfg.general.nsadmin;
        message = ''
          Option services.acme-dns.general.nsadmin should contain a
          valid DNS SOA RNAME-format email address with the "@" replaced
          with ".".
        '';
      }
    ];

    users.users.acme-dns.group = "acme-dns";
    users.groups.acme-dns = {};

    systemd.services.acme-dns = {
      description = "acme-dns server";

      # We use network-online.target to ensure that acme-dns can reach
      # Let's Encrypt to renew its own HTTPS API certificate on
      # startup. This might be unnecessary if acme-dns is robust
      # enough to properly retry, in which case this could be removed.
      #
      # Note that this should probably *not* be replaced with
      # network.target unless necessary; see
      # https://www.freedesktop.org/wiki/Software/systemd/NetworkTarget/.
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      # Run in an isolated filesystem namespace.
      confinement.enable = true;
      confinement.binSh = null;

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/acme-dns -c ${configFile}";

        Restart = "always";
        RestartSec = "10s";
        StartLimitInterval = "1min";

        # Set up /var/lib/acme-dns with appropriate permissions.
        StateDirectory = "acme-dns";
        StateDirectoryMode = "0700";

        # Mount / as a read-only tmpfs, overriding the default mutable
        # mount used by systemd-confinement.
        #
        # TODO: Remove if/when #64405 is merged.
        TemporaryFileSystem = lib.mkOverride 10 "/:ro";

        # Allow some ubiquitous /etc configuration files.
        BindReadOnlyPaths = [
          "-/etc/ld-nix.so.preload"
          "-/etc/localtime"
          "-/etc/nsswitch.conf"
          "-/etc/resolv.conf"
          "-/etc/hosts"
        ];

        User = "acme-dns";
        Group = "acme-dns";

        # Needs CAP_NET_BIND_SERVICE for binding to privileged ports.
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];

        # NoNewPrivileges is implied by confinement.enable and multiple
        # other things we set here, but `systemd-analyze security`
        # wants to see it anyway.
        NoNewPrivileges = true;

        # UMask = "0022" would make new files accessible only to the
        # service user (and get us -0.1 delicious exposure points from
        # systemd-analyze(1)), but results in a status=203/EXEC error on
        # start, even when stubbing the ExecStart out with echo (maybe
        # because of things the systemd sandboxing setup does?).
        #
        # TODO: Figure out what's up here and consider enabling it.

        # We don't enable ProtectSystem, as it's redundant to
        # confinement.enable and exposes a lot of the filesystem (albeit
        # as read-only). 0.2 exposure points are unfairly given to us by
        # systemd-analyze(1) as a result. :(

        # See ProtectSystem, but this one is harmless, so we turn it on.
        ProtectHome = true;

        # PrivateTmp is implied by confinement.enable.

        # PrivateDevices is implied by confinement.enable.

        # We can't use PrivateUsers, although we'd like to, because it
        # unconditionally runs processes with no privileges on the host,
        # and we need CAP_NET_BIND_SERVICE. This could be solved with
        # socket activation support in acme-dns, or proxying.
        #
        # TODO: Add configuration to systemd-confinement for this?
        PrivateUsers = lib.mkOverride 10 false;

        # Don't allow changing hostname.
        ProtectHostname = true;

        # ProtectClock is redundant with CapabilityBoundingSet,
        # SystemCallFilter, and PrivateDevices. We don't set it because
        # it unnecessarily grants read permission for the RTC device, at
        # the expense of 0.2 exposure points from systemd-analyze(1).

        # No need to access kernel logs.
        ProtectKernelLogs = true;

        # Restrict the process to IP sockets.
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];

        # Don't allow the process to use unprivileged user namespaces
        # even if enabled in the kernel; they're unneeded and have been
        # the cause of security bugs in the past.
        RestrictNamespaces = true;

        # Unusual personalities/architectures can have obscure bugs, and
        # we have no need for them.
        LockPersonality = true;

        # No JIT, so no need for W+X memory.
        MemoryDenyWriteExecute = true;

        # No need for realtime scheduling.
        RestrictRealtime = true;

        # Disallow creation of setuid/setgid files.
        RestrictSUIDSGID = true;

        # Don't leave IPC objects lying around.
        RemoveIPC = true;

        # PrivateMounts is redundant with confinement.enable.

        # Restrict the set of available system calls.
        # See also `systemd-analyze syscall-filter`.
        SystemCallFilter = [
          "@system-service"

          # Disallow admin-only syscalls, adjusting resource limits,
          # changing groups, and kernel keyring access.
          "~@privileged @resources @setuid @keyring"
        ];
        SystemCallErrorNumber = "EPERM";

        # See LockPersonality.
        SystemCallArchitectures = "native";
      };
    };
  };
}
