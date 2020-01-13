import ./make-test.nix ({pkgs, lib, ...}:

let
  generateCephConfig = { daemonConfig }: {
    enable = true;
    global = {
      fsid = "066ae264-2a5d-4729-8001-6ad265f50b03";
      monInitialMembers = "a";
      monHost = "192.168.1.1";
    };
  } // daemonConfig;

  generateHost = { pkgs, cephConfig, networkConfig, ... }: {
    virtualisation = {
      memorySize = 1536;
      emptyDiskImages = [ 20480 ];
      vlans = [ 1 ];
    };

    networking = networkConfig;

    environment.systemPackages = with pkgs; [
      bash
      sudo
      ceph
      xfsprogs
      netcat-openbsd
    ];

    boot.kernelModules = [ "xfs" ];

    services.ceph = cephConfig;

    # So that we don't have to battle systemd when bootstraping
    systemd.targets.ceph.wantedBy = lib.mkForce [];
  };

  networkMonA = {
    dhcpcd.enable = false;
    interfaces.eth1.ipv4.addresses = pkgs.lib.mkOverride 0 [
      { address = "192.168.1.1"; prefixLength = 24; }
    ];
    firewall = {
      allowedTCPPorts = [ 6789 3300 ];
      allowedTCPPortRanges = [ { from = 6800; to = 7300; } ];
    };
  };
  cephConfigMonA = generateCephConfig { daemonConfig = {
    mon = {
      enable = true;
      daemons = [ "a" ];
    };
    mgr = {
      enable = true;
      daemons = [ "a" ];
    };
  }; };

  networkOsd0 = {
    dhcpcd.enable = false;
    interfaces.eth1.ipv4.addresses = pkgs.lib.mkOverride 0 [
      { address = "192.168.1.2"; prefixLength = 24; }
    ];
    firewall = {
      allowedTCPPortRanges = [ { from = 6800; to = 7300; } ];
    };
  };
  cephConfigOsd0 = generateCephConfig { daemonConfig = {
    osd = {
      enable = true;
      daemons = [ "0" ];
    };
  }; };

  networkOsd1 = {
    dhcpcd.enable = false;
    interfaces.eth1.ipv4.addresses = pkgs.lib.mkOverride 0 [
      { address = "192.168.1.3"; prefixLength = 24; }
    ];
    firewall = {
      allowedTCPPortRanges = [ { from = 6800; to = 7300; } ];
    };
  };
  cephConfigOsd1 = generateCephConfig { daemonConfig = {
    osd = {
      enable = true;
      daemons = [ "1" ];
    };
  }; };

  networkOsd2 = {
    dhcpcd.enable = false;
    interfaces.eth1.ipv4.addresses = pkgs.lib.mkOverride 0 [
      { address = "192.168.1.4"; prefixLength = 24; }
    ];
    firewall = {
      allowedTCPPortRanges = [ { from = 6800; to = 7300; } ];
    };
  };
  cephConfigOsd2 = generateCephConfig { daemonConfig = {
    osd = {
      enable = true;
      daemons = [ "2" ];
    };
  }; };
in {
  name = "basic-multi-node-ceph-cluster";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ lejonet ];
  };

  nodes = {
    monA = generateHost { pkgs = pkgs; cephConfig = cephConfigMonA; networkConfig = networkMonA; };
    osd0 = generateHost { pkgs = pkgs; cephConfig = cephConfigOsd0; networkConfig = networkOsd0; };
    osd1 = generateHost { pkgs = pkgs; cephConfig = cephConfigOsd1; networkConfig = networkOsd1; };
    osd2 = generateHost { pkgs = pkgs; cephConfig = cephConfigOsd2; networkConfig = networkOsd2; };
  };

  testScript = { ... }: ''
    startAll;

    $monA->waitForUnit("network.target");
    $osd0->waitForUnit("network.target");
    $osd1->waitForUnit("network.target");
    $osd2->waitForUnit("network.target");

    # Create the ceph-related directories
    $monA->mustSucceed(
      "mkdir -p /var/lib/ceph/mgr/ceph-a",
      "mkdir -p /var/lib/ceph/mon/ceph-a",
      "chown ceph:ceph -R /var/lib/ceph/",
      "mkdir -p /etc/ceph",
      "chown ceph:ceph -R /etc/ceph"
    );
    $osd0->mustSucceed(
      "mkdir -p /var/lib/ceph/osd/ceph-0",
      "chown ceph:ceph -R /var/lib/ceph/",
      "mkdir -p /etc/ceph",
      "chown ceph:ceph -R /etc/ceph"
    );
    $osd1->mustSucceed(
      "mkdir -p /var/lib/ceph/osd/ceph-1",
      "chown ceph:ceph -R /var/lib/ceph/",
      "mkdir -p /etc/ceph",
      "chown ceph:ceph -R /etc/ceph"
    );
    $osd2->mustSucceed(
      "mkdir -p /var/lib/ceph/osd/ceph-2",
      "chown ceph:ceph -R /var/lib/ceph/",
      "mkdir -p /etc/ceph",
      "chown ceph:ceph -R /etc/ceph"
    );

    # Bootstrap ceph-mon daemon
    $monA->mustSucceed(
      "sudo -u ceph ceph-authtool --create-keyring /tmp/ceph.mon.keyring --gen-key -n mon. --cap mon 'allow *'",
      "sudo -u ceph ceph-authtool --create-keyring /etc/ceph/ceph.client.admin.keyring --gen-key -n client.admin --cap mon 'allow *' --cap osd 'allow *' --cap mds 'allow *' --cap mgr 'allow *'",
      "sudo -u ceph ceph-authtool /tmp/ceph.mon.keyring --import-keyring /etc/ceph/ceph.client.admin.keyring",
      "monmaptool --create --add a 192.168.1.1 --fsid 066ae264-2a5d-4729-8001-6ad265f50b03 /tmp/monmap",
      "sudo -u ceph ceph-mon --mkfs -i a --monmap /tmp/monmap --keyring /tmp/ceph.mon.keyring",
      "sudo -u ceph touch /var/lib/ceph/mon/ceph-a/done",
      "systemctl start ceph-mon-a"
    );
    $monA->waitForUnit("ceph-mon-a");
    $monA->mustSucceed("ceph mon enable-msgr2");

    # Can't check ceph status until a mon is up
    $monA->succeed("ceph -s | grep 'mon: 1 daemons'");

    # Start the ceph-mgr daemon, it has no deps and hardly any setup
    $monA->mustSucceed(
      "ceph auth get-or-create mgr.a mon 'allow profile mgr' osd 'allow *' mds 'allow *' > /var/lib/ceph/mgr/ceph-a/keyring",
      "systemctl start ceph-mgr-a"
    );
    $monA->waitForUnit("ceph-mgr-a");
    $monA->waitUntilSucceeds("ceph -s | grep 'quorum a'");
    $monA->waitUntilSucceeds("ceph -s | grep 'mgr: a(active,'");

    # Send the admin keyring to the OSD machines
    $osd0->mustSucceed("nc -vlkN 6800 > /etc/ceph/ceph.client.admin.keyring &");
    $osd1->mustSucceed("nc -vlkN 6800 > /etc/ceph/ceph.client.admin.keyring &");
    $osd2->mustSucceed("nc -vlkN 6800 > /etc/ceph/ceph.client.admin.keyring &");
    $osd0->waitForOpenPort("6800");
    $osd1->waitForOpenPort("6800");
    $osd2->waitForOpenPort("6800");
    $monA->mustSucceed(
      "nc 192.168.1.2 6800 < /etc/ceph/ceph.client.admin.keyring",
      "nc 192.168.1.3 6800 < /etc/ceph/ceph.client.admin.keyring",
      "nc 192.168.1.4 6800 < /etc/ceph/ceph.client.admin.keyring"
    );

    # Bootstrap OSDs
    $osd0->mustSucceed(
      "mkfs.xfs /dev/vdb",
      "mount /dev/vdb /var/lib/ceph/osd/ceph-0",
      "ceph-authtool --create-keyring /var/lib/ceph/osd/ceph-0/keyring --name osd.0 --add-key AQBCEJNa3s8nHRAANvdsr93KqzBznuIWm2gOGg==",
      "echo '{\"cephx_secret\": \"AQBCEJNa3s8nHRAANvdsr93KqzBznuIWm2gOGg==\"}' | ceph osd new 55ba2294-3e24-478f-bee0-9dca4c231dd9 -i -",
    );
    $osd1->mustSucceed(
      "mkfs.xfs /dev/vdb",
      "mount /dev/vdb /var/lib/ceph/osd/ceph-1",
      "ceph-authtool --create-keyring /var/lib/ceph/osd/ceph-1/keyring --name osd.1 --add-key AQBEEJNac00kExAAXEgy943BGyOpVH1LLlHafQ==",
      "echo '{\"cephx_secret\": \"AQBEEJNac00kExAAXEgy943BGyOpVH1LLlHafQ==\"}' | ceph osd new 5e97a838-85b6-43b0-8950-cb56d554d1e5 -i -"
    );
    $osd2->mustSucceed(
      "mkfs.xfs /dev/vdb",
      "mount /dev/vdb /var/lib/ceph/osd/ceph-2",
      "ceph-authtool --create-keyring /var/lib/ceph/osd/ceph-2/keyring --name osd.2 --add-key AQAdyhZeIaUlARAAGRoidDAmS6Vkp546UFEf5w==",
      "echo '{\"cephx_secret\": \"AQAdyhZeIaUlARAAGRoidDAmS6Vkp546UFEf5w==\"}' | ceph osd new ea999274-13d0-4dd5-9af9-ad25a324f72f -i -"
    );

    # Initialize the OSDs with regular filestore
    $osd0->mustSucceed(
      "ceph-osd -i 0 --mkfs --osd-uuid 55ba2294-3e24-478f-bee0-9dca4c231dd9",
      "chown -R ceph:ceph /var/lib/ceph/osd",
      "systemctl start ceph-osd-0",
    );
    $osd1->mustSucceed(
      "ceph-osd -i 1 --mkfs --osd-uuid 5e97a838-85b6-43b0-8950-cb56d554d1e5",
      "chown -R ceph:ceph /var/lib/ceph/osd",
      "systemctl start ceph-osd-1"
    );
    $osd2->mustSucceed(
      "ceph-osd -i 2 --mkfs --osd-uuid ea999274-13d0-4dd5-9af9-ad25a324f72f",
      "chown -R ceph:ceph /var/lib/ceph/osd",
      "systemctl start ceph-osd-2"
    );
    $monA->waitUntilSucceeds("ceph osd stat | grep -e '3 osds: 3 up[^,]*, 3 in'");
    $monA->waitUntilSucceeds("ceph -s | grep 'mgr: a(active,'");
    $monA->waitUntilSucceeds("ceph -s | grep 'HEALTH_OK'");

    $monA->mustSucceed(
      "ceph osd pool create multi-node-test 100 100",
      "ceph osd pool ls | grep 'multi-node-test'",
      "ceph osd pool rename multi-node-test multi-node-other-test",
      "ceph osd pool ls | grep 'multi-node-other-test'"
    );
    $monA->waitUntilSucceeds(
      "ceph -s | grep '1 pools, 100 pgs'",
      "ceph osd pool set multi-node-other-test size 2"
    );
    $monA->waitUntilSucceeds("ceph -s | grep 'HEALTH_OK'");
    $monA->waitUntilSucceeds("ceph -s | grep '100 active+clean'");
    $monA->mustFail(
      "ceph osd pool ls | grep 'multi-node-test'",
      "ceph osd pool delete multi-node-other-test multi-node-other-test --yes-i-really-really-mean-it"
    );

    # As we disable the target in the config, we still want to test that it works as intended
    $osd0->mustSucceed("systemctl stop ceph-osd-0");
    $osd1->mustSucceed("systemctl stop ceph-osd-1");
    $osd2->mustSucceed("systemctl stop ceph-osd-2");
    $monA->mustSucceed(
      "systemctl stop ceph-mgr-a",
      "systemctl stop ceph-mon-a"
    );
    
    $monA->succeed("systemctl start ceph.target");
    $monA->waitForUnit("ceph-mon-a");
    $monA->waitForUnit("ceph-mgr-a");
    $osd0->succeed("systemctl start ceph.target");
    $osd0->waitForUnit("ceph-osd-0");
    $osd1->succeed("systemctl start ceph.target");
    $osd1->waitForUnit("ceph-osd-1");
    $osd2->succeed("systemctl start ceph.target");
    $osd2->waitForUnit("ceph-osd-2");
    
    $monA->succeed("ceph -s | grep 'mon: 1 daemons'");
    $monA->waitUntilSucceeds("ceph -s | grep 'quorum a'");
    $monA->waitUntilSucceeds("ceph osd stat | grep -e '3 osds: 3 up[^,]*, 3 in'");
    $monA->waitUntilSucceeds("ceph -s | grep 'mgr: a(active,'");
    $monA->waitUntilSucceeds("ceph -s | grep 'HEALTH_OK'");
  '';
})
