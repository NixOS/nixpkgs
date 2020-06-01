import ./make-test-python.nix ({ pkgs, ...} : {
  name = "ipfs";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ mguentner ];
  };

  nodes.machine = { ... }: {
    services.ipfs = {
      enable = true;
      apiAddress = "/ip4/127.0.0.1/tcp/2324";
    };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("ipfs")

    machine.wait_until_succeeds("ipfs --api /ip4/127.0.0.1/tcp/2324 id")
    ipfs_hash = machine.succeed(
        "echo fnord | ipfs --api /ip4/127.0.0.1/tcp/2324 add | awk '{ print $2 }'"
    )

    machine.succeed(f"ipfs cat /ipfs/{ipfs_hash.strip()} | grep fnord")
  '';
})
