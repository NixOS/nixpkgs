import ./make-test-python.nix ({pkgs, lib, ...}:

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
    osd2 = {
      name = "2";
      ip = "192.168.1.4";
      key = "AQAdyhZeIaUlARAAGRoidDAmS6Vkp546UFEf5w==";
      uuid = "ea999274-13d0-4dd5-9af9-ad25a324f72f";
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
      emptyDiskImages = [ 20480 ];
      vlans = [ 1 ];
    };

    networking = networkConfig;

    environment.systemPackages = with pkgs; [
      bash
      sudo
      ceph
      xfsprogs
      libressl.nc
    ];

    boot.kernelModules = [ "xfs" ];

    services.ceph = cephConfig;
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

  networkOsd = osd: {
    dhcpcd.enable = false;
    interfaces.eth1.ipv4.addresses = pkgs.lib.mkOverride 0 [
      { address = osd.ip; prefixLength = 24; }
    ];
    firewall = {
      allowedTCPPortRanges = [ { from = 6800; to = 7300; } ];
    };
  };

  cephConfigOsd = osd: generateCephConfig { daemonConfig = {
    osd = {
      enable = true;
      daemons = [ osd.name ];
    };
  }; };

  # Following deployment is based on the manual deployment described here:
  # https://docs.ceph.com/docs/master/install/manual-deployment/
  # For other ways to deploy a ceph cluster, look at the documentation at
  # https://docs.ceph.com/docs/master/
  testscript = { ... }: ''
    start_all()

    monA.wait_for_unit("network.target")
    osd0.wait_for_unit("network.target")
    osd1.wait_for_unit("network.target")
    osd2.wait_for_unit("network.target")

    # Bootstrap ceph-mon daemon
    monA.succeed(
        "sudo -u ceph ceph-authtool --create-keyring /tmp/ceph.mon.keyring --gen-key -n mon. --cap mon 'allow *'",
        "sudo -u ceph ceph-authtool --create-keyring /etc/ceph/ceph.client.admin.keyring --gen-key -n client.admin --cap mon 'allow *' --cap osd 'allow *' --cap mds 'allow *' --cap mgr 'allow *'",
        "sudo -u ceph ceph-authtool /tmp/ceph.mon.keyring --import-keyring /etc/ceph/ceph.client.admin.keyring",
        "monmaptool --create --add ${cfg.monA.name} ${cfg.monA.ip} --fsid ${cfg.clusterId} /tmp/monmap",
        "sudo -u ceph ceph-mon --mkfs -i ${cfg.monA.name} --monmap /tmp/monmap --keyring /tmp/ceph.mon.keyring",
        "sudo -u ceph mkdir -p /var/lib/ceph/mgr/ceph-${cfg.monA.name}/",
        "sudo -u ceph touch /var/lib/ceph/mon/ceph-${cfg.monA.name}/done",
        "systemctl start ceph-mon-${cfg.monA.name}",
    )
    monA.wait_for_unit("ceph-mon-${cfg.monA.name}")
    monA.succeed("ceph mon enable-msgr2")
    monA.succeed("ceph config set mon auth_allow_insecure_global_id_reclaim false")

    # Can't check ceph status until a mon is up
    monA.succeed("ceph -s | grep 'mon: 1 daemons'")

    # Start the ceph-mgr daemon, it has no deps and hardly any setup
    monA.succeed(
        "ceph auth get-or-create mgr.${cfg.monA.name} mon 'allow profile mgr' osd 'allow *' mds 'allow *' > /var/lib/ceph/mgr/ceph-${cfg.monA.name}/keyring",
        "systemctl start ceph-mgr-${cfg.monA.name}",
    )
    monA.wait_for_unit("ceph-mgr-a")
    monA.wait_until_succeeds("ceph -s | grep 'quorum ${cfg.monA.name}'")
    monA.wait_until_succeeds("ceph -s | grep 'mgr: ${cfg.monA.name}(active,'")

    # Send the admin keyring to the OSD machines
    monA.succeed("cp /etc/ceph/ceph.client.admin.keyring /tmp/shared")
    osd0.succeed("cp /tmp/shared/ceph.client.admin.keyring /etc/ceph")
    osd1.succeed("cp /tmp/shared/ceph.client.admin.keyring /etc/ceph")
    osd2.succeed("cp /tmp/shared/ceph.client.admin.keyring /etc/ceph")

    # Bootstrap OSDs
    osd0.succeed(
        "mkfs.xfs /dev/vdb",
        "mkdir -p /var/lib/ceph/osd/ceph-${cfg.osd0.name}",
        "mount /dev/vdb /var/lib/ceph/osd/ceph-${cfg.osd0.name}",
        "ceph-authtool --create-keyring /var/lib/ceph/osd/ceph-${cfg.osd0.name}/keyring --name osd.${cfg.osd0.name} --add-key ${cfg.osd0.key}",
        'echo \'{"cephx_secret": "${cfg.osd0.key}"}\' | ceph osd new ${cfg.osd0.uuid} -i -',
    )
    osd1.succeed(
        "mkfs.xfs /dev/vdb",
        "mkdir -p /var/lib/ceph/osd/ceph-${cfg.osd1.name}",
        "mount /dev/vdb /var/lib/ceph/osd/ceph-${cfg.osd1.name}",
        "ceph-authtool --create-keyring /var/lib/ceph/osd/ceph-${cfg.osd1.name}/keyring --name osd.${cfg.osd1.name} --add-key ${cfg.osd1.key}",
        'echo \'{"cephx_secret": "${cfg.osd1.key}"}\' | ceph osd new ${cfg.osd1.uuid} -i -',
    )
    osd2.succeed(
        "mkfs.xfs /dev/vdb",
        "mkdir -p /var/lib/ceph/osd/ceph-${cfg.osd2.name}",
        "mount /dev/vdb /var/lib/ceph/osd/ceph-${cfg.osd2.name}",
        "ceph-authtool --create-keyring /var/lib/ceph/osd/ceph-${cfg.osd2.name}/keyring --name osd.${cfg.osd2.name} --add-key ${cfg.osd2.key}",
        'echo \'{"cephx_secret": "${cfg.osd2.key}"}\' | ceph osd new ${cfg.osd2.uuid} -i -',
    )

    # Initialize the OSDs with regular filestore
    osd0.succeed(
        "ceph-osd -i ${cfg.osd0.name} --mkfs --osd-uuid ${cfg.osd0.uuid}",
        "chown -R ceph:ceph /var/lib/ceph/osd",
        "systemctl start ceph-osd-${cfg.osd0.name}",
    )
    osd1.succeed(
        "ceph-osd -i ${cfg.osd1.name} --mkfs --osd-uuid ${cfg.osd1.uuid}",
        "chown -R ceph:ceph /var/lib/ceph/osd",
        "systemctl start ceph-osd-${cfg.osd1.name}",
    )
    osd2.succeed(
        "ceph-osd -i ${cfg.osd2.name} --mkfs --osd-uuid ${cfg.osd2.uuid}",
        "chown -R ceph:ceph /var/lib/ceph/osd",
        "systemctl start ceph-osd-${cfg.osd2.name}",
    )
    monA.wait_until_succeeds("ceph osd stat | grep -e '3 osds: 3 up[^,]*, 3 in'")
    monA.wait_until_succeeds("ceph -s | grep 'mgr: ${cfg.monA.name}(active,'")
    monA.wait_until_succeeds("ceph -s | grep 'HEALTH_OK'")

    monA.succeed(
        "ceph osd pool create multi-node-test 32 32",
        "ceph osd pool ls | grep 'multi-node-test'",
        "ceph osd pool rename multi-node-test multi-node-other-test",
        "ceph osd pool ls | grep 'multi-node-other-test'",
    )
    monA.wait_until_succeeds("ceph -s | grep '2 pools, 33 pgs'")
    monA.succeed("ceph osd pool set multi-node-other-test size 2")
    monA.wait_until_succeeds("ceph -s | grep 'HEALTH_OK'")
    monA.wait_until_succeeds("ceph -s | grep '33 active+clean'")
    monA.fail(
        "ceph osd pool ls | grep 'multi-node-test'",
        "ceph osd pool delete multi-node-other-test multi-node-other-test --yes-i-really-really-mean-it",
    )

    # Shut down ceph on all machines in a very unpolite way
    monA.crash()
    osd0.crash()
    osd1.crash()
    osd2.crash()

    # Start it up
    osd0.start()
    osd1.start()
    osd2.start()
    monA.start()

    # Ensure the cluster comes back up again
    monA.succeed("ceph -s | grep 'mon: 1 daemons'")
    monA.wait_until_succeeds("ceph -s | grep 'quorum ${cfg.monA.name}'")
    monA.wait_until_succeeds("ceph osd stat | grep -e '3 osds: 3 up[^,]*, 3 in'")
    monA.wait_until_succeeds("ceph -s | grep 'mgr: ${cfg.monA.name}(active,'")
    monA.wait_until_succeeds("ceph -s | grep 'HEALTH_OK'")
  '';
in {
  name = "basic-multi-node-ceph-cluster";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ lejonet ];
  };

  nodes = {
    monA = generateHost { pkgs = pkgs; cephConfig = cephConfigMonA; networkConfig = networkMonA; };
    osd0 = generateHost { pkgs = pkgs; cephConfig = cephConfigOsd cfg.osd0; networkConfig = networkOsd cfg.osd0; };
    osd1 = generateHost { pkgs = pkgs; cephConfig = cephConfigOsd cfg.osd1; networkConfig = networkOsd cfg.osd1; };
    osd2 = generateHost { pkgs = pkgs; cephConfig = cephConfigOsd cfg.osd2; networkConfig = networkOsd cfg.osd2; };
  };

  testScript = testscript;
})
