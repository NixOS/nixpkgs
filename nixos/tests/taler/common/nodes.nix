{ lib, ... }:
let
  # Forward SSH and WebUI ports to host machine
  #
  # Connect with: ssh root@localhost -p <hostPort>
  # Access WebUI from: http://localhost:<hostPort>
  #
  # NOTE: This is only accessible from an interactive test, for example:
  # $ eval $(nix-build -A nixosTests.taler.basic.driver)/bin/nixos-test-driver
  mkNode =
    {
      sshPort ? 0,
      webuiPort ? 0,
      nodeSettings ? { },
    }:
    lib.recursiveUpdate {
      services.openssh = {
        enable = true;
        settings = {
          PermitRootLogin = "yes";
          PermitEmptyPasswords = "yes";
        };
      };
      security.pam.services.sshd.allowNullPassword = true;
      virtualisation.forwardPorts =
        (lib.optionals (sshPort != 0) [
          {
            from = "host";
            host.port = sshPort;
            guest.port = 22;
          }
        ])
        ++ (lib.optionals (webuiPort != 0) [
          {
            from = "host";
            host.port = webuiPort;
            guest.port = webuiPort;
          }
        ]);
    } nodeSettings;
in
rec {
  CURRENCY = "KUDOS";
  FIAT_CURRENCY = "CHF";

  nodes = {
    exchange =
      { config, lib, ... }:
      mkNode {
        sshPort = 1111;
        webuiPort = 8081;

        nodeSettings = {
          services.taler = {
            settings = {
              taler.CURRENCY = CURRENCY;
            };
            includes = [
              ../conf/taler-accounts.conf
              # The exchange requires a token from the bank, so its credentials
              # need to be set at runtime
              "/etc/taler/secrets/exchange-account.secret.conf"
            ];
            exchange = {
              enable = true;
              debug = true;
              openFirewall = true;
              # https://docs.taler.net/taler-exchange-manual.html#coins-denomination-keys
              # NOTE: use `taler-harness`, not `taler-wallet-cli`
              denominationConfig = lib.readFile ../conf/taler-denominations.conf;
              settings = {
                exchange = {
                  inherit CURRENCY;
                  MASTER_PUBLIC_KEY = "2TQSTPFZBC2MC4E52NHPA050YXYG02VC3AB50QESM6JX1QJEYVQ0";
                  BASE_URL = "http://exchange:8081/";
                };
                exchange-offline = {
                  MASTER_PRIV_FILE = "${../conf/private.key}";
                };
              };
            };
          };
        };
      };

    bank =
      { config, ... }:
      mkNode {
        sshPort = 2222;
        webuiPort = 8082;

        nodeSettings = {
          services.libeufin.bank = {
            enable = true;
            debug = true;

            openFirewall = true;
            createLocalDatabase = true;

            initialAccounts = [
              {
                username = "exchange";
                password = "exchange";
                name = "Exchange";
              }
            ];

            settings = {
              libeufin-bank = {
                WIRE_TYPE = "x-taler-bank";
                # WIRE_TYPE = "iban";
                X_TALER_BANK_PAYTO_HOSTNAME = "bank:8082";
                # IBAN_PAYTO_BIC = "SANDBOXX";
                BASE_URL = "http://bank:8082/";

                # Allow creating new accounts
                ALLOW_REGISTRATION = "yes";

                # A registration bonus makes withdrawals easier since the
                # bank account balance is not empty
                REGISTRATION_BONUS_ENABLED = "yes";
                REGISTRATION_BONUS = "${CURRENCY}:100";

                DEFAULT_DEBT_LIMIT = "${CURRENCY}:500";

                # NOTE: The exchange's bank account must be initialised before
                # the main bank service starts, else it doesn't work.
                # The `services.libeufin.bank.initialAccounts` option can be used to do this.
                ALLOW_CONVERSION = "yes";
                ALLOW_EDIT_CASHOUT_PAYTO_URI = "yes";

                SUGGESTED_WITHDRAWAL_EXCHANGE = "http://exchange:8081/";

                inherit CURRENCY FIAT_CURRENCY;
              };
            };
          };

          services.libeufin.nexus = {
            enable = true;
            debug = true;

            openFirewall = true;
            createLocalDatabase = true;

            settings = {
              # https://docs.taler.net/libeufin/setup-ebics-at-postfinance.html
              nexus-ebics = {
                # == Mandatory ==
                CURRENCY = FIAT_CURRENCY;
                # Bank
                HOST_BASE_URL = "https://isotest.postfinance.ch/ebicsweb/ebicsweb";
                BANK_DIALECT = "postfinance";
                # EBICS IDs
                HOST_ID = "PFEBICS";
                USER_ID = "PFC00639";
                PARTNER_ID = "PFC00639";
                # Account information
                IBAN = "CH4740123RW4167362694";
                BIC = "BIC";
                NAME = "nixosTest nixosTest";

                # == Optional ==
                CLIENT_PRIVATE_KEYS_FILE = "${../conf/client-ebics-keys.json}";
                BANK_PUBLIC_KEYS_FILE = "${../conf/bank-ebics-keys.json}";
              };
            };
          };
        };
      };

    merchant =
      { config, ... }:
      mkNode {
        sshPort = 3333;
        webuiPort = 8083;

        nodeSettings = {
          services.taler = {
            settings = {
              taler.CURRENCY = CURRENCY;
            };
            merchant = {
              enable = true;
              debug = true;
              openFirewall = true;
              settings.merchant-exchange-test = {
                EXCHANGE_BASE_URL = "http://exchange:8081/";
                MASTER_KEY = "2TQSTPFZBC2MC4E52NHPA050YXYG02VC3AB50QESM6JX1QJEYVQ0";
                inherit CURRENCY;
              };
            };
          };
        };
      };

    client =
      { pkgs, ... }:
      mkNode {
        sshPort = 4444;

        nodeSettings = {
          environment.systemPackages = [ pkgs.taler-wallet-core ];
        };
      };
  };

}
