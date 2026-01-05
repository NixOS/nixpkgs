{
  lib,
  config,
  options,
  ...
}:
{
  imports = [ (import ./common.nix "bank") ];

  options.services.libeufin.bank = {
    initialAccounts = lib.mkOption {
      type = lib.types.listOf lib.types.attrs;
      description = ''
        Accounts to enable before the bank service starts.

        This is mainly needed for the nexus currency conversion
        since the exchange's bank account is expected to be already
        registered.

        Don't forget to change the account passwords afterwards.
      '';
      default = [ ];
    };

    settings = lib.mkOption {
      description = ''
        Configuration options for the libeufin bank system config file.

        For a list of all possible options, please see the man page [`libeufin-bank.conf(5)`](https://docs.taler.net/manpages/libeufin-bank.conf.5.html)
      '';
      type = lib.types.submodule {
        inherit (options.services.libeufin.settings.type.nestedTypes) freeformType;
        options = {
          libeufin-bank = {
            CURRENCY = lib.mkOption {
              type = lib.types.str;
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
              description = ''
                The database connection string for the libeufin-bank database.
              '';
            };
          };
        };
      };
    };
  };

  config = {
    services.libeufin.bank.settings.libeufin-bank.CURRENCY = lib.mkIf (
      config.services.taler.enable && (config.services.taler.settings.taler ? CURRENCY)
    ) config.services.taler.settings.taler.CURRENCY;

    services.libeufin.bank.settings.libeufin-bankdb-postgres.CONFIG =
      lib.mkIf config.services.libeufin.bank.createLocalDatabase "postgresql:///libeufin-bank";
  };
}
