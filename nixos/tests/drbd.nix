import ./make-test-python.nix (
  { pkgs, lib, ... }:
  let
    drbdPort = 7789;

    drbdConfig =
      { nodes, ... }:
      {
        virtualisation.emptyDiskImages = [ 1 ];
        networking.firewall.allowedTCPPorts = [ drbdPort ];

        services.drbd = {
          enable = true;
          config = ''
            global {
              usage-count yes;
            }

            common {
              net {
                protocol C;
                ping-int 1;
              }
            }

            resource r0 {
              volume 0 {
                device    /dev/drbd0;
                disk      /dev/vdb;
                meta-disk internal;
              }

              on drbd1 {
                address ${nodes.drbd1.networking.primaryIPAddress}:${toString drbdPort};
              }

              on drbd2 {
                address ${nodes.drbd2.networking.primaryIPAddress}:${toString drbdPort};
              }
            }
          '';
        };
      };
  in
  {
    name = "drbd";
    meta = with pkgs.lib.maintainers; {
      maintainers = [
        ryantm
        astro
        birkb
      ];
    };

    nodes.drbd1 = drbdConfig;
    nodes.drbd2 = drbdConfig;

    testScript =
      { nodes }:
      ''
        drbd1.start()
        drbd2.start()

        drbd1.wait_for_unit("network.target")
        drbd2.wait_for_unit("network.target")

        drbd1.succeed(
            "drbdadm create-md r0",
            "drbdadm up r0",
            "drbdadm primary r0 --force",
        )

        drbd2.succeed("drbdadm create-md r0", "drbdadm up r0")

        drbd1.succeed(
            "mkfs.ext4 /dev/drbd0",
            "mkdir -p /mnt/drbd",
            "mount /dev/drbd0 /mnt/drbd",
            "touch /mnt/drbd/hello",
            "umount /mnt/drbd",
            "drbdadm secondary r0",
        )
        drbd1.sleep(1)

        drbd2.succeed(
            "drbdadm primary r0",
            "mkdir -p /mnt/drbd",
            "mount /dev/drbd0 /mnt/drbd",
            "ls /mnt/drbd/hello",
        )
      '';
  }
)
