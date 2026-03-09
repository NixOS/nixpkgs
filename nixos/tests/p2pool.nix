{ lib, ... }:
{
  name = "p2pool";
  meta.maintainers = with lib.maintainers; [ titaniumtown ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.p2pool = {
        enable = true;
        # Monero project donation wallet for testing purposes
        wallet = "44AFFq5kSiGBoZ4NMDwYtN18obc8AemS33DBLWs3H7otXft3XjrpDtQGv7SqSsaBYBb98uNbr2VBBEt7f2wfn3RVGQBEP3A";
        mini = true;
      };

      environment.systemPackages = [ pkgs.p2pool ];
    };

  testScript = ''
    machine.wait_for_unit("multi-user.target")

    # Verify p2pool binary works
    machine.succeed("p2pool --version")

    # The service will start and print its banner before attempting to connect to monerod.
    # Check that the service was activated and p2pool started.
    machine.wait_until_succeeds(
        "journalctl -u p2pool.service | grep -q 'P2Pool'",
        timeout=30,
    )

    # Verify the service is still active (not crash-looping)
    machine.succeed("systemctl is-active p2pool.service")

    # Verify the config file was generated correctly
    machine.succeed("test -f /run/p2pool/p2pool.conf")
    machine.succeed("grep -q 'wallet = 44AFFq5' /run/p2pool/p2pool.conf")
    machine.succeed("grep -q 'mini = 1' /run/p2pool/p2pool.conf")
  '';
}
