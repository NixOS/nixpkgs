{
  lib,
  config,
  options,
  pkgs,
  ...
}:

let
  talerUtils = import ./utils.nix { inherit lib pkgs config; };

  cfg = cfgTaler.exchange;
  cfgTaler = config.services.taler;
in

talerUtils.mkTalerModule rec {
  talerComponent = "exchange";

  # https://docs.taler.net/taler-exchange-manual.html#services-users-groups-and-file-system-hierarchy
  servicesDB = [
    "httpd"
    "aggregator"
    "closer"
    "wirewatch"
  ];

  servicesNoDB = [
    "secmod-cs"
    "secmod-eddsa"
    "secmod-rsa"
  ];

  extraOptions.services.taler.exchange = {
    settings = lib.mkOption {
      description = ''
        Configuration options for the taler exchange config file.

        For a list of all possible options, please see the man page [`taler.conf(5)`](https://docs.taler.net/manpages/taler.conf.5.html#exchange-options)
      '';
      type = lib.types.submodule {
        inherit (options.services.taler.settings.type.nestedTypes) freeformType;
        options = {
          # TODO: do we want this to be a sub-attribute or only define the exchange set of options here
          exchange = {
            AML_THRESHOLD = lib.mkOption {
              type = lib.types.str;
              default = "${cfgTaler.settings.taler.CURRENCY}:1000000";
              defaultText = "1000000 in {option}`CURRENCY`";
              description = "Monthly transaction volume until an account is considered suspicious and flagged for AML review.";
            };
            DB = lib.mkOption {
              type = lib.types.str;
              internal = true;
              default = "postgres";
            };
            MASTER_PUBLIC_KEY = lib.mkOption {
              type = lib.types.str;
              default = throw ''
                You must provide `MASTER_PUBLIC_KEY` with the public part of your master key.

                This will be used by the auditor service to get information about the exchange.
                For more information, see https://docs.taler.net/taler-auditor-manual.html#initial-configuration

                To generate this key, you must run `taler-exchange-offline setup`. It will print the public key.
              '';
              defaultText = "None, you must set this yourself.";
              description = "Used by the exchange to verify information signed by the offline system.";
            };
            PORT = lib.mkOption {
              type = lib.types.port;
              default = 8081;
              description = "Port on which the HTTP server listens.";
            };
          };
          exchangedb-postgres = {
            CONFIG = lib.mkOption {
              type = lib.types.str;
              internal = true;
              default = "postgres:///taler-${talerComponent}-httpd";
              description = "Database connection URI.";
            };
          };
        };
      };
      default = { };
    };
    denominationConfig = lib.mkOption {
      type = lib.types.lines;
      # TODO: how to boostrap?
      # TODO: assert instead of throw?
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
        For more information, consult the [upstream docs](https://docs.taler.net/taler-exchange-manual.html#coins-denomination-keys).

        You can either write these manually or you can use the `taler-harness deployment gen-coin-config`
        command to generate it.

        Warning: Do not modify existing denominations after deployment.
        Please see the upstream docs for how to safely do that.
      '';
    };
  };

  extraConfig = {
    services.taler.includes = [
      (pkgs.writers.writeText "exchange-denominations.conf" cfg.denominationConfig)
    ];
    systemd.services.taler-exchange-wirewatch = {
      requires = [ "taler-${talerComponent}-httpd.service" ];
      after = [ "taler-${talerComponent}-httpd.service" ];
    };
  };

  # Taken from https://docs.taler.net/taler-exchange-manual.html#exchange-database-setup
  # TODO: Why does aggregator need DELETE?
  dbInit.script =
    let
      deletePerm = name: lib.optionalString (name == "aggregator") ",DELETE";
      dbScript = pkgs.writers.writeText "taler-exchange-db-permissions.sql" (
        lib.pipe servicesDB [
          (map (name: ''
            GRANT SELECT,INSERT,UPDATE${deletePerm name} ON ALL TABLES IN SCHEMA exchange TO "taler-exchange-${name}";
            GRANT USAGE ON SCHEMA exchange TO "taler-exchange-${name}";
          ''))
          lib.concatStrings
        ]
      );
    in
    ''
      ${lib.getExe' cfg.package "taler-exchange-dbinit"}
      psql -U taler-${talerComponent}-httpd -f ${dbScript}
    '';
}
