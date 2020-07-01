import ./make-test-python.nix ({pkgs, lib, ...}:

let
  client = { pkgs, ... } : {
    environment.systemPackages = [ pkgs.glusterfs ];
    fileSystems = pkgs.lib.mkVMOverride
      { "/gluster" =
          { device = "server1:/gv0";
            fsType = "glusterfs";
          };
      };
  };

  server = { pkgs, ... } : {
    networking.firewall.enable = false;
    services.glusterfs.enable = true;

    # create a mount point for the volume
    boot.initrd.postDeviceCommands = ''
      ${pkgs.e2fsprogs}/bin/mkfs.ext4 -L data /dev/vdb
    '';

    virtualisation.emptyDiskImages = [ 1024 ];

    fileSystems = pkgs.lib.mkVMOverride
      { "/data" =
          { device = "/dev/disk/by-label/data";
            fsType = "ext4";
          };
      };
  };
in {
  name = "glusterfs";

  nodes = {
    server1 = server;
    server2 = server;
    client1 = client;
    client2 = client;
  };

  testScript = ''
    server1.wait_for_unit("glusterd.service")
    server2.wait_for_unit("glusterd.service")

    server1.wait_until_succeeds("gluster peer status")
    server2.wait_until_succeeds("gluster peer status")

    # establish initial contact
    server1.succeed("gluster peer probe server2")
    server1.succeed("gluster peer probe server1")

    server1.succeed("gluster peer status | grep Connected")

    # create volumes
    server1.succeed("mkdir -p /data/vg0")
    server2.succeed("mkdir -p /data/vg0")
    server1.succeed("gluster volume create gv0 server1:/data/vg0 server2:/data/vg0")
    server1.succeed("gluster volume start gv0")

    # test clients
    client1.wait_for_unit("gluster.mount")
    client2.wait_for_unit("gluster.mount")

    client1.succeed("echo test > /gluster/file1")
    client2.succeed("grep test /gluster/file1")
  '';
})
