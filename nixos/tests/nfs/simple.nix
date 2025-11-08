import ../make-test-python.nix (
  {
    pkgs,
    version ? 4,
    ...
  }:

  let

    client =
      { pkgs, ... }:
      {
        virtualisation.fileSystems = {
          "/data" = {
            # nfs4 exports the export with fsid=0 as a virtual root directory
            device = if (version == 4) then "server:/" else "server:/data";
            fsType = "nfs";
            options = [ "vers=${toString version}" ];
          };
        };
        networking.firewall.enable = false; # FIXME: only open statd
      };

  in

  {
    name = "nfs";
    meta = {
      maintainers = [ ];
    };

    nodes = {
      client1 = client;
      client2 = client;

      server =
        { ... }:
        {
          services.nfs.server.enable = true;
          services.nfs.server.exports = ''
            /data 192.168.1.0/255.255.255.0(rw,no_root_squash,no_subtree_check,fsid=0)
          '';
          services.nfs.server.createMountPoints = true;
          networking.firewall.enable = false; # FIXME: figure out what ports need to be allowed
        };
    };

    testScript = ''
      import time

      server.wait_for_unit("nfs-server")
      server.succeed("systemctl start network-online.target")
      server.wait_for_unit("network-online.target")

      start_all()

      client1.wait_for_unit("data.mount")
      client1.succeed("echo bla > /data/foo")
      server.succeed("test -e /data/foo")

      client2.wait_for_unit("data.mount")
      client2.succeed("echo bla > /data/bar")
      server.succeed("test -e /data/bar")

      with subtest("restarting 'nfs-server' works correctly"):
          server.succeed("systemctl restart nfs-server")
          # will take 90 seconds due to the NFS grace period
          client2.succeed("echo bla >> /data/bar")

      with subtest("can get a lock"):
          client2.succeed("time flock -n -s /data/lock true")

      with subtest("client 2 fails to acquire lock held by client 1"):
          client1.succeed("flock -x /data/lock -c 'touch locked; sleep 100000' >&2 &")
          client1.wait_for_file("locked")
          client2.fail("flock -n -s /data/lock true")

      with subtest("client 2 obtains lock after resetting client 1"):
          client2.succeed(
              "flock -x /data/lock -c 'echo acquired; touch locked; sleep 100000' >&2 &"
          )
          client1.crash()
          client1.start()
          client2.wait_for_file("locked")

      with subtest("locks survive server reboot"):
          client1.wait_for_unit("data.mount")
          server.shutdown()
          server.start()
          client1.succeed("touch /data/xyzzy")
          client1.fail("time flock -n -s /data/lock true")

      with subtest("unmounting during shutdown happens quickly"):
          t1 = time.monotonic()
          client1.shutdown()
          duration = time.monotonic() - t1
          # FIXME: regressed in kernel 6.1.28, temporarily disabled while investigating
          # assert duration < 30, f"shutdown took too long ({duration} seconds)"
    '';
  }
)
