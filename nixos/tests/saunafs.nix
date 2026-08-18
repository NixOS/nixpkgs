{ pkgs, lib, ... }:

let
  master =
    { pkgs, ... }:
    {
      # data base is stored in memory
      # server may crash with default memory size
      virtualisation.memorySize = 1024;

      services.saunafs.master = {
        enable = true;
        openFirewall = true;
        exports = [
          "* / rw,alldirs,maproot=0:0"
        ];
      };
    };

  chunkserver =
    { pkgs, ... }:
    {
      virtualisation.emptyDiskImages = [
        {
          size = 4096;
          driveConfig.deviceExtraOpts.serial = "data";
        }
      ];

      fileSystems = pkgs.lib.mkVMOverride {
        "/data" = {
          device = "/dev/disk/by-id/virtio-data";
          fsType = "ext4";
          autoFormat = true;
        };
      };

      services.saunafs = {
        masterHost = "master";
        chunkserver = {
          openFirewall = true;
          enable = true;
          hdds = [ "/data" ];

          # The test image is too small and gets set to "full"
          settings.HDD_LEAVE_SPACE_DEFAULT = "100M";
        };
      };
    };

  metalogger =
    { pkgs, ... }:
    {
      services.saunafs = {
        masterHost = "master";
        metalogger.enable = true;
      };
    };

  client =
    { pkgs, lib, ... }:
    {
      services.saunafs.client.enable = true;
      # systemd.tmpfiles.rules = [ "d /sfs 755 root root -" ];
      systemd.network.enable = true;

      # Use networkd to have properly functioning
      # network-online.target
      networking = {
        useDHCP = false;
        useNetworkd = true;
      };

      systemd.mounts = [
        {
          requires = [ "network-online.target" ];
          after = [ "network-online.target" ];
          wantedBy = [ "remote-fs.target" ];
          type = "saunafs";
          what = "master:/";
          where = "/sfs";
        }
      ];
    };

in
{
  name = "saunafs";

  meta.maintainers = [ lib.maintainers.markuskowa ];

  nodes = {
    inherit master metalogger;
    chunkserver1 = chunkserver;
    chunkserver2 = chunkserver;
    client1 = client;
    client2 = client;
  };

  testScript = ''
    # prepare master server
    master.start()
    master.wait_for_unit("multi-user.target")
    master.succeed("sfsmaster-init")
    master.succeed("systemctl restart sfs-master")
    master.wait_for_unit("sfs-master.service")

    metalogger.wait_for_unit("sfs-metalogger.service")

    # Setup chunkservers
    for chunkserver in [chunkserver1, chunkserver2]:
        chunkserver.wait_for_unit("multi-user.target")
        chunkserver.succeed("chown saunafs:saunafs /data")
        chunkserver.succeed("systemctl restart sfs-chunkserver")
        chunkserver.wait_for_unit("sfs-chunkserver.service")

    for client in [client1, client2]:
        client.wait_for_unit("multi-user.target")

    client1.succeed("echo test > /sfs/file")
    client2.succeed("grep test /sfs/file")
  '';
}
