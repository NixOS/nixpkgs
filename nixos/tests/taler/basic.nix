import ../make-test-python.nix (
  { pkgs, lib, ... }:
  let
    CURRENCY = "KUDOS";
  in
  {
    name = "taler";
    meta = {
      maintainers = [ ];
    };

    nodes = {
      exchange =
        { config, lib, ... }:
        {
          services.taler = {
            settings = {
              taler.CURRENCY = CURRENCY;
            };
            includes = [ ./conf/taler-accounts.conf ];
            exchange = {
              enable = true;
              debug = true;
              denominationConfig = lib.readFile ./conf/taler-denominations.conf;
              enableAccounts = [ ./exchange-account.json ];
              settings.exchange = {
                MASTER_PUBLIC_KEY = "2TQSTPFZBC2MC4E52NHPA050YXYG02VC3AB50QESM6JX1QJEYVQ0";
                BASE_URL = "http://exchange:8081/";
              };
              settings.exchange-offline = {
                MASTER_PRIV_FILE = "${./private.key}";
              };
            };
          };
          networking.firewall.enable = false;
          environment.systemPackages = [ config.services.taler.exchange.package ];
        };

      bank =
        { config, pkgs, ... }:
        {
          services.libeufin.bank = {
            enable = true;
            debug = true;
            settings = {
              libeufin-bank = {
                # SUGGESTED_WITHDRAWAL_EXCHANGE = "http://exchange:8081";
                WIRE_TYPE = "x-taler-bank";
                X_TALER_BANK_PAYTO_HOSTNAME = "http://bank:8082/";

                # Allow creating new accounts and give new accounts a starting bonus
                ALLOW_REGISTRATION = "yes";
                REGISTRATION_BONUS_ENABLED = "yes";
                REGISTRATION_BONUS = "${CURRENCY}:100";

                inherit CURRENCY;
              };
            };
          };
          networking.firewall.enable = false;
          environment.systemPackages = [
            pkgs.wget
            config.services.libeufin.bank.package
          ];
        };

      client =
        { pkgs, ... }:
        {
          networking.firewall.enable = false;
          environment.systemPackages = [ pkgs.taler-wallet-core ];
        };
    };

    testScript =
      { nodes, ... }:
      let
        bankConfig = toString nodes.bank.services.libeufin.configFile.outPath;

        bankSettings = nodes.bank.services.libeufin.settings.libeufin-bank;

        # Bank admin account credentials
        AUSER = "admin";
        APASS = "admin";

        TUSER = "testUser";
        TPASS = "testUser";

        register_bank_account =
          {
            username,
            password,
            name,
          }:
          let
            is_taler_exchange = lib.toLower username == "exchange";
            BODY = {
              inherit
                username
                password
                name
                is_taler_exchange
                ;
            };
          in
          pkgs.writeShellScript "register_bank_account" ''
            # Modified from taler-unified-setup.sh
            # https://git.taler.net/exchange.git/tree/src/testing/taler-unified-setup.sh?h=v0.11.2#n276

            set -eux
            wget \
              --http-user=${AUSER} \
              --http-password=${APASS} \
              --method=POST \
              --header='Content-type: application/json' \
              --body-data=${lib.escapeShellArg (lib.strings.toJSON BODY)} \
              -o /dev/null \
              -O /dev/null \
              -a wget-register-account.log \
              "http://bank:${toString bankSettings.PORT}/accounts"
          '';
      in

      # NOTE: for NeoVim formatting and highlights. Remove later.
      # python
      ''
        import json

        # Join curl commands
        def curl(machine, commands):
            return machine.succeed(" ".join(commands))

        # Execute command as systemd DynamicUser
        def systemd_run(machine, cmd, user="nobody", group="nobody"):
            machine.log(f"Executing command (via systemd-run): \"{cmd}\"")

            (status, out) = machine.execute( " ".join([
                "systemd-run",
                "--service-type=exec",
                "--quiet",
                "--wait",
                "-E PATH=\"$PATH\"",
                "-p StandardOutput=journal",
                "-p StandardError=journal",
                "-p DynamicUser=yes",
                f"-p Group={group}" if group != "nobody" else "",
                f"-p User={user}" if user != "nobody" else "",
                f"$SHELL -c '{cmd}'"
                ]) )

            if status != 0:
                raise Exception(f"systemd_run failed (status {status})")

            machine.log("systemd-run finished successfully")

        start_all()

        # Wait for services
        bank.wait_for_unit("libeufin-bank.service")
        exchange.wait_for_unit("taler-exchange-httpd.service")

        bank.wait_for_open_port(8082)
        exchange.wait_for_open_port(8081)

        # Enable exchange wire account
        with subtest("Enable exchange wire account"):
            exchange.wait_until_succeeds("taler-exchange-offline download sign upload")
            exchange.succeed('taler-exchange-offline enable-account "payto://x-taler-bank/exchange:8081/exchange?receiver-name=exchange" upload')

        # Modify bank's admin account
        with subtest("Modify bank's admin account"):
            # Change password
            systemd_run(bank, 'libeufin-bank passwd -c "${bankConfig}" "${AUSER}" "${APASS}"', "libeufin-bank")

            # Increase debit amount
            systemd_run(bank, 'libeufin-bank edit-account -c ${bankConfig} --debit_threshold="${bankSettings.CURRENCY}:1000000" ${AUSER}', "libeufin-bank")

        # Check that bank can connect to exchange
        bank.succeed("curl -s http://exchange:8081/")

        # Register bank accounts
        with subtest("Register bank accounts"):
        # NOTE: using hard-coded values from the testing API
        # TODO: add link to testing API
            bank.succeed("${
              register_bank_account {
                username = "${TUSER}";
                password = "${TPASS}";
                name = "User42";
              }
            }")
            bank.succeed("${
              register_bank_account {
                username = "exchange";
                password = "exchange";
                name = "Exchange Company";
              }
            }")

        # Check that client can connect to exchange
        client.succeed("curl -s http://exchange:8081/")

        # Make a withdrawal from the CLI wallet
        with subtest("Make a withdrawal from the CLI wallet"):
            balanceWanted = "${CURRENCY}:25"

            # Wallet wrapper
            def wallet_cli(command):
                return client.succeed(
                    "taler-wallet-cli "
                    "--skip-defaults "  # skip configuring default exchanges # NOTE: does this not work?
                    "--no-throttle "    # don't do any request throttling    # TODO: see if this affects test speed
                    + command
                )

            # Register exchange
            with subtest("Register exchange"):
                wallet_cli("exchanges add http://exchange:8081/")
                wallet_cli("exchanges accept-tos http://exchange:8081/")

            # Request withdrawal from the bank
            withdrawal = json.loads(
                curl(client, [
                    "curl -X POST",
                    "-u ${TUSER}:${TPASS}",
                    "-H 'Content-Type: application/json'",
                    f"""--data '{{"amount": "{balanceWanted}"}}'""", # double brackets escapes them
                    "-sSfL 'http://bank:8082/accounts/${TUSER}/withdrawals'"
                ])
            )

            # Accept & conform withdrawal
            with subtest("Accept & conform withdrawal"):
                wallet_cli(f"withdraw accept-uri {withdrawal["taler_withdraw_uri"]} --exchange http://exchange:8081/")
                curl(client, [
                    "curl -X POST",
                    "-u ${TUSER}:${TPASS}",
                    "-H 'Content-Type: application/json'",
                    f"-sSfL 'http://bank:8082/accounts/${TUSER}/withdrawals/{withdrawal["withdrawal_id"]}/confirm'"
                ])

            # Process transactions
            wallet_cli("run-until-done")

            # Verify balance
            with subtest("Verify balance"):
                # Safely read the balance
                balance = wallet_cli("balance --json")
                try:
                    balanceGot = json.loads(balance)["balances"][0]["available"]
                except:
                    balanceGot = "${CURRENCY}:0"

                # Compare balance with expected value
                if balanceGot != balanceWanted:
                    client.fail(f'echo Wanted balance: "{balanceWanted}", got: "{balanceGot}"')
                else:
                    client.succeed(f"echo Withdraw successfully made. New balance: {balanceWanted}")
      '';
  }
)
