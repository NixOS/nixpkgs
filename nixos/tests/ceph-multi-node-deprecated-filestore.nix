# Tests the legacy FileStore OSD backend.
{ lib, ... }:
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
      uuid = "55ba2294-3e24-478f-bee0-9dca4c231dd9";
    };
    osd1 = {
      name = "1";
      ip = "192.168.1.3";
      uuid = "5e97a838-85b6-43b0-8950-cb56d554d1e5";
    };
    osd2 = {
      name = "2";
      ip = "192.168.1.4";
      uuid = "ea999274-13d0-4dd5-9af9-ad25a324f72f";
    };
  };
  generateCephConfig =
    { daemonConfig }:
    {
      enable = true;
      global = {
        fsid = cfg.clusterId;
        monHost = cfg.monA.ip;
        monInitialMembers = cfg.monA.name;
      };
    }
    // daemonConfig;

  generateHost =
    { cephConfig, networkConfig }:
    { pkgs, ... }:
    {
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
        netcat
      ];

      boot.kernelModules = [ "xfs" ];

      services.ceph = cephConfig;
    };

  networkMonA = {
    dhcpcd.enable = false;
    interfaces.eth1.ipv4.addresses = lib.mkOverride 0 [
      {
        address = cfg.monA.ip;
        prefixLength = 24;
      }
    ];
    firewall = {
      allowedTCPPorts = [
        6789
        3300
      ];
      allowedTCPPortRanges = [
        {
          from = 6800;
          to = 7300;
        }
      ];
    };
  };
  cephConfigMonA = generateCephConfig {
    daemonConfig = {
      mon = {
        enable = true;
        daemons = [ cfg.monA.name ];
      };
      mgr = {
        enable = true;
        daemons = [ cfg.monA.name ];
      };
    };
  };

  networkOsd = osd: {
    dhcpcd.enable = false;
    interfaces.eth1.ipv4.addresses = lib.mkOverride 0 [
      {
        address = osd.ip;
        prefixLength = 24;
      }
    ];
    firewall = {
      allowedTCPPortRanges = [
        {
          from = 6800;
          to = 7300;
        }
      ];
    };
  };

  cephConfigOsd =
    osd:
    generateCephConfig {
      daemonConfig = {
        osd = {
          enable = true;
          daemons = [ osd.name ];
        };
      };
    };

  # Following deployment is based on the manual deployment described here:
  # https://docs.ceph.com/docs/master/install/manual-deployment/
  # For other ways to deploy a ceph cluster, look at the documentation at
  # https://docs.ceph.com/docs/master/
  testscript =
    { ... }:
    ''
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
          # Create the monmap with both a msgr2 (v2) and a legacy (v1) address.
          # Using plain `--add` yields a v1-only monmap, which leaves the cluster
          # in HEALTH_WARN with MON_MSGR2_NOT_ENABLED. Running `ceph mon
          # enable-msgr2` afterwards is not enough: it rewrites the monmap (a
          # subsequent `ceph mon dump` does show the v2 address), but the health
          # check keeps reporting the mon as v1-only indefinitely.
          "monmaptool --create --addv ${cfg.monA.name} '[v2:${cfg.monA.ip}:3300,v1:${cfg.monA.ip}:6789]' --fsid ${cfg.clusterId} /tmp/monmap",
          "sudo -u ceph ceph-mon --mkfs -i ${cfg.monA.name} --monmap /tmp/monmap --keyring /tmp/ceph.mon.keyring",
          "sudo -u ceph mkdir -p /var/lib/ceph/mgr/ceph-${cfg.monA.name}/",
          "sudo -u ceph touch /var/lib/ceph/mon/ceph-${cfg.monA.name}/done",
          "systemctl start ceph-mon-${cfg.monA.name}",
      )
      monA.wait_for_unit("ceph-mon-${cfg.monA.name}")
      monA.succeed("ceph config set mon auth_allow_insecure_global_id_reclaim false")

      # Can't check ceph status until a mon is up
      monA.succeed("ceph -s | grep 'mon: 1 daemons'")

      # Start the ceph-mgr daemon, it has no deps and hardly any setup
      monA.succeed(
          "ceph auth get-or-create mgr.${cfg.monA.name} mon 'allow profile mgr' osd 'allow *' mds 'allow *' > /var/lib/ceph/mgr/ceph-${cfg.monA.name}/keyring",
          "sync",  # to ensure shell redirection above is durable
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
      for machine, osd_name, osd_uuid in [
          (osd0, "${cfg.osd0.name}", "${cfg.osd0.uuid}"),
          (osd1, "${cfg.osd1.name}", "${cfg.osd1.uuid}"),
          (osd2, "${cfg.osd2.name}", "${cfg.osd2.uuid}"),
      ]:
          machine.succeed(
              "mkfs.xfs /dev/vdb",
              f"mkdir -p /var/lib/ceph/osd/ceph-{osd_name}",
              f"mount /dev/vdb /var/lib/ceph/osd/ceph-{osd_name}",
              f"ceph-authtool --create-keyring /var/lib/ceph/osd/ceph-{osd_name}/keyring --name osd.{osd_name} --gen-key",
          )
          # Register the OSD with the generated key read back from its keyring.
          key = machine.succeed(
              f"ceph-authtool --print-key /var/lib/ceph/osd/ceph-{osd_name}/keyring --name osd.{osd_name}"
          ).strip()
          machine.succeed(
              f"echo '{{\"cephx_secret\": \"{key}\"}}' | ceph osd new {osd_uuid} -i -"
          )

      # We `sync` so that the config survives the forced crashes below.
      osd0.succeed(
          "ceph-osd -i ${cfg.osd0.name} --mkfs --osd-uuid ${cfg.osd0.uuid}",
          "chown -R ceph:ceph /var/lib/ceph/osd",
          "sync",
          "systemctl start ceph-osd-${cfg.osd0.name}",
      )
      osd1.succeed(
          "ceph-osd -i ${cfg.osd1.name} --mkfs --osd-uuid ${cfg.osd1.uuid}",
          "chown -R ceph:ceph /var/lib/ceph/osd",
          "sync",
          "systemctl start ceph-osd-${cfg.osd1.name}",
      )
      osd2.succeed(
          "ceph-osd -i ${cfg.osd2.name} --mkfs --osd-uuid ${cfg.osd2.uuid}",
          "chown -R ceph:ceph /var/lib/ceph/osd",
          "sync",
          "systemctl start ceph-osd-${cfg.osd2.name}",
      )
      monA.wait_until_succeeds("ceph osd stat | grep -e '3 osds: 3 up[^,]*, 3 in'")
      monA.wait_until_succeeds("ceph -s | grep 'mgr: ${cfg.monA.name}(active,'")
      monA.wait_until_succeeds("ceph -s | grep 'HEALTH_OK'")

      monA.succeed(
          "ceph osd pool create multi-node-test 32 32",
          "ceph osd pool ls | grep 'multi-node-test'",

          # We need to enable an application on the pool, otherwise it will
          # stay unhealthy in state POOL_APP_NOT_ENABLED.
          # Creating a CephFS would do this automatically, but we haven't done that here.
          # See: https://docs.ceph.com/en/reef/rados/operations/pools/#associating-a-pool-with-an-application
          # We use the custom application name "nixos-test" for this.
          "ceph osd pool application enable multi-node-test nixos-test",

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
in
{
  name = "basic-multi-node-ceph-cluster-deprecated-filestore";
  meta = with lib.maintainers; {
    maintainers = [ lejonet ];
  };

  nodes = {
    monA = generateHost {
      cephConfig = cephConfigMonA;
      networkConfig = networkMonA;
    };
    osd0 = generateHost {
      cephConfig = cephConfigOsd cfg.osd0;
      networkConfig = networkOsd cfg.osd0;
    };
    osd1 = generateHost {
      cephConfig = cephConfigOsd cfg.osd1;
      networkConfig = networkOsd cfg.osd1;
    };
    osd2 = generateHost {
      cephConfig = cephConfigOsd cfg.osd2;
      networkConfig = networkOsd cfg.osd2;
    };
  };

  testScript = testscript;
}
