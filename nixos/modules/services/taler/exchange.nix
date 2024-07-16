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
      # TODO how to boostrap?
      default = throw "You must set the denomination config `services.taler.exchange.denominationConfig`.";
      defaultText = "None, you must set this yourself.";
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
