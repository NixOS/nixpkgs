{ lib, ...} : {
  name = "kubo-fuse";
  meta = with lib.maintainers; {
    maintainers = [ mguentner Luflosi ];
  };

  nodes.machine = { config, ... }: {
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

    with subtest("FUSE mountpoint"):
        machine.fail("echo a | su bob -l -c 'ipfs add --quieter'")
        # The FUSE mount functionality is broken as of v0.13.0. This is still the case with v0.29.0.
        # See https://github.com/ipfs/kubo/issues/9044.
        # Workaround: using CID Version 1 avoids that.
        ipfs_hash = machine.succeed(
            "echo fnord3 | su alice -l -c 'ipfs add --quieter --cid-version=1'"
        ).strip()

        machine.succeed(f"cat /ipfs/{ipfs_hash} | grep fnord3")

    with subtest("Unmounting of /ipns and /ipfs"):
        # Force Kubo to crash and wait for it to restart
        machine.systemctl("kill --signal=SIGKILL ipfs.service")
        machine.wait_for_unit("ipfs.service", timeout = 30)

        machine.succeed(f"cat /ipfs/{ipfs_hash} | grep fnord3")
  '';
}
