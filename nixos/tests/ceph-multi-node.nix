import ./make-test.nix ({pkgs, lib, ...}:

let
  cfg = {
    clusterId = "066ae264-2a5d-4729-8001-6ad265f50b03";
    monA = {
      name = "a";
      ip = "192.168.1.1";
    };
    osd0 = {
      name = "0";
      ip = "192.168.1.2";
      key = "AQBCEJNa3s8nHRAANvdsr93KqzBznuIWm2gOGg==";
      uuid = "55ba2294-3e24-478f-bee0-9dca4c231dd9";
    };
    osd1 = {
      name = "1";
      ip = "192.168.1.3";
      key = "AQBEEJNac00kExAAXEgy943BGyOpVH1LLlHafQ==";
      uuid = "5e97a838-85b6-43b0-8950-cb56d554d1e5";
    };
  };
  generateCephConfig = { daemonConfig }: {
    enable = true;
    global = {
      fsid = cfg.clusterId;
      monHost = cfg.monA.ip;
      monInitialMembers = cfg.monA.name;
    };
  } // daemonConfig;

  generateHost = { pkgs, cephConfig, networkConfig, ... }: {
    virtualisation = {
      memorySize = 512;
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
      { address = cfg.monA.ip; prefixLength = 24; }
    ];
    firewall = {
      allowedTCPPorts = [ 6789 3300 ];
      allowedTCPPortRanges = [ { from = 6800; to = 7300; } ];
    };
  };
  cephConfigMonA = generateCephConfig { daemonConfig = {
    mon = {
      enable = true;
      daemons = [ cfg.monA.name ];
    };
    mgr = {
      enable = true;
      daemons = [ cfg.monA.name ];
    };
  }; };

  networkOsd0 = {
    dhcpcd.enable = false;
    interfaces.eth1.ipv4.addresses = pkgs.lib.mkOverride 0 [
      { address = cfg.osd0.ip; prefixLength = 24; }
    ];
    firewall = {
      allowedTCPPortRanges = [ { from = 6800; to = 7300; } ];
    };
  };
  cephConfigOsd0 = generateCephConfig { daemonConfig = {
    osd = {
      enable = true;
      daemons = [ cfg.osd0.name ];
    };
  }; };

  networkOsd1 = {
    dhcpcd.enable = false;
    interfaces.eth1.ipv4.addresses = pkgs.lib.mkOverride 0 [
      { address = cfg.osd1.ip; prefixLength = 24; }
    ];
    firewall = {
      allowedTCPPortRanges = [ { from = 6800; to = 7300; } ];
    };
  };
  cephConfigOsd1 = generateCephConfig { daemonConfig = {
    osd = {
      enable = true;
      daemons = [ cfg.osd1.name ];
    };
  }; };

  testscript = { ... }: ''
    startAll;

    $monA->waitForUnit("network.target");
    $osd0->waitForUnit("network.target");
    $osd1->waitForUnit("network.target");

    # Create the ceph-related directories
    $monA->mustSucceed(
      "mkdir -p /var/lib/ceph/mgr/ceph-${cfg.monA.name}",
      "mkdir -p /var/lib/ceph/mon/ceph-${cfg.monA.name}",
      "chown ceph:ceph -R /var/lib/ceph/",
      "mkdir -p /etc/ceph",
      "chown ceph:ceph -R /etc/ceph"
    );
    $osd0->mustSucceed(
      "mkdir -p /var/lib/ceph/osd/ceph-${cfg.osd0.name}",
      "chown ceph:ceph -R /var/lib/ceph/",
      "mkdir -p /etc/ceph",
      "chown ceph:ceph -R /etc/ceph"
    );
    $osd1->mustSucceed(
      "mkdir -p /var/lib/ceph/osd/ceph-${cfg.osd1.name}",
      "chown ceph:ceph -R /var/lib/ceph/",
      "mkdir -p /etc/ceph",
      "chown ceph:ceph -R /etc/ceph"
    );

    # Bootstrap ceph-mon daemon
    $monA->mustSucceed(
      "sudo -u ceph ceph-authtool --create-keyring /tmp/ceph.mon.keyring --gen-key -n mon. --cap mon 'allow *'",
      "sudo -u ceph ceph-authtool --create-keyring /etc/ceph/ceph.client.admin.keyring --gen-key -n client.admin --cap mon 'allow *' --cap osd 'allow *' --cap mds 'allow *' --cap mgr 'allow *'",
      "sudo -u ceph ceph-authtool /tmp/ceph.mon.keyring --import-keyring /etc/ceph/ceph.client.admin.keyring",
      "monmaptool --create --add ${cfg.monA.name} ${cfg.monA.ip} --fsid ${cfg.clusterId} /tmp/monmap",
      "sudo -u ceph ceph-mon --mkfs -i ${cfg.monA.name} --monmap /tmp/monmap --keyring /tmp/ceph.mon.keyring",
      "sudo -u ceph touch /var/lib/ceph/mon/ceph-${cfg.monA.name}/done",
      "systemctl start ceph-mon-${cfg.monA.name}"
    );
    $monA->waitForUnit("ceph-mon-${cfg.monA.name}");
    $monA->mustSucceed("ceph mon enable-msgr2");

    # Can't check ceph status until a mon is up
    $monA->succeed("ceph -s | grep 'mon: 1 daemons'");

    # Start the ceph-mgr daemon, it has no deps and hardly any setup
    $monA->mustSucceed(
      "ceph auth get-or-create mgr.${cfg.monA.name} mon 'allow profile mgr' osd 'allow *' mds 'allow *' > /var/lib/ceph/mgr/ceph-${cfg.monA.name}/keyring",
      "systemctl start ceph-mgr-${cfg.monA.name}"
    );
    $monA->waitForUnit("ceph-mgr-a");
    $monA->waitUntilSucceeds("ceph -s | grep 'quorum ${cfg.monA.name}'");
    $monA->waitUntilSucceeds("ceph -s | grep 'mgr: ${cfg.monA.name}(active,'");

    # Send the admin keyring to the OSD machines
    $monA->mustSucceed("cp /etc/ceph/ceph.client.admin.keyring /tmp/shared");
    $osd0->mustSucceed("cp /tmp/shared/ceph.client.admin.keyring /etc/ceph");
    $osd1->mustSucceed("cp /tmp/shared/ceph.client.admin.keyring /etc/ceph");

    # Bootstrap both OSDs
    $osd0->mustSucceed(
      "mkfs.xfs /dev/vdb",
      "mount /dev/vdb /var/lib/ceph/osd/ceph-${cfg.osd0.name}",
      "ceph-authtool --create-keyring /var/lib/ceph/osd/ceph-${cfg.osd0.name}/keyring --name osd.${cfg.osd0.name} --add-key ${cfg.osd0.key}",
      "echo '{\"cephx_secret\": \"${cfg.osd0.key}\"}' | ceph osd new ${cfg.osd0.uuid} -i -",
    );
    $osd1->mustSucceed(
      "mkfs.xfs /dev/vdb",
      "mount /dev/vdb /var/lib/ceph/osd/ceph-${cfg.osd1.name}",
      "ceph-authtool --create-keyring /var/lib/ceph/osd/ceph-${cfg.osd1.name}/keyring --name osd.${cfg.osd1.name} --add-key ${cfg.osd1.key}",
      "echo '{\"cephx_secret\": \"${cfg.osd1.key}\"}' | ceph osd new ${cfg.osd1.uuid} -i -"
    );

    # Initialize the OSDs with regular filestore
    $osd0->mustSucceed(
      "ceph-osd -i ${cfg.osd0.name} --mkfs --osd-uuid ${cfg.osd0.uuid}",
      "chown -R ceph:ceph /var/lib/ceph/osd",
      "systemctl start ceph-osd-${cfg.osd0.name}",
    );
    $osd1->mustSucceed(
      "ceph-osd -i ${cfg.osd1.name} --mkfs --osd-uuid ${cfg.osd1.uuid}",
      "chown -R ceph:ceph /var/lib/ceph/osd",
      "systemctl start ceph-osd-${cfg.osd1.name}"
    );
    $monA->waitUntilSucceeds("ceph osd stat | grep -e '2 osds: 2 up[^,]*, 2 in'");
    $monA->waitUntilSucceeds("ceph -s | grep 'mgr: ${cfg.monA.name}(active,'");
    $monA->waitUntilSucceeds("ceph -s | grep 'HEALTH_OK'");

    $monA->mustSucceed(
      "ceph osd pool create multi-node-test 100 100",
      "ceph osd pool ls | grep 'multi-node-test'",
      "ceph osd pool rename multi-node-test multi-node-other-test",
      "ceph osd pool ls | grep 'multi-node-other-test'"
    );
    $monA->waitUntilSucceeds("ceph -s | grep '1 pools, 100 pgs'");
    $monA->mustSucceed("ceph osd pool set multi-node-other-test size 2");
    $monA->waitUntilSucceeds("ceph -s | grep 'HEALTH_OK'");
    $monA->waitUntilSucceeds("ceph -s | grep '100 active+clean'");
    $monA->mustFail(
      "ceph osd pool ls | grep 'multi-node-test'",
      "ceph osd pool delete multi-node-other-test multi-node-other-test --yes-i-really-really-mean-it"
    );

    # As we disable the target in the config, we still want to test that it works as intended
    $osd0->mustSucceed("systemctl stop ceph-osd-${cfg.osd0.name}");
    $osd1->mustSucceed("systemctl stop ceph-osd-${cfg.osd1.name}");
    $monA->mustSucceed(
      "systemctl stop ceph-mgr-${cfg.monA.name}",
      "systemctl stop ceph-mon-${cfg.monA.name}"
    );
    
    $monA->succeed("systemctl start ceph.target");
    $monA->waitForUnit("ceph-mon-${cfg.monA.name}");
    $monA->waitForUnit("ceph-mgr-${cfg.monA.name}");
    $osd0->succeed("systemctl start ceph.target");
    $osd0->waitForUnit("ceph-osd-${cfg.osd0.name}");
    $osd1->succeed("systemctl start ceph.target");
    $osd1->waitForUnit("ceph-osd-${cfg.osd1.name}");
    
    $monA->succeed("ceph -s | grep 'mon: 1 daemons'");
    $monA->waitUntilSucceeds("ceph -s | grep 'quorum ${cfg.monA.name}'");
    $monA->waitUntilSucceeds("ceph osd stat | grep -e '2 osds: 2 up[^,]*, 2 in'");
    $monA->waitUntilSucceeds("ceph -s | grep 'mgr: ${cfg.monA.name}(active,'");
    $monA->waitUntilSucceeds("ceph -s | grep 'HEALTH_OK'");
  '';
in {
  name = "basic-multi-node-ceph-cluster";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ lejonet ];
  };

  nodes = {
    monA = generateHost { pkgs = pkgs; cephConfig = cephConfigMonA; networkConfig = networkMonA; };
    osd0 = generateHost { pkgs = pkgs; cephConfig = cephConfigOsd0; networkConfig = networkOsd0; };
    osd1 = generateHost { pkgs = pkgs; cephConfig = cephConfigOsd1; networkConfig = networkOsd1; };
  };

  testScript = testscript;
})
