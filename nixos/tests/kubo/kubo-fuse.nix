{ lib, ... }:
{
  name = "kubo-fuse";
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

    with subtest("Create a file for testing"):
        machine.succeed("echo 'fnord3' > /tmp/test.txt")


    with subtest("/ipfs/ FUSE mountpoint"):
        machine.fail("su bob -l -c 'ipfs add --quieter' < /tmp/test.txt")
        # The FUSE mount functionality is broken as of v0.13.0. This is still the case with v0.29.0.
        # See https://github.com/ipfs/kubo/issues/9044.
        # Workaround: using CID Version 1 avoids that.
        ipfs_hash = machine.succeed(
            "echo fnord3 | su alice -l -c 'ipfs add --quieter --cid-version=1'"
        ).strip()

        machine.succeed(f"diff /tmp/test.txt /ipfs/{ipfs_hash}")


    with subtest("/mfs/ FUSE mountpoint"):
        with subtest("Write the test file in three different ways"):
            machine.succeed("cp /tmp/test.txt /mfs/test-1.txt")
            machine.succeed("su alice -c 'ipfs files write --create /test-2.txt < /tmp/test.txt'")
            machine.succeed(f"ipfs files cp /ipfs/{ipfs_hash} /test-3.txt")

        with subtest("Show the files (for debugging)"):
            # Different hashes for the different ways of adding the file to the MFS probably come from different linking structures of the merkle tree. Copying the file to /mfs with `cp` is even non-deterministic.
            machine.succeed("ipfs files ls --long >&2")
            machine.succeed("ls -l /mfs >&2")

        with subtest("Check that everyone has permission to read the file (because of Mounts.FuseAllowOther)"):
            machine.succeed("su alice -c 'cat /mfs/test-1.txt' | grep fnord3")
            machine.succeed("su bob -c 'cat /mfs/test-1.txt' | grep fnord3")

        with subtest("Check the file contents"):
            machine.succeed("diff /tmp/test.txt /mfs/test-1.txt")
            machine.succeed("diff /tmp/test.txt /mfs/test-2.txt")
            machine.succeed("diff /tmp/test.txt /mfs/test-3.txt")

        with subtest("Check the CID extended attribute"):
            output = machine.succeed(
                "getfattr --only-values --name=ipfs_cid /mfs/test-3.txt"
            ).strip()
            assert ipfs_hash == output, f"Expected {ipfs_hash} but got {output}"


    with subtest("Unmounting of /ipns, /ipfs and /mfs"):
        # Force Kubo to crash and wait for it to restart
        machine.systemctl("kill --signal=SIGKILL ipfs.service")
        machine.wait_for_unit("ipfs.service", timeout = 30)

        machine.succeed(f"diff /tmp/test.txt /ipfs/{ipfs_hash}")
        machine.succeed("diff /tmp/test.txt /mfs/test-3.txt")
  '';
}
