{
  lib,
  config,
  pkgs,
  ...
}:

let
  this = config.services.taler.exchange;
  # Services that need access to the DB
  servicesDB = [
    "httpd"
    "aggregator"
    "closer"
    "wirewatch"
  ];
  # Services that do not need access to the DB
  servicesNoDB = [
    "secmod-cs"
    "secmod-eddsa"
    "secmod-rsa"
  ];
  services = servicesDB ++ servicesNoDB;
  dbName = "taler-exchange-httpd";
  # taler-exchange needs a runtime dir shared between the taler services. Crypto
  # helpers put their sockets here for instance and the httpd connects to them.
  runtimeDir = "/run/taler-system-runtime/";
  talerEnabled = config.services.taler.enable;
  inherit (config.services.taler) configFile;
in

{
  options.services.taler.exchange = {
    enable = lib.mkEnableOption "the GNU Taler exchange";
    package = lib.mkPackageOption pkgs "taler-exchange" { };
    denominationConfig = lib.mkOption {
      type = lib.types.lines;
      default = throw "You must set the denomination config `services.taler.exchange.denominationConfig`.";
      example = ''
        [COIN-KUDOS-n1-t1718140083]
        VALUE = KUDOS:0.1
        DURATION_WITHDRAW = 7 days
        DURATION_SPEND = 2 years
        DURATION_LEGAL = 6 years
        FEE_WITHDRAW = KUDOS:0
        FEE_DEPOSIT = KUDOS:0.1
        FEE_REFRESH = KUDOS:0
        FEE_REFUND = KUDOS:0
        RSA_KEYSIZE = 2048
        CIPHER = RSA
      '';
      description = ''
        This option configures the cash denomination for the coins that the exchange offers.
        For more information, consult the docs: https://docs.taler.net/taler-exchange-manual.html#coins-denomination-keys

        You can either write these manually or you can use the `taler-wallet-cli deployment gen-coin-config`
        command to generate it.

        Warning: Do not modify existing denominations after deployment.
        Please see the upstream docs for how to safely do that.
      '';
    };
    debug = lib.mkEnableOption "debug logging";
  };

  config = lib.mkIf (talerEnabled && this.enable) {
    services.taler.includes = [
      (pkgs.writers.writeText "exchange-denominations.conf" this.denominationConfig)
    ];

    systemd.slices.taler-exchange = {
      description = "Slice for GNU taler exchange processes";
      before = [ "slices.target" ];
    };

    systemd.services =
      lib.genAttrs (map (n: "taler-exchange-${n}") services) (name: {
        serviceConfig = {
          DynamicUser = true;
          User = name;
          Group = "taler-exchange"; # TODO refactor into constant
          ExecStart =
            "${this.package}/bin/${name} -c ${configFile}" + lib.optionalString this.debug " -L debug"; # TODO as a list?
          RuntimeDirectory = name;
          StateDirectory = name;
          CacheDirectory = name;
          ReadWritePaths = [ runtimeDir ];
          # TODO more hardening
          # PrivateTmp = "yes";
          # PrivateDevices = "yes";
          # ProtectSystem = "full";
          # Slice = "taler-exchange.slice";
        };
        requires = [ "taler-exchange-dbinit.service" ];
        after = [ "taler-exchange-dbinit.service" ];
        wantedBy = [ "multi-user.target" ]; # TODO slice?
      })
      // {
        taler-exchange-dbinit = {
          path = [ config.services.postgresql.package ];
          script =
            let
              # Taken from https://docs.taler.net/taler-exchange-manual.html#exchange-database-setup
              # TODO generate these from servicesDB
              dbScript = pkgs.writers.writeText "taler-exchange-db-permissions.sql" ''
                GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA exchange TO "taler-exchange-aggregator";
                GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA exchange TO "taler-exchange-closer";
                GRANT SELECT,INSERT,UPDATE ON ALL TABLES IN SCHEMA exchange TO "taler-exchange-wirewatch";
                GRANT USAGE ON SCHEMA exchange TO "taler-exchange-aggregator";
                GRANT USAGE ON SCHEMA exchange TO "taler-exchange-closer";
                GRANT USAGE ON SCHEMA exchange TO "taler-exchange-wirewatch";
              '';
            in
            ''
              ${this.package}/bin/taler-exchange-dbinit

              psql -f ${dbScript}
            '';
          requires = [ "postgresql.service" ];
          after = [ "postgresql.service" ];
          serviceConfig = {
            Type = "oneshot";
            # RemainAfterExit = true;

            DynamicUser = true;
            User = "taler-exchange-httpd";
          };
        };
      };
    services.taler.settings = {
      exchange = {
        # TODO these should be generated from high-level NixOS options
        AML_THRESHOLD = "KUDOS:1000000";
        MAX_KEYS_CACHING = "forever";
        DB = "postgres";
        MASTER_PUBLIC_KEY = "Q6KCV81R9T3SC41T5FCACC2D084ACVH5A25FH44S6M5WXWZAA8P0";
        # WIRE_RESPONSE = ${TALER_DATA_HOME}/exchange/account-1.json;

        PORT = 8081; # TODO option
        BASE_URL = "https://exchange.hephaistos.foo.bar/"; # TODO ensure / is present!
        SIGNKEY_DURATION = "2 weeks";
        SIGNKEY_LEGAL_DURATION = "2 years";
        LOOKAHEAD_SIGN = "3 weeks 1 day";
        KEYDIR = "\${TALER_DATA_HOME}/exchange/live-keys/";
        REVOCATION_DIR = "\${TALER_DATA_HOME}/exchange/revocations/";
        TERMS_ETAG = 0;
        PRIVACY_ETAG = 0;
      };
      exchangedb-postgres = {
        CONFIG = "postgres:///${dbName}";
      };
      PATHS = {
        TALER_DATA_HOME = "\${STATE_DIRECTORY}/";
        TALER_CACHE_HOME = "\${CACHE_DIRECTORY}/";
        # TALER_RUNTIME_DIR = "\${RUNTIME_DIRECTORY}/";
        TALER_RUNTIME_DIR = runtimeDir; # TODO refactor into constant
      };
    };

    users.groups.taler-exchange = { };

    systemd.tmpfiles.settings = {
      "10-taler-exchange" = {
        "${runtimeDir}" = {
          d = {
            group = "taler-exchange";
            user = "nobody";
            mode = "070";
          };
        };
      };
    };
    services.postgresql.enable = true;
    services.postgresql.ensureDatabases = [ dbName ];
    services.postgresql.ensureUsers =
      map (service: { name = "taler-exchange-${service}"; }) servicesDB
      ++ [
        {
          name = "taler-exchange-httpd";
          ensureDBOwnership = true; # TODO clean this up
        }
      ];
  };
}
