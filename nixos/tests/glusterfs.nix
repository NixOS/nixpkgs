import ./make-test.nix ({ ... } :

let
  client = { pkgs, ... } : {
    environment.systemPackages = [ pkgs.glusterfs ];
    fileSystems = pkgs.lib.mkVMOverride
    [ { mountPoint = "/gluster";
        fsType = "glusterfs";
        device = "server1:/gv0";
    } ];
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
      [ { mountPoint = "/data";
          device = "/dev/disk/by-label/data";
          fsType = "ext4";
        }
      ];
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
    $server1->waitForUnit("glusterd.service");
    $server2->waitForUnit("glusterd.service");

    # establish initial contact
    $server1->succeed("sleep 2");
    $server1->succeed("gluster peer probe server2");
    $server1->succeed("gluster peer probe server1");

    $server1->succeed("gluster peer status | grep Connected");

    # create volumes
    $server1->succeed("mkdir -p /data/vg0");
    $server2->succeed("mkdir -p /data/vg0");
    $server1->succeed("gluster volume create gv0 server1:/data/vg0 server2:/data/vg0");
    $server1->succeed("gluster volume start gv0");

    # test clients
    $client1->waitForUnit("gluster.mount");
    $client2->waitForUnit("gluster.mount");

    $client1->succeed("echo test > /gluster/file1");
    $client2->succeed("grep test /gluster/file1");
  '';
})
