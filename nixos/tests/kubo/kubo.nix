{ lib, ... }:
{
  name = "kubo";
  meta = with lib.maintainers; {
    maintainers = [
      mguentner
      Luflosi
    ];
  };

  nodes.machine =
    { config, ... }:
    {
      services.kubo = {
        enable = true;
        # Also will add a unix domain socket socket API address, see module.
        startWhenNeeded = true;
        settings.Addresses.API = "/ip4/127.0.0.1/tcp/2324";
        dataDir = "/mnt/ipfs";
      };
      users.users.alice = {
        isNormalUser = true;
        extraGroups = [ config.services.kubo.group ];
      };
    };

  testScript = ''
    start_all()

    with subtest("Automatic socket activation"):
        ipfs_hash = machine.succeed(
            "echo fnord0 | su alice -l -c 'ipfs add --quieter'"
        )
        machine.succeed(f"ipfs cat /ipfs/{ipfs_hash.strip()} | grep fnord0")

    machine.stop_job("ipfs")

    with subtest("IPv4 socket activation"):
        machine.succeed("ipfs --api /ip4/127.0.0.1/tcp/2324 id")
        ipfs_hash = machine.succeed(
            "echo fnord | ipfs --api /ip4/127.0.0.1/tcp/2324 add --quieter"
        )
        machine.succeed(f"ipfs cat /ipfs/{ipfs_hash.strip()} | grep fnord")

    machine.stop_job("ipfs")

    with subtest("Unix domain socket activation"):
        ipfs_hash = machine.succeed(
            "echo fnord2 | ipfs --api /unix/run/ipfs.sock add --quieter"
        )
        machine.succeed(
            f"ipfs --api /unix/run/ipfs.sock cat /ipfs/{ipfs_hash.strip()} | grep fnord2"
        )

    machine.stop_job("ipfs")

    with subtest("Socket activation for the Gateway"):
        machine.succeed(
            f"curl 'http://127.0.0.1:8080/ipfs/{ipfs_hash.strip()}' | grep fnord2"
        )

    with subtest("Setting dataDir works properly with the hardened systemd unit"):
        machine.succeed("test -e /mnt/ipfs/config")
        machine.succeed("test ! -e /var/lib/ipfs/")
  '';
}
