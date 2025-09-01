import ../../make-test-python.nix (
  { pkgs, lib, ... }:
  let
    cfgNodes = pkgs.callPackage ../common/nodes.nix { inherit lib; };
  in
  {
    # NOTE: The Nexus conversion subtest requires internet access, so to run it
    # you must run the test with:
    # - nix run .#nixosTests.taler.basic.driver
    # or interactively:
    # - nix run .#nixosTests.taler.basic.driverInteractive
    # - run_tests()

    name = "GNU Taler Basic Test";
    meta = {
      maintainers = lib.teams.ngi.members;
    };

    # Taler components virtual-machine nodes
    nodes = {
      inherit (cfgNodes.nodes)
        bank
        client
        exchange
        merchant
        ;
    };

    # TODO: make tests for each component?
    testScript =
      { nodes, ... }:
      let
        cfgScripts = pkgs.callPackage ../common/scripts.nix { inherit lib pkgs nodes; };

        inherit (cfgNodes) CURRENCY FIAT_CURRENCY;
        inherit (cfgScripts) commonScripts;

        configFile = nodes.exchange.environment.etc."taler/taler.conf".source;
        bankConfig = nodes.bank.environment.etc."libeufin/libeufin.conf".source;
        bankSettings = nodes.bank.services.libeufin.settings.libeufin-bank;
        nexusSettings = nodes.bank.services.libeufin.nexus.settings;

        # Bank admin account credentials
        AUSER = "admin";
        APASS = "testAdmin";

        TUSER = "testUser";
        TPASS = "testUser";

        exchangeAccount = ../conf/exchange-account.json;
      in

      # python
      ''
        import json

        # import common scripts
        ${commonScripts}


        # NOTE: start components up individually so they don't conflict before their setup is done
        bank.start()
        client.start()
        bank.wait_for_open_port(8082)

        with subtest("Set up Libeufin bank"):
            # Modify admin account password, increase debit threshold
            systemd_run(bank, 'libeufin-bank passwd -c "${bankConfig}" "${AUSER}" "${APASS}"', "libeufin-bank")
            systemd_run(bank, 'libeufin-bank edit-account -c ${bankConfig} --debit_threshold="${bankSettings.CURRENCY}:1000000" ${AUSER}', "libeufin-bank")

            # NOTE: the exchange is enabled before the bank starts using the `initialAccounts` option
            # TODO: just use that option instead of this?
            with subtest("Register bank accounts"):
                # username, password, name
                register_bank_account("testUser", "testUser", "User")
                register_bank_account("merchant", "merchant", "Merchant")


        exchange.start()

        # exchange credentials must be set at runtime because it requires a token from the bank
        exchange.succeed("mkdir -p /etc/taler/secrets/")
        exchange.succeed("touch /etc/taler/secrets/exchange-account.secret.conf")

        exchange.wait_for_open_port(8081)

        # Create access token for exchange
        accessTokenExchange = create_token(exchange, "exchange", "exchange")

        exchange.succeed(f'echo "{create_exchange_auth(accessTokenExchange)}" > /etc/taler/secrets/exchange-account.secret.conf')

        with subtest("Set up exchange"):
            # Set up exchange keys
            exchange.wait_until_succeeds('taler-exchange-offline -c "${configFile}" download sign upload')

            # Enable exchange wire account
            exchange.succeed('taler-exchange-offline -c "${configFile}" upload < ${exchangeAccount}')

            # Set up wire fees, needed in order to deposit coins/pay merchant
            exchange.succeed('taler-exchange-offline -c "${configFile}" wire-fee now x-taler-bank "${CURRENCY}:0.01" "${CURRENCY}:0.01" upload')
            exchange.succeed('taler-exchange-offline -c "${configFile}" global-fee now "${CURRENCY}:0.01" "${CURRENCY}:0.0" "${CURRENCY}:0" 1h 6a 0 upload')


        # Verify that exchange keys exist
        bank.succeed("curl -s http://exchange:8081/keys")


        merchant.start()
        merchant.wait_for_open_port(8083)

        # Create access token for merchant
        accessTokenMerchant = create_token(client, "merchant", "merchant")

        with subtest("Set up merchant"):
            # Create default instance (similar to admin)
            succeed(merchant, [
                "curl -X POST",
                f"-H 'Authorization: Bearer {accessTokenMerchant}'",
                """
                --data '{
                  "auth": { "method": "external" },
                  "id": "default",
                  "name": "default",
                  "user_type": "business",
                  "address": {},
                  "jurisdiction": {},
                  "use_stefan": true,
                  "default_wire_transfer_delay": { "d_us": 3600000000 },
                  "default_pay_delay": { "d_us": 3600000000 }
                }'
                """,
                "-sSfL 'http://merchant:8083/management/instances'"
            ])
            # Register bank account address
            succeed(merchant, [
                "curl -X POST",
                "-H 'Content-Type: application/json'",
                """
                --data '{
                  "payto_uri": "payto://x-taler-bank/bank:8082/merchant?receiver-name=Merchant",
                  "credit_facade_url": "http://bank:8082/accounts/merchant/taler-revenue/",
                  "credit_facade_credentials":{"type":"basic","username":"merchant","password":"merchant"}
                }'
                """,
                "-sSfL 'http://merchant:8083/instances/default/private/accounts'"
            ])
            # Register a new product to be ordered
            succeed(merchant, [
                "curl -X POST",
                "-H 'Content-Type: application/json'",
                """
                --data '{
                  "product_id": "1",
                  "description": "Product with id 1 and price 1",
                  "price": "${CURRENCY}:1",
                  "total_stock": 20,
                  "unit": "packages",
                  "next_restock": { "t_s": "never" }
                }'
                """,
                "-sSfL 'http://merchant:8083/instances/default/private/products'"
            ])


        client.succeed("curl -s http://exchange:8081/")

        # Create access token for user
        accessTokenUser = create_token(client, "${TUSER}", "${TPASS}")

        # Make a withdrawal from the CLI wallet
        with subtest("Make a withdrawal from the CLI wallet"):
            balanceWanted = "${CURRENCY}:10"

            # Register exchange
            with subtest("Register exchange"):
                wallet_cli("exchanges add http://exchange:8081/")
                wallet_cli("exchanges accept-tos http://exchange:8081/")

            # Request withdrawal from the bank
            withdrawal = json.loads(
                succeed(client, [
                    "curl -X POST",
                    f"-H 'Authorization: Bearer {accessTokenUser}'",
                    "-H 'Content-Type: application/json'",
                    f"""--data '{{"amount": "{balanceWanted}"}}'""", # double brackets escapes them
                    "-sSfL 'http://bank:8082/accounts/${TUSER}/withdrawals'"
                ])
            )

            # Accept & confirm withdrawal
            with subtest("Accept & confirm withdrawal"):
                # the withdrawal can only be confirmed if this is executed twice, for some reason
                for i in range(2):
                    wallet_cli(f"withdraw accept-uri {withdrawal["taler_withdraw_uri"]} --exchange 'http://exchange:8081/'")
                    client.sleep(5) # needs some time to process things

                succeed(client, [
                    "curl -X POST",
                    f"-H 'Authorization: Bearer {accessTokenUser}'",
                    "-H 'Content-Type: application/json'",
                    f"""--data '{{"amount": "{balanceWanted}"}}'""", # double brackets escapes them
                    f"-sSfL 'http://bank:8082/accounts/${TUSER}/withdrawals/{withdrawal["withdrawal_id"]}/confirm'"
                ])

            # Process transactions
            wallet_cli("run-until-done")

            verify_balance(balanceWanted)


        with subtest("Pay for an order"):
            # after paying (1 for the order and 0.1 as fee)
            balanceWanted = "${CURRENCY}:8.9"

            # Create an order to be paid
            response = json.loads(
                succeed(merchant, [
                    "curl -X POST",
                    "-H 'Content-Type: application/json'",
                    """
                    --data '{
                      "order": { "amount": "${CURRENCY}:1", "summary": "Test Order" },
                      "inventory_products": [{ "product_id": "1", "quantity": 1 }]
                    }'
                    """,
                    "-sSfL 'http://merchant:8083/instances/default/private/orders'"
                ])
            )
            order_id = response["order_id"]
            token = response["token"]

            # Get order pay URI
            response = json.loads(
                succeed(merchant, [
                    "curl -sSfL",
                    f"http://merchant:8083/instances/default/private/orders/{order_id}"
                ])
            )
            wallet_cli("run-until-done")

            # Process transaction
            wallet_cli(f"""handle-uri -y '{response["taler_pay_uri"]}'""")
            wallet_cli("run-until-done")

            verify_balance(balanceWanted)

        # Only run Nexus conversion test if ebics server is available
        (status, out) = bank.execute('curl -sSfL "${nexusSettings.nexus-ebics.HOST_BASE_URL}"')

        if status != 0:
            bank.log("Can't connect to ebics server. Skipping Nexus conversion subtest.")
        else:
            with subtest("Libeufin Nexus currency conversion"):
                regionalWanted = "20"

                # Create access token
                accessTokenAdmin = create_token(bank, "${AUSER}", "${APASS}")

                # Setup Nexus ebics keys
                systemd_run(bank, "libeufin-nexus ebics-setup -L debug -c /etc/libeufin/libeufin.conf", "libeufin-nexus")

                # Set currency conversion rates (1:1)
                succeed(bank, [
                    "curl -X POST",
                    f"-H 'Authorization: Bearer {accessTokenAdmin}'",
                    "-H 'Content-Type: application/json'",
                    """
                    --data '{
                      "cashin_ratio": "1",
                      "cashin_fee": "${CURRENCY}:0",
                      "cashin_tiny_amount": "${CURRENCY}:0.01",
                      "cashin_rounding_mode": "nearest",
                      "cashin_min_amount": "${FIAT_CURRENCY}:1",
                      "cashout_ratio": "1",
                      "cashout_fee": "${FIAT_CURRENCY}:0",
                      "cashout_tiny_amount": "${FIAT_CURRENCY}:0.01",
                      "cashout_rounding_mode": "nearest",
                      "cashout_min_amount": "${CURRENCY}:1"
                    }'
                    """,
                    "-sSfL 'http://bank:8082/conversion-info/conversion-rate'"
                ])

                # Make fake transaction (we only need reservePub)
                response = wallet_cli("""api 'acceptManualWithdrawal' '{ "exchangeBaseUrl":"http://exchange:8081/", "amount":"${CURRENCY}:5" }'""")
                reservePub = json.loads(response)["result"]["reservePub"]

                # Convert fiat currency to regional
                systemd_run(bank, f"""libeufin-nexus testing fake-incoming -c ${bankConfig} --amount="${FIAT_CURRENCY}:{regionalWanted}" --subject="{reservePub}" "payto://iban/CH4740123RW4167362694" """, "libeufin-nexus")
                wallet_cli("run-until-done")

                verify_conversion(regionalWanted, accessTokenExchange)
      '';
  }
)
