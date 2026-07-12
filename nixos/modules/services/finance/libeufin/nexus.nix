{
  lib,
  config,
  options,
  ...
}:
{
  imports = [ (import ./common.nix "nexus") ];

  options.services.libeufin.nexus.settings = lib.mkOption {
    description = ''
      Configuration options for the libeufin nexus config file.

      For a list of all possible options, please see the man page [`libeufin-nexus.conf(5)`](https://docs.taler.net/manpages/libeufin-nexus.conf.5.html)
    '';
    type = lib.types.submodule {
      inherit (options.services.libeufin.settings.type.nestedTypes) freeformType;
      options = {
        nexus-ebics = {
          # Mandatory configuration values
          # https://docs.taler.net/libeufin/nexus-manual.html#setting-up-the-ebics-subscriber
          # https://docs.taler.net/libeufin/setup-ebics-at-postfinance.html
          CURRENCY = lib.mkOption {
            description = "Name of the fiat currency.";
            type = lib.types.nonEmptyStr;
            example = "CHF";
          };
          HOST_BASE_URL = lib.mkOption {
            description = "URL of the EBICS server.";
            type = lib.types.nonEmptyStr;
            example = "https://ebics.postfinance.ch/ebics/ebics.aspx";
          };
          BANK_DIALECT = lib.mkOption {
            description = ''
              Name of the following combination: EBICS version and ISO20022
              recommendations that Nexus would honor in the communication with the
              bank.

              Currently only the "postfinance" or "gls" value is supported.
            '';
            type = lib.types.enum [
              "postfinance"
              "gls"
            ];
            example = "postfinance";
          };
          HOST_ID = lib.mkOption {
            description = "Name of the EBICS host.";
            type = lib.types.nonEmptyStr;
            example = "PFEBICS";
          };
          USER_ID = lib.mkOption {
            description = ''
              User ID of the EBICS subscriber.

              This value must be assigned by the bank after having activated a new EBICS subscriber.
            '';
            type = lib.types.nonEmptyStr;
            example = "PFC00563";
          };
          PARTNER_ID = lib.mkOption {
            description = ''
              Partner ID of the EBICS subscriber.

              This value must be assigned by the bank after having activated a new EBICS subscriber.
            '';
            type = lib.types.nonEmptyStr;
            example = "PFC00563";
          };
          IBAN = lib.mkOption {
            description = "IBAN of the bank account that is associated with the EBICS subscriber.";
            type = lib.types.nonEmptyStr;
            example = "CH7789144474425692816";
          };
          BIC = lib.mkOption {
            description = "BIC of the bank account that is associated with the EBICS subscriber.";
            type = lib.types.nonEmptyStr;
            example = "POFICHBEXXX";
          };
          NAME = lib.mkOption {
            description = "Legal entity that is associated with the EBICS subscriber.";
            type = lib.types.nonEmptyStr;
            example = "John Smith S.A.";
          };
          BANK_PUBLIC_KEYS_FILE = lib.mkOption {
            type = lib.types.path;
            default = "/var/lib/libeufin-nexus/bank-ebics-keys.json";
            description = ''
              Filesystem location where Nexus should store the bank public keys.
            '';
          };
          CLIENT_PRIVATE_KEYS_FILE = lib.mkOption {
            type = lib.types.path;
            default = "/var/lib/libeufin-nexus/client-ebics-keys.json";
            description = ''
              Filesystem location where Nexus should store the subscriber private keys.
            '';
          };
        };
        nexus-httpd = {
          PORT = lib.mkOption {
            type = lib.types.port;
            default = 8084;
            description = ''
              The port on which libeufin-bank should listen.
            '';
          };
        };
        libeufin-nexusdb-postgres = {
          CONFIG = lib.mkOption {
            type = lib.types.str;
            description = ''
              The database connection string for the libeufin-nexus database.
            '';
          };
        };
      };
    };
  };

  config =
    let
      cfgMain = config.services.libeufin;
      cfg = config.services.libeufin.nexus;
    in
    lib.mkIf cfg.enable {
      services.libeufin.nexus.settings.libeufin-nexusdb-postgres.CONFIG = lib.mkIf (
        cfgMain.bank.enable && cfgMain.bank.createLocalDatabase
      ) "postgresql:///libeufin-bank";

      systemd.services.libeufin-nexus.documentation = [ "man:libeufin-nexus(1)" ];
    };
}
