{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.archivebox;

  inherit (lib)
    literalExpression
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types
    ;

  # Build the final archivebox package with any user-supplied extra packages
  finalPackage = cfg.package.override {
    extraPackages = cfg.extraPackages;
  };
in
{
  options.services.archivebox = {
    enable = mkEnableOption "ArchiveBox, open source self-hosted web archiving";

    package = mkPackageOption pkgs "archivebox" { };

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/archivebox";
      description = "Directory where ArchiveBox stores its data (DATA_DIR).";
    };

    listenAddress = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = "IP address to bind the ArchiveBox server to.";
    };

    port = mkOption {
      type = types.port;
      default = 8000;
      description = "Port for the ArchiveBox server to listen on.";
    };

    extraPackages = mkOption {
      type = types.functionTo (types.listOf types.package);
      default = _: [ ];
      defaultText = literalExpression "python3Packages: []";
      example = literalExpression ''
        python3Packages: with python3Packages; [
          # Example: a custom abx-compatible plugin
          my-archivebox-plugin
        ]
      '';
      description = ''
        Additional Python packages to include in the ArchiveBox environment.

        This is the primary mechanism for adding
        [abx-compatible plugins](https://github.com/ArchiveBox/abx-plugins)
        to ArchiveBox. Plugins are Python packages that implement `abxbus` hooks
        and are auto-discovered when importable by the ArchiveBox process.

        The function receives the Python package set and must return a list of packages.
        For example:
        ```nix
        services.archivebox.extraPackages = ps: with ps; [ my-plugin ];
        ```
      '';
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = types.attrsOf (
          types.nullOr (
            types.oneOf [
              types.bool
              types.int
              types.str
            ]
          )
        );
        options = {
          PUBLIC_INDEX = mkOption {
            type = types.bool;
            default = true;
            description = "Allow unauthenticated access to the snapshot index.";
          };
          PUBLIC_SNAPSHOTS = mkOption {
            type = types.bool;
            default = true;
            description = "Allow unauthenticated access to snapshot content.";
          };
          PUBLIC_ADD_VIEW = mkOption {
            type = types.bool;
            default = false;
            description = "Allow unauthenticated users to submit new URLs for archiving.";
          };
          SEARCH_BACKEND_ENGINE = mkOption {
            type = types.enum [
              "ripgrep"
              "sonic"
            ];
            default = "ripgrep";
            description = ''
              Full-text search backend.

              - `ripgrep`: Simple grep-based search (default). No additional services required.
              - `sonic`: A faster, dedicated search server. Requires a running Sonic instance;
                set `SEARCH_BACKEND_HOST_NAME` and `SEARCH_BACKEND_PASSWORD` via
                {option}`services.archivebox.environmentFile`.
            '';
          };
          TIMEOUT = mkOption {
            type = types.int;
            default = 60;
            description = "Default timeout in seconds for individual archiving operations.";
          };
          CHECK_SSL_VALIDITY = mkOption {
            type = types.bool;
            default = true;
            description = "Validate TLS certificates when archiving HTTPS URLs.";
          };
          SERVER_SECURITY_MODE = mkOption {
            type = types.enum [
              "safe-subdomains-fullreplay"
              "safe-onedomain-nojsreplay"
              "unsafe-onedomain-noadmin"
              "danger-onedomain-fullreplay"
            ];
            default = "safe-subdomains-fullreplay";
            description = ''
              Controls how archived content is served.

              - `safe-subdomains-fullreplay` (default): Archived pages are replayed on isolated
                subdomains (`snap-*.archivebox.localhost`), providing XSS isolation.
                Requires wildcard DNS and a reverse proxy that supports wildcard virtual hosts.
              - `safe-onedomain-nojsreplay`: All content served under one domain with JavaScript
                disabled in replays. Safe without wildcard DNS.
              - `unsafe-onedomain-noadmin`: One domain, JS replay enabled, admin UI moved.
                Only use in trusted private networks.
              - `danger-onedomain-fullreplay`: Full replay on one domain. Not recommended.
            '';
          };
        };
      };
      default = { };
      description = ''
        ArchiveBox configuration passed as environment variables to the service.

        Settings use the same names as their environment variable counterparts.
        See the [ArchiveBox configuration wiki](https://github.com/ArchiveBox/ArchiveBox/wiki/Configuration)
        and `archivebox/config/` in the upstream source for all available options.

        Secrets (`SECRET_KEY`, `ADMIN_USERNAME`, `ADMIN_PASSWORD`, etc.) should be
        set via {option}`services.archivebox.environmentFile` instead.
      '';
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Path to an environment file that provides additional variables to the ArchiveBox service.

        Use this for secrets that must not appear in the Nix store, such as:
        - `SECRET_KEY=<random string>`
        - `ADMIN_USERNAME=admin`
        - `ADMIN_PASSWORD=<password>`
        - `SEARCH_BACKEND_PASSWORD=<sonic password>`

        The file must contain `KEY=value` pairs, one per line.
      '';
    };

    nginx = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Configure nginx as a reverse proxy for ArchiveBox.

          When enabled, an nginx virtual host is created at
          {option}`services.archivebox.nginx.domain` that proxies to the local
          ArchiveBox server.

          For the default `safe-subdomains-fullreplay` security mode you will also
          need a wildcard DNS entry (`*.domain`) pointing to the same host so that
          snapshot subdomains resolve correctly.
        '';
      };

      domain = mkOption {
        type = types.str;
        default = "";
        example = "archivebox.example.com";
        description = ''
          Primary domain name for the ArchiveBox nginx virtual host.

          When using `safe-subdomains-fullreplay` mode, wildcard DNS
          (`*.''${domain}`) must also resolve to this host.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.nginx.enable -> cfg.nginx.domain != "";
        message = "services.archivebox.nginx.domain must be set when services.archivebox.nginx.enable is true";
      }
    ];

    users.users.archivebox = {
      isSystemUser = true;
      group = "archivebox";
      home = cfg.dataDir;
      createHome = true;
    };
    users.groups.archivebox = { };

    systemd.services.archivebox = {
      description = "ArchiveBox self-hosted web archiving service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      environment = {
        DATA_DIR = cfg.dataDir;
        BIND_ADDR = "${cfg.listenAddress}:${toString cfg.port}";
      }
      // builtins.listToAttrs (
        lib.mapAttrsToList (
          k: v:
          lib.nameValuePair k (if builtins.isBool v then (if v then "True" else "False") else toString v)
        ) (lib.filterAttrs (_: v: v != null) cfg.settings)
      );

      serviceConfig = {
        User = "archivebox";
        Group = "archivebox";
        WorkingDirectory = cfg.dataDir;
        StateDirectory = lib.mkIf (cfg.dataDir == "/var/lib/archivebox") "archivebox";
        StateDirectoryMode = "0750";

        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;

        ExecStartPre = "${lib.getExe finalPackage} init --quick";
        ExecStart = "${lib.getExe finalPackage} server ${cfg.listenAddress}:${toString cfg.port}";
        Restart = "on-failure";
        RestartSec = "5s";

        # Hardening options
        PrivateDevices = true;
        PrivateIPC = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
        ];
        RestrictRealtime = true;
        LockPersonality = true;
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        SystemCallArchitectures = "native";

        # Chrome-based extractors use kernel namespaces and execute writable memory;
        # these two options must remain disabled for Chromium to function
        MemoryDenyWriteExecute = false;
        RestrictNamespaces = false;
      };
    };

    services.nginx = mkIf cfg.nginx.enable {
      enable = true;
      virtualHosts.${cfg.nginx.domain} = {
        locations."/" = {
          proxyPass = "http://${cfg.listenAddress}:${toString cfg.port}";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
          '';
        };
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ philocalyst ];
}
