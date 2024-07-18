{
  lib,
  config,
  options,
  pkgs,
  ...
}:
let
  this = config.services.libeufin.bank;
  bankServiceName = "libeufin-bank";
  dbinitServiceName = "libeufin-bank-dbinit";
  inherit (config.services.libeufin) configFile;
in
{
  options.services.libeufin.bank = {
    enable = lib.mkEnableOption "libeufin core banking system and web interface";
    package = lib.mkPackageOption pkgs "libeufin" { };
    debug = lib.mkEnableOption "debug logging";

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
              default = "${config.services.taler.settings.taler.CURRENCY}";
              defaultText = "{option}`services.taler.settings.taler.CURRENCY`";
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
              default = "postgresql:///${bankServiceName}";
            };
          };
        };
      };
    };
  };

  config = lib.mkIf this.enable {
    services.libeufin = {
      inherit (this) enable settings;
    };

    systemd.services = {
      ${bankServiceName} = {
        serviceConfig = {
          DynamicUser = true;
          User = bankServiceName;
          ExecStart =
            "${lib.getExe this.package} serve -c ${configFile}" + lib.optionalString this.debug " -L debug";
        };
        requires = [ "${dbinitServiceName}.service" ];
        after = [ "${dbinitServiceName}.service" ];
        wantedBy = [ "multi-user.target" ]; # TODO slice?
      };
      ${dbinitServiceName} = {
        path = [ config.services.postgresql.package ];
        script =
          "${lib.getExe this.package} dbinit -c ${configFile}" + lib.optionalString this.debug " -L debug";
        serviceConfig = {
          Type = "oneshot";
          DynamicUser = true;
          User = bankServiceName;
        };
        requires = [ "postgresql.service" ];
        after = [ "postgresql.service" ];
      };
    };

    services.postgresql.enable = true;
    services.postgresql.ensureDatabases = [ bankServiceName ];
    services.postgresql.ensureUsers = [
      {
        name = bankServiceName;
        ensureDBOwnership = true;
      }
    ];
  };
}
