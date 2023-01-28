import ./make-test-python.nix ({ pkgs, ...} : {
  name = "kubo";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ mguentner ];
  };

  nodes.machine = { ... }: {
    services.kubo = {
      enable = true;
      # Also will add a unix domain socket socket API address, see module.
      startWhenNeeded = true;
      settings.Addresses.API = "/ip4/127.0.0.1/tcp/2324";
      dataDir = "/mnt/ipfs";
    };
  };

  nodes.fuse = { ... }: {
    services.kubo = {
      enable = true;
      settings.Addresses.API = "/ip4/127.0.0.1/tcp/2324";
      autoMount = true;
    };
  };

  testScript = ''
    start_all()

    # IPv4 activation

    machine.succeed("ipfs --api /ip4/127.0.0.1/tcp/2324 id")
    ipfs_hash = machine.succeed(
        "echo fnord | ipfs --api /ip4/127.0.0.1/tcp/2324 add | awk '{ print $2 }'"
    )

    machine.succeed(f"ipfs cat /ipfs/{ipfs_hash.strip()} | grep fnord")

    # Unix domain socket activation

    machine.stop_job("ipfs")

    ipfs_hash = machine.succeed(
        "echo fnord2 | ipfs --api /unix/run/ipfs.sock add | awk '{ print $2 }'"
    )
    machine.succeed(
        f"ipfs --api /unix/run/ipfs.sock cat /ipfs/{ipfs_hash.strip()} | grep fnord2"
    )

    # Test if setting dataDir works properly with the hardened systemd unit
    machine.succeed("test -e /mnt/ipfs/config")
    machine.succeed("test ! -e /var/lib/ipfs/")

    # Test FUSE mountpoint
    ipfs_hash = fuse.succeed(
        "echo fnord3 | ipfs --api /ip4/127.0.0.1/tcp/2324 add --quieter"
    )

    # The FUSE mount functionality is broken as of v0.13.0.
    # See https://github.com/ipfs/kubo/issues/9044.
    # fuse.succeed(f"cat /ipfs/{ipfs_hash.strip()} | grep fnord3")
  '';
})
