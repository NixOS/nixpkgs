{
  lib,
  config,
  options,
  pkgs,
  ...
}:

let
  this = config.services.taler.merchant;
  # Services that need access to the DB
  # https://docs.taler.net/taler-merchant-manual.html#launching-the-backend
  servicesDB = [
    "httpd"
    "webhook"
    "wirewatch"
    "depositcheck"
    "exchange"
  ];
  # TODO: almost all services require DB access. To verify
  # Services that do not need access to the DB
  servicesNoDB = [ ];
  services = servicesDB ++ servicesNoDB;
  dbName = "taler-merchant-httpd";
  groupName = "taler-merchant-services";
  # TODO: probably uneeded since there are no crypto helpers. To verify
  runtimeDir = "/run/taler-system-runtime/";
  inherit (config.services.taler) configFile;
in

{
  options.services.taler.merchant = {
    enable = lib.mkEnableOption "the GNU Taler merchant";
    package = lib.mkPackageOption pkgs "taler-merchant" { };
    debug = lib.mkEnableOption "debug logging";
    settings = lib.mkOption {
      description = ''
        Configuration options for the taler merchant config file.

        For a list of all possible options, please see the man page [`taler.conf(5)`](https://docs.taler.net/manpages/taler.conf.5.html#merchant-options)
      '';
      type = lib.types.submodule {
        inherit (options.services.taler.settings.type.nestedTypes) freeformType;
        options = {
          # TODO: do we want this to be a sub-attribute or only define the merchant set of options here
          merchant = {
            DB = lib.mkOption {
              type = lib.types.str;
              internal = true;
              default = "postgres";
              description = "Plugin to use for the database.";
            };
            PORT = lib.mkOption {
              type = lib.types.port;
              default = 8083;
              description = "Port on which the HTTP server listens.";
            };
            SERVE = lib.mkOption {
              type = lib.types.str;
              default = "tcp";
              description = ''
                Whether the HTTP server should listen on a UNIX domain socket ("unix") or on a TCP socket ("tcp").
              '';
            };
            LEGAL_PRESERVATION = lib.mkOption {
              type = lib.types.str;
              internal = true;
              default = "10 years";
              description = "How long to keep data in the database for tax audits after the transaction has completed.";
            };
          };
          merchantdb-postgres = {
            CONFIG = lib.mkOption {
              type = lib.types.str;
              internal = true;
              default = "postgres:///${dbName}";
              description = "Database connection URI.";
            };
            SQL_DIR = lib.mkOption {
              type = lib.types.str;
              internal = true;
              default = "${this.package}/share/taler/sql/merchant/";
              description = "The location for the SQL files to setup the database tables.";
            };
          };
        };
      };
      default = { };
    };
    # TODO: add option for known exchanges?
    # see https://docs.taler.net/manpages/taler.conf.5.html#known-exchanges-for-merchants
  };

  config = lib.mkIf this.enable {
    services.taler = {
      inherit (this) enable settings;
      # TODO: any extra config needs to be added?
      includes = [ ];
    };

    systemd.slices.taler-merchant = {
      description = "Slice for GNU taler merchant processes";
      before = [ "slices.target" ];
    };

    systemd.services =
      lib.genAttrs (map (n: "taler-merchant-${n}") services) (name: {
        # taler-merchant-depositcheck needs its executable is in the PATH
        # NOTE: Couldn't use `lib.getExe` to only get that single executable
        path = lib.optional (name == "taler-merchant-depositcheck") this.package;
        serviceConfig = {
          DynamicUser = true;
          User = name;
          Group = groupName;
          ExecStart =
            "${lib.getExe' this.package name} -c ${configFile}" + lib.optionalString this.debug " -L debug";
          RuntimeDirectory = name;
          StateDirectory = name;
          CacheDirectory = name;
          # TODO: check if this is needed
          ReadWritePaths = [ runtimeDir ];
          # TODO more hardening
          # PrivateTmp = "yes";
          # PrivateDevices = "yes";
          # ProtectSystem = "full";
          # Slice = "taler-merchant.slice";
        };
        requires = [ "taler-merchant-dbinit.service" ];
        after = [ "taler-merchant-dbinit.service" ];
        wantedBy = [ "multi-user.target" ]; # TODO slice?
      })
      // {
        taler-merchant-dbinit = {
          path = [ config.services.postgresql.package ];
          script =
            let
              # TODO: not documented, but is necessary?
              dbScript = pkgs.writers.writeText "taler-merchant-db-permissions.sql" (
                lib.concatStrings (
                  map (name: ''
                    GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA merchant TO "taler-merchant-${name}";
                    GRANT USAGE ON SCHEMA merchant TO "taler-merchant-${name}";
                  '') servicesDB
                )
              );
            in
            ''
              ${lib.getExe' this.package "taler-merchant-dbinit"}

              psql -f ${dbScript}
            '';
          requires = [ "postgresql.service" ];
          after = [ "postgresql.service" ];
          serviceConfig = {
            Type = "oneshot";
            DynamicUser = true;
            User = dbName;
          };
        };
      };

    users.groups.${groupName} = { };

    systemd.tmpfiles.settings = {
      "10-taler-merchant" = {
        "${runtimeDir}" = {
          d = {
            group = groupName;
            user = "nobody";
            mode = "070";
          };
        };
      };
    };
    services.postgresql.enable = true;
    services.postgresql.ensureDatabases = [ dbName ];
    services.postgresql.ensureUsers =
      map (service: { name = "taler-merchant-${service}"; }) servicesDB
      ++ [
        {
          name = dbName;
          ensureDBOwnership = true;
        }
      ];
  };
}
