import ./make-test-python.nix ({ pkgs, ...} : {
  name = "ipfs";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ mguentner ];
  };

  nodes.machine = { ... }: {
    services.ipfs = {
      enable = true;
      # Also will add a unix domain socket socket API address, see module.
      startWhenNeeded = true;
      apiAddress = "/ip4/127.0.0.1/tcp/2324";
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
  '';
})
