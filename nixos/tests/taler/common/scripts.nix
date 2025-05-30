{
  lib,
  pkgs,
  nodes,
  ...
}:

let
  cfgNodes = pkgs.callPackage ./nodes.nix { inherit lib; };
  bankConfig = nodes.bank.config.environment.etc."libeufin/libeufin.conf".source;

  inherit (cfgNodes) CURRENCY FIAT_CURRENCY;
in
{
  commonScripts =
    # python
    ''
      def succeed(machine, commands):
          """A more convenient `machine.succeed` that supports multi-line inputs"""
          flattened_commands = [c.replace("\n", "") for c in commands] # flatten multi-line
          return machine.succeed(" ".join(flattened_commands))


      def systemd_run(machine, cmd, user="nobody", group="nobody"):
          """Execute command as a systemd DynamicUser"""
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


      def register_bank_account(username, password, name, is_exchange=False):
          """Register Libeufin bank account for the x-taler-bank wire method"""
          return systemd_run(bank, " ".join([
              'libeufin-bank',
              'create-account',
              '-c ${bankConfig}',
              f'--username {username}',
              f'--password {password}',
              f'--name {name}',
              f'--payto_uri="payto://x-taler-bank/bank:8082/{username}?receiver-name={name}"',
              '--exchange' if (is_exchange or username.lower()=="exchange") else ' '
              ]),
              user="libeufin-bank")


      def wallet_cli(command):
          """Wrapper for the Taler CLI wallet"""
          return client.succeed(
              "taler-wallet-cli "
              "--no-throttle "    # don't do any request throttling
              + command
          )


      def verify_balance(balanceWanted: str):
          """Compare Taler CLI wallet balance with expected amount"""
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


      def verify_conversion(regionalWanted: str):
          """Compare converted Libeufin Nexus funds with expected regional currency"""
          # Get transaction details
          response = json.loads(
              succeed(bank, [
                  "curl -sSfL",
                  # TODO: get exchange from config?
                  "-u exchange:exchange",
                  "http://bank:8082/accounts/exchange/transactions"
              ])
          )
          amount = response["transactions"][0]["amount"].split(":") # CURRENCY:VALUE
          currencyGot, regionalGot = amount

          # Check conversion (1:1 ratio)
          if (regionalGot != regionalWanted) or (currencyGot != "${CURRENCY}"):
              client.fail(f'echo Wanted "${CURRENCY}:{regionalWanted}", got: "{currencyGot}:{regionalGot}"')
          else:
              client.succeed(f'echo Conversion successfully made: "${FIAT_CURRENCY}:{regionalWanted}" -> "{currencyGot}:{regionalGot}"')
    '';
}
