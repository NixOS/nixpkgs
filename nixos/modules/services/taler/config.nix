{
  lib,
  pkgs,
  config,
  ...
}:

let
  this = config.services.taler;
  settingsFormat = pkgs.formats.ini { };
in

{
  options.services.taler.settings = lib.mkOption {
    type = lib.types.submodule {
      freeformType = settingsFormat.type;
      options = {
        # Should these be in here?
        # Should these even be configurable?
        PATHS = {
          TALER_DATA_HOME = lib.mkOption {
            type = lib.types.str;
            internal = true;
            default = "\${STATE_DIRECTORY}/";
          };
          TALER_CACHE_HOME = lib.mkOption {
            type = lib.types.str;
            internal = true;
            default = "\${CACHE_DIRECTORY}/";
          };
          TALER_RUNTIME_DIR = lib.mkOption {
            type = lib.types.str;
            internal = true;
            default = "/run/taler-system-runtime/";
          };
        };
        taler = {
          CURRENCY = lib.mkOption {
            type = lib.types.str;
            default = throw "You must set `taler.CURRENCY` to your desired currency.";
            defaultText = "None, you must set this yourself.";
            description = ''
              The currency which taler services will operate with. This cannot be changed later.
            '';
          };
          CURRENCY_ROUND_UNIT = lib.mkOption {
            type = lib.types.str;
            default = "${this.settings.taler.CURRENCY}:0.01";
            defaultText = "0.01 in {option}`CURRENCY`";
            description = ''
              Smallest amount in this currency that can be transferred using the underlying RTGS.

              You should probably not touch this.
            '';
          };
        };
        # TODO can you put this into the exchange module somehow?
        exchange = {
          AML_THRESHOLD = lib.mkOption {
            type = lib.types.str;
            default = "${this.settings.taler.CURRENCY}:1000000";
            defaultText = "1000000 in {option}`CURRENCY`";
          };
          DB = lib.mkOption {
            type = lib.types.str;
            internal = true;
            default = "postgres";
          };
          MASTER_PUBLIC_KEY = lib.mkOption {
            type = lib.types.str;
            # TODO link some sort of manual on how the master key works here
            default = throw ''
              You must provide `MASTER_PUBLIC_KEY` with the public part of your master key.

              To generate this key, you must run `taler-exchange-offline setup`. It will print the public key.
            '';
            defaultText = "None, you must set this yourself.";
          };
          PORT = lib.mkOption {
            type = lib.types.port;
            default = 8081;
          };
        };
        exchangedb-postgres = {
          CONFIG = lib.mkOption {
            type = lib.types.str;
            internal = true;
            default = "postgres:///taler-exchange-httpd";
          };
        };
        # TODO into the libeufin.bank module
        libeufin-bank = {
          CURRENCY = lib.mkOption {
            type = lib.types.str;
            default = "${this.settings.taler.CURRENCY}";
            defaultText = "{option}`taler.settings.CURRENCY`";
            description = ''
              The currency under which the libeufin-bank should operate.

              This defaults to the GNU taler module's currency for convenience
              but if you run libeufin-bank separately from taler, you must set
              this yourself.
            '';
          };
          PORT = lib.mkOption {
            type = lib.types.port;
            default = 8082;
            description = ''
              The port on which libeufin-bank should listen.
            '';
          };
          SUGGESTED_WITHDRAWAL_EXCHANGE = lib.mkOption {
            type = lib.types.str;
            default = "https://exchange.demo.taler.net/";
            description = ''
              Exchange that is suggested to wallets when withdrawing.

              Note that, in order for withdrawals to work, your libeufin-bank
              must be able to communicate with and send money etc. to the bank
              at which the exchange used for withdrawals has its bank account.

              If you also have your own bank and taler exchange network, you
              probably want to set one of your exchange's url here instead of
              the demo exchange.

              This setting must always be set in order for the Android app to
              not crash during the withdrawal process but the exchange to be
              used can always be changed in the app.
            '';
          };
        };
        libeufin-bankdb-postgres = {
          CONFIG = lib.mkOption {
            type = lib.types.str;
            internal = true;
            default = "postgresql:///libeufin";
          };
        };
      };
    };
    default = { };
  };
}
