{
  name = "zrepl";

  nodes = {
    source =
      { nodes, pkgs, ... }:
      {
        config = {
          # Prerequisites for ZFS and tests.
          virtualisation.emptyDiskImages = [
            2048
          ];

          boot.supportedFilesystems = [ "zfs" ];
          environment.systemPackages = [
            pkgs.parted
            pkgs.zrepl
          ];
          networking.firewall.allowedTCPPorts = [ 8888 ];
          networking.hostId = "deadbeef";
          services.zrepl = {
            enable = true;
            settings = {
              # Enable Prometheus output for status assertions.
              global.monitoring = [
                {
                  type = "prometheus";
                  listen = ":9811";
                }
              ];
              # Create a periodic snapshot job for an ephemeral zpool.
              jobs = [
                {
                  name = "snapshots";
                  type = "snap";

                  filesystems."tank/data" = true;
                  snapshotting = {
                    type = "periodic";
                    prefix = "zrepl_";
                    interval = "10s";
                  };

                  pruning.keep = [
                    {
                      type = "last_n";
                      count = 8;
                    }
                  ];
                }
                {
                  name = "backup-target";
                  type = "source";

                  serve = {
                    type = "tcp";
                    listen = ":8888";

                    clients = {
                      "${nodes.target.networking.primaryIPAddress}" = "${nodes.target.networking.hostName}";
                      "${nodes.target.networking.primaryIPv6Address}" = "${nodes.target.networking.hostName}";
                    };
                  };
                  filesystems."tank/data" = true;
                  # Snapshots are handled by the separate snap job
                  snapshotting = {
                    type = "manual";
                  };
                }
              ];
            };
          };
        };
      };

    target =
      { pkgs, ... }:
      {
        config = {
          # Prerequisites for ZFS and tests.
          virtualisation.emptyDiskImages = [
            2048
          ];

          boot.supportedFilesystems = [ "zfs" ];
          environment.systemPackages = [
            pkgs.parted
            pkgs.zrepl
          ];
          networking.hostId = "deadd0d0";
          services.zrepl = {
            enable = true;
            settings = {
              # Enable Prometheus output for status assertions.
              global.monitoring = [
                {
                  type = "prometheus";
                  listen = ":9811";
                }
              ];
              jobs = [
                {
                  name = "source-pull";
                  type = "pull";

                  connect = {
                    type = "tcp";
                    address = "source:8888";
                  };
                  root_fs = "tank/zrepl/source";
                  interval = "15s";
                  recv = {
                    placeholder = {
                      encryption = "off";
                    };
                  };
                  pruning = {
                    keep_sender = [
                      {
                        type = "regex";
                        regex = ".*";
                      }
                    ];
                    keep_receiver = [
                      {
                        type = "grid";
                        grid = "1x1h(keep=all) | 24x1h";
                        regex = "^zrepl_";
                      }
                    ];
                  };
                }
              ];
            };
          };
        };
      };
  };

  testScript = ''
    start_all()

    with subtest("Wait for zrepl and network ready"):
        for machine in source, target:
          machine.systemctl("start network-online.target")
          machine.wait_for_unit("network-online.target")
          machine.wait_for_unit("zrepl.service")

    with subtest("Create tank zpool"):
        for machine in source, target:
          machine.succeed(
            "parted --script /dev/vdb mklabel gpt",
            "zpool create tank /dev/vdb",
          )

    # Create ZFS datasets
    source.succeed("zfs create tank/data")
    target.succeed("zfs create -p tank/zrepl/source")

    with subtest("Check for completed zrepl snapshot on target"):
        # zrepl periodic snapshot job creates a snapshot with this prefix.
        target.wait_until_succeeds("zfs list -t snapshot | grep -q tank/zrepl/source/tank/data@zrepl_")

    with subtest("Check for completed zrepl bookmark on source"):
        source.wait_until_succeeds("zfs list -t bookmark | grep -q tank/data#zrepl_")

    with subtest("Verify HTTP monitoring server is configured"):
        out = source.succeed("curl -f localhost:9811/metrics")

        assert (
            "zrepl_start_time" in out
        ), "zrepl start time metric was not found in Prometheus output"

        assert (
            "zrepl_zfs_snapshot_duration_count{filesystem=\"tank/data\"}" in out
        ), "zrepl snapshot counter for tank/data was not found in Prometheus output"
  '';
}
