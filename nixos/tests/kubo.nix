{ lib, ...} : {
  name = "kubo";
  meta = with lib.maintainers; {
    maintainers = [ mguentner Luflosi ];
  };

  nodes.machine = { config, ... }: {
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

  nodes.fuse = { config, ... }: {
    services.kubo = {
      enable = true;
      autoMount = true;
    };
    users.users.alice = {
      isNormalUser = true;
      extraGroups = [ config.services.kubo.group ];
    };
    users.users.bob = {
      isNormalUser = true;
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

    with subtest("Setting dataDir works properly with the hardened systemd unit"):
        machine.succeed("test -e /mnt/ipfs/config")
        machine.succeed("test ! -e /var/lib/ipfs/")

    with subtest("FUSE mountpoint"):
        fuse.fail("echo a | su bob -l -c 'ipfs add --quieter'")
        # The FUSE mount functionality is broken as of v0.13.0 and v0.17.0.
        # See https://github.com/ipfs/kubo/issues/9044.
        # Workaround: using CID Version 1 avoids that.
        ipfs_hash = fuse.succeed(
            "echo fnord3 | su alice -l -c 'ipfs add --quieter --cid-version=1'"
        ).strip()

        fuse.succeed(f"cat /ipfs/{ipfs_hash} | grep fnord3")

    with subtest("Unmounting of /ipns and /ipfs"):
        # Force Kubo to crash and wait for it to restart
        fuse.systemctl("kill --signal=SIGKILL ipfs.service")
        fuse.wait_for_unit("ipfs.service", timeout = 30)

        fuse.succeed(f"cat /ipfs/{ipfs_hash} | grep fnord3")
  '';
}
