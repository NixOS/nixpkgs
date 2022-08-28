{ config, lib, pkgs, utils, ... }:

with lib;

let
  cfg = config.services.cockroachdb;
  crdb = cfg.package;

  startupCommand = utils.escapeSystemdExecArgs
    ([
      # Basic startup
      "${crdb}/bin/cockroach"
      "start"
      "--logtostderr"
      "--store=/var/lib/cockroachdb"

      # WebUI settings
      "--http-addr=${cfg.http.address}:${toString cfg.http.port}"

      # Cluster listen address
      "--listen-addr=${cfg.listen.address}:${toString cfg.listen.port}"

      # Cache and memory settings.
      "--cache=${cfg.cache}"
      "--max-sql-memory=${cfg.maxSqlMemory}"

      # Certificate/security settings.
      (if cfg.insecure then "--insecure" else "--certs-dir=${cfg.certsDir}")
    ]
    ++ lib.optional (cfg.join != null) "--join=${cfg.join}"
    ++ lib.optional (cfg.locality != null) "--locality=${cfg.locality}"
    ++ cfg.extraArgs);

  addressOption = descr: defaultPort: {
    address = mkOption {
      type = types.str;
      default = "localhost";
      description = lib.mdDoc "Address to bind to for ${descr}";
    };

    port = mkOption {
      type = types.port;
      default = defaultPort;
      description = lib.mdDoc "Port to bind to for ${descr}";
    };
  };
in

{
  options = {
    services.cockroachdb = {
      enable = mkEnableOption (lib.mdDoc "CockroachDB Server");

      listen = addressOption "intra-cluster communication" 26257;

      http = addressOption "http-based Admin UI" 8080;

      locality = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          An ordered, comma-separated list of key-value pairs that describe the
          topography of the machine. Topography might include country,
          datacenter or rack designations. Data is automatically replicated to
          maximize diversities of each tier. The order of tiers is used to
          determine the priority of the diversity, so the more inclusive
          localities like country should come before less inclusive localities
          like datacenter.  The tiers and order must be the same on all nodes.
          Including more tiers is better than including fewer. For example:

          <programlisting>
              country=us,region=us-west,datacenter=us-west-1b,rack=12
              country=ca,region=ca-east,datacenter=ca-east-2,rack=4

              planet=earth,province=manitoba,colo=secondary,power=3
          </programlisting>
        '';
      };

      join = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = lib.mdDoc "The addresses for connecting the node to a cluster.";
      };

      insecure = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Run in insecure mode.";
      };

      certsDir = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = lib.mdDoc "The path to the certificate directory.";
      };

      user = mkOption {
        type = types.str;
        default = "cockroachdb";
        description = lib.mdDoc "User account under which CockroachDB runs";
      };

      group = mkOption {
        type = types.str;
        default = "cockroachdb";
        description = lib.mdDoc "User account under which CockroachDB runs";
      };

      openPorts = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Open firewall ports for cluster communication by default";
      };

      cache = mkOption {
        type = types.str;
        default = "25%";
        description = lib.mdDoc ''
          The total size for caches.

          This can be a percentage, expressed with a fraction sign or as a
          decimal-point number, or any bytes-based unit. For example,
          `"25%"`, `"0.25"` both represent
          25% of the available system memory. The values
          `"1000000000"` and `"1GB"` both
          represent 1 gigabyte of memory.

        '';
      };

      maxSqlMemory = mkOption {
        type = types.str;
        default = "25%";
        description = lib.mdDoc ''
          The maximum in-memory storage capacity available to store temporary
          data for SQL queries.

          This can be a percentage, expressed with a fraction sign or as a
          decimal-point number, or any bytes-based unit. For example,
          `"25%"`, `"0.25"` both represent
          25% of the available system memory. The values
          `"1000000000"` and `"1GB"` both
          represent 1 gigabyte of memory.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.cockroachdb;
        defaultText = literalExpression "pkgs.cockroachdb";
        description = lib.mdDoc ''
          The CockroachDB derivation to use for running the service.

          This would primarily be useful to enable Enterprise Edition features
          in your own custom CockroachDB build (Nixpkgs CockroachDB binaries
          only contain open source features and open source code).
        '';
      };

      extraArgs = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "--advertise-addr" "[fe80::f6f2:::]" ];
        description = lib.mdDoc ''
          Extra CLI arguments passed to {command}`cockroach start`.
          For the full list of supported argumemnts, check <https://www.cockroachlabs.com/docs/stable/cockroach-start.html#flags>
        '';
      };
    };
  };

  config = mkIf config.services.cockroachdb.enable {
    assertions = [
      { assertion = !cfg.insecure -> cfg.certsDir != null;
        message = "CockroachDB must have a set of SSL certificates (.certsDir), or run in Insecure Mode (.insecure = true)";
      }
    ];

    environment.systemPackages = [ crdb ];

    users.users = optionalAttrs (cfg.user == "cockroachdb") {
      cockroachdb = {
        description = "CockroachDB Server User";
        uid         = config.ids.uids.cockroachdb;
        group       = cfg.group;
      };
    };

    users.groups = optionalAttrs (cfg.group == "cockroachdb") {
      cockroachdb.gid = config.ids.gids.cockroachdb;
    };

    networking.firewall.allowedTCPPorts = lib.optionals cfg.openPorts
      [ cfg.http.port cfg.listen.port ];

    systemd.services.cockroachdb =
      { description   = "CockroachDB Server";
        documentation = [ "man:cockroach(1)" "https://www.cockroachlabs.com" ];

        after    = [ "network.target" "time-sync.target" ];
        requires = [ "time-sync.target" ];
        wantedBy = [ "multi-user.target" ];

        unitConfig.RequiresMountsFor = "/var/lib/cockroachdb";

        serviceConfig =
          { ExecStart = startupCommand;
            Type = "notify";
            User = cfg.user;
            StateDirectory = "cockroachdb";
            StateDirectoryMode = "0700";

            Restart = "always";

            # A conservative-ish timeout is alright here, because for Type=notify
            # cockroach will send systemd pings during startup to keep it alive
            TimeoutStopSec = 60;
            RestartSec = 10;
          };
      };
  };

  meta.maintainers = with lib.maintainers; [ thoughtpolice ];
}
