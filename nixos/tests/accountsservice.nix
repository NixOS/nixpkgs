{ ... }:

{
  name = "accountsservice";

  nodes.machine =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [ jq ];

      services.accounts-daemon.enable = true;

      users.users.alice = {
        isNormalUser = true;
        description = "Alice";
      };
    };

  testScript = ''
    machine.start_job("accounts-daemon.service")
    machine.wait_for_unit("accounts-daemon.service")
    user = machine.succeed("busctl call -j org.freedesktop.Accounts /org/freedesktop/Accounts org.freedesktop.Accounts FindUserByName s alice | jq -j '.data[]'")
    name = machine.succeed(f"busctl get-property -j org.freedesktop.Accounts {user} org.freedesktop.Accounts.User RealName | jq -j .data")
    t.assertEqual(name, "Alice")
  '';
}
