import ./make-test-python.nix (
  {
    name = "zrepl";

    nodes.host = {config, pkgs, ...}: {
      config = {
        # Prerequisites for ZFS and tests.
        boot.supportedFilesystems = [ "zfs" ];
        environment.systemPackages = [ pkgs.zrepl ];
        networking.hostId = "deadbeef";
        services.zrepl = {
          enable = true;
          settings = {
            # Enable Prometheus output for status assertions.
            global.monitoring = [{
              type = "prometheus";
              listen = ":9811";
            }];
            # Create a periodic snapshot job for an ephemeral zpool.
            jobs = [{
              name = "snap_test";
              type = "snap";

              filesystems."test" = true;
              snapshotting = {
                type = "periodic";
                prefix = "zrepl_";
                interval = "1s";
              };

              pruning.keep = [{
                type = "last_n";
                count = 8;
              }];
            }];
          };
        };
      };
    };

    testScript = ''
      start_all()

      with subtest("Wait for zrepl and network ready"):
          host.systemctl("start network-online.target")
          host.wait_for_unit("network-online.target")
          host.wait_for_unit("zrepl.service")

      with subtest("Create test zpool"):
          # ZFS requires 64MiB minimum pool size.
          host.succeed("fallocate -l 64MiB /root/zpool.img")
          host.succeed("zpool create test /root/zpool.img")

      with subtest("Check for completed zrepl snapshot"):
          # zrepl periodic snapshot job creates a snapshot with this prefix.
          host.wait_until_succeeds("zfs list -t snapshot | grep -q zrepl_")

      with subtest("Verify HTTP monitoring server is configured"):
          out = host.succeed("curl -f localhost:9811/metrics")

          assert (
              "zrepl_start_time" in out
          ), "zrepl start time metric was not found in Prometheus output"

          assert (
              "zrepl_zfs_snapshot_duration_count{filesystem=\"test\"}" in out
          ), "zrepl snapshot counter for test was not found in Prometheus output"
    '';
  })
