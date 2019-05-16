import ./make-test.nix ({ ... } :

let
  connAuthFile="beegfs/auth-def.key";

  client = { pkgs, ... } : {
    networking.firewall.enable = false;
    services.beegfsEnable = true;
    services.beegfs.default = {
      mgmtdHost = "mgmt";
      connAuthFile = "/etc/${connAuthFile}";
      client = {
        mount = false;
        enable = true;
      };
    };

    fileSystems = pkgs.lib.mkVMOverride # FIXME: this should be creatd by the module
      [ { mountPoint = "/beegfs";
          device = "default";
          fsType = "beegfs";
          options = [ "cfgFile=/etc/beegfs/client-default.conf" "_netdev" ];
        }
      ];

    environment.etc."${connAuthFile}" = {
      enable = true;
      text = "ThisIsALousySecret";
      mode = "0600";
    };
  };


  server = service : { pkgs, ... } : {
    networking.firewall.enable = false;
    boot.initrd.postDeviceCommands = ''
      ${pkgs.e2fsprogs}/bin/mkfs.ext4 -L data /dev/vdb
    '';

    virtualisation.emptyDiskImages = [ 4096 ];

    fileSystems = pkgs.lib.mkVMOverride
      [ { mountPoint = "/data";
          device = "/dev/disk/by-label/data";
          fsType = "ext4";
        }
      ];

    environment.systemPackages = with pkgs; [ beegfs ];
    environment.etc."${connAuthFile}" = {
      enable = true;
      text = "ThisIsALousySecret";
      mode = "0600";
    };

    services.beegfsEnable = true;
    services.beegfs.default = {
      mgmtdHost = "mgmt";
      connAuthFile = "/etc/${connAuthFile}";
      "${service}" = {
        enable = true;
        storeDir = "/data";
      };
    };
  };

in
{
  name = "beegfs";

  nodes = {
    meta = server "meta";
    mgmt = server "mgmtd";
    storage1 = server "storage";
    storage2 = server "storage";
    client1 = client;
    client2 = client;
  };

  testScript = ''
    # Initalize the data directories
    $mgmt->waitForUnit("default.target");
    $mgmt->succeed("beegfs-setup-mgmtd -C -f -p /data");
    $mgmt->succeed("systemctl start beegfs-mgmtd-default");

    $meta->waitForUnit("default.target");
    $meta->succeed("beegfs-setup-meta -C -f -s 1 -p /data");
    $meta->succeed("systemctl start beegfs-meta-default");

    $storage1->waitForUnit("default.target");
    $storage1->succeed("beegfs-setup-storage -C -f -s 1 -i 1 -p /data");
    $storage1->succeed("systemctl start beegfs-storage-default");

    $storage2->waitForUnit("default.target");
    $storage2->succeed("beegfs-setup-storage -C -f -s 2 -i 2 -p /data");
    $storage2->succeed("systemctl start beegfs-storage-default");

    #

    # Basic test
    $client1->waitForUnit("beegfs.mount");
    $client1->succeed("beegfs-check-servers-default");
    $client1->succeed("echo test > /beegfs/test");
    $client2->waitForUnit("beegfs.mount");
    $client2->succeed("test -e /beegfs/test");
    $client2->succeed("cat /beegfs/test | grep test");

    # test raid0/stripping
    $client1->succeed("dd if=/dev/urandom bs=1M count=10 of=/beegfs/striped");
    $client2->succeed("cat /beegfs/striped > /dev/null");

    # check if fs is still healthy
    $client1->succeed("beegfs-fsck-default --checkfs");
  '';
})
