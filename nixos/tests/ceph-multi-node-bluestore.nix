# Multi-node Ceph cluster test using BlueStore OSDs.
{
  withCephfs ? false,
}:
{ lib, ... }:
let
  # Development knobs:
  # * `defaultTimeout` caps how long every `waitUntilSucceeds` waits before it
  #   gives up. Lower it for faster feedback while iterating on the test.
  # * When `investigateFailures` is true, a `waitUntilSucceeds` that times out
  #   does NOT fail the test; instead it dumps each machine's full (multi-boot)
  #   journal and `/var/log/ceph` into a `test-failure-investigation/` directory
  #   inside the test's working/output directory and then lets the test succeed,
  #   so the collected logs end up in the build's store path for convenient
  #   reading. Keep this `false` for real CI runs.
  defaultTimeout = 60;
  investigateFailures = false;

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
    # Client that mounts CephFS using the in-kernel client.
    kclient = {
      ip = "192.168.1.5";
    };
    # Client that mounts CephFS using the `ceph-fuse` client.
    fuseclient = {
      ip = "192.168.1.6";
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
        # A single raw block device per machine, consumed directly by BlueStore
        # as `/dev/vdb`. Because BlueStore owns the raw device (there is no
        # filesystem to mount), the OSD's on-disk state survives a hard
        # crash/reboot and the OSD comes back automatically.
        emptyDiskImages = [ 20480 ];
        vlans = [ 1 ];
      };

      networking = networkConfig;

      # TODO: Why do we need any of these? Shouldn't Ceph work independent of `systemPackages`? Only `sudo` and `ceph` are used in our own test code.
      environment.systemPackages = with pkgs; [
        bash
        sudo
        ceph
        netcat
      ];

      services.ceph = cephConfig;

      # Restart limits are unsuitable for daemons that must recover from
      # arbitrary crash/network downtimes.
      # Ensure all daemons have infinite restart limits.
      # Otherwise the tests are flaky based on timing.
      systemd.services =
        let
          daemonUnits =
            lib.concatMap
              (
                daemonType:
                lib.optionals (cephConfig.${daemonType}.enable or false) (
                  map (daemon: "ceph-${daemonType}-${daemon}") cephConfig.${daemonType}.daemons
                )
              )
              [
                "mon"
                "mgr"
                "osd"
                "mds"
              ];
        in
        lib.genAttrs daemonUnits (_: {
          serviceConfig.Restart = lib.mkForce "always";
          serviceConfig.RestartSec = lib.mkForce "1";
          unitConfig.StartLimitIntervalSec = lib.mkForce 0; # Ensure Restart=always is always honoured (no start limit)
        });
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
    }
    # The MDS daemon (which provides CephFS) is only configured in the CephFS
    # variant of this test.
    // lib.optionalAttrs withCephfs {
      mds = {
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

  # The CephFS clients only need the ceph client tooling. They do not run any
  # ceph daemon, so they only get a minimal ceph config pointing at the mon.
  # The in-kernel ceph filesystem module is part of the default kernel and is
  # autoloaded by `mount -t ceph`, so no extra modules are needed.
  networkClient = client: {
    dhcpcd.enable = false;
    interfaces.eth1.ipv4.addresses = lib.mkOverride 0 [
      {
        address = client.ip;
        prefixLength = 24;
      }
    ];
  };

  cephConfigClient = generateCephConfig { daemonConfig = { }; };

  generateClientHost =
    { networkConfig }:
    { pkgs, ... }:
    {
      virtualisation = {
        vlans = [ 1 ];
      };

      networking = networkConfig;

      environment.systemPackages = with pkgs; [
        ceph
      ];

      services.ceph = cephConfigClient;
    };

  # Python prelude that must run before any test code.
  # It replaces every machine's `wait_until_succeeds()` with a wrapper that
  # implements the "development knobs" above.
  helperScript = ''
    import os
    import shutil

    DEFAULT_TIMEOUT = ${toString defaultTimeout}
    INVESTIGATE_FAILURES = ${if investigateFailures then "True" else "False"}

    def collect_failure_investigation(failed_machine, command):
        out_dir = os.path.join(driver.out_dir, "test-failure-investigation")
        os.makedirs(out_dir, exist_ok=True)
        with open(os.path.join(out_dir, "README.txt"), "w") as f:
            f.write(
                "wait_until_succeeds timed out on machine "
                f"'{failed_machine.name}' running command:\n{command}\n"
            )
        for m in machines:
            try:
                m.execute("journalctl --no-pager --boot=all > /tmp/journal.txt 2>&1; true")
                m.copy_from_machine("/tmp/journal.txt", out_dir)
                shutil.move(
                    os.path.join(out_dir, "journal.txt"),
                    os.path.join(out_dir, f"{m.name}-journal.txt"),
                )
            except Exception as e:
                m.log(f"could not collect journal: {e}")
            try:
                m.copy_from_machine("/var/log/ceph", out_dir)
                shutil.move(
                    os.path.join(out_dir, "ceph"),
                    os.path.join(out_dir, f"{m.name}-ceph-logs"),
                )
            except Exception as e:
                m.log(f"could not collect /var/log/ceph: {e}")

    # Replace the test driver's `wait_until_succeeds` with our wrapper.
    machine_class = machines[0].__class__
    orig_wait_until_succeeds = machine_class.wait_until_succeeds

    def patched_wait_until_succeeds(self, command: str, timeout: int = DEFAULT_TIMEOUT) -> str:
        try:
            return orig_wait_until_succeeds(self, command, timeout=timeout)
        except Exception:
            if not INVESTIGATE_FAILURES:
                raise
            self.log(
                "wait_until_succeeds timed out; collecting logs into "
                "test-failure-investigation/ and ending the test as 'passed' "
                "(investigateFailures = true)"
            )
            collect_failure_investigation(self, command)
            os._exit(0)

    # Use `setattr` (rather than a plain attribute assignment) so the type
    # checker does not treat this as implicitly shadowing the driver's
    # `wait_until_succeeds`; the replacement is intentional.
    setattr(machine_class, "wait_until_succeeds", patched_wait_until_succeeds)
  '';

  # Set up the cluster (mon, mgr, BlueStore OSDs) and perform a
  # hard whole-cluster crash/recovery (failover) test.
  #
  # Based on the "manual deployment" approach from:
  # https://docs.ceph.com/en/tentacle/install/manual-deployment/
  baseScript = ''
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
        "sync",  # to ensure shell redirection above is durable
        "systemctl start ceph-mgr-${cfg.monA.name}",
    )
    monA.wait_for_unit("ceph-mgr-a")
    monA.wait_until_succeeds("ceph -s | grep 'quorum ${cfg.monA.name}'")
    monA.wait_until_succeeds("ceph -s | grep 'mgr: ${cfg.monA.name}(active,'")

    # Send the admin keyring to the OSD machines.
    monA.succeed("cp /etc/ceph/ceph.client.admin.keyring /tmp/shared")
    osd0.succeed("cp /tmp/shared/ceph.client.admin.keyring /etc/ceph")
    osd1.succeed("cp /tmp/shared/ceph.client.admin.keyring /etc/ceph")
    osd2.succeed("cp /tmp/shared/ceph.client.admin.keyring /etc/ceph")

    # Bootstrap the BlueStore OSDs.
    osd0.succeed(
        "mkdir -p /var/lib/ceph/osd/ceph-${cfg.osd0.name}",
        "echo bluestore > /var/lib/ceph/osd/ceph-${cfg.osd0.name}/type",
        "ln -sf /dev/vdb /var/lib/ceph/osd/ceph-${cfg.osd0.name}/block",
        "ceph-authtool --create-keyring /var/lib/ceph/osd/ceph-${cfg.osd0.name}/keyring --name osd.${cfg.osd0.name} --add-key ${cfg.osd0.key}",
        'echo \'{"cephx_secret": "${cfg.osd0.key}"}\' | ceph osd new ${cfg.osd0.uuid} -i -',
    )
    osd1.succeed(
        "mkdir -p /var/lib/ceph/osd/ceph-${cfg.osd1.name}",
        "echo bluestore > /var/lib/ceph/osd/ceph-${cfg.osd1.name}/type",
        "ln -sf /dev/vdb /var/lib/ceph/osd/ceph-${cfg.osd1.name}/block",
        "ceph-authtool --create-keyring /var/lib/ceph/osd/ceph-${cfg.osd1.name}/keyring --name osd.${cfg.osd1.name} --add-key ${cfg.osd1.key}",
        'echo \'{"cephx_secret": "${cfg.osd1.key}"}\' | ceph osd new ${cfg.osd1.uuid} -i -',
    )
    osd2.succeed(
        "mkdir -p /var/lib/ceph/osd/ceph-${cfg.osd2.name}",
        "echo bluestore > /var/lib/ceph/osd/ceph-${cfg.osd2.name}/type",
        "ln -sf /dev/vdb /var/lib/ceph/osd/ceph-${cfg.osd2.name}/block",
        "ceph-authtool --create-keyring /var/lib/ceph/osd/ceph-${cfg.osd2.name}/keyring --name osd.${cfg.osd2.name} --add-key ${cfg.osd2.key}",
        'echo \'{"cephx_secret": "${cfg.osd2.key}"}\' | ceph osd new ${cfg.osd2.uuid} -i -',
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

        # A pool that has no application associated with it stays unhealthy in
        # state POOL_APP_NOT_ENABLED. Ceph only auto-associates an application
        # for pools it manages itself, such as CephFS data/metadata pools
        # (application "cephfs") and the pools RGW creates (application "rgw"); see
        # https://docs.ceph.com/en/tentacle/rados/operations/pools/#associating-a-pool-with-an-application
        # This is a plain RADOS pool, so we have to associate an application
        # with it ourselves. We use the custom application name "nixos-test".
        "ceph osd pool application enable multi-node-test nixos-test",

        "ceph osd pool rename multi-node-test multi-node-other-test",
        "ceph osd pool ls | grep 'multi-node-other-test'",
    )
    monA.succeed("ceph osd pool set multi-node-other-test size 2")
    monA.wait_until_succeeds("ceph -s | grep 'HEALTH_OK'")
    monA.wait_until_succeeds("! ceph -s | grep -e 'unknown' -e 'pgs inactive'")
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

    # Ensure the cluster comes back up again.
    monA.wait_until_succeeds("ceph -s | grep 'mon: 1 daemons'")
    monA.wait_until_succeeds("ceph -s | grep 'quorum ${cfg.monA.name}'")
    monA.wait_until_succeeds("ceph osd stat | grep -e '3 osds: 3 up[^,]*, 3 in'")
    monA.wait_until_succeeds("ceph -s | grep 'mgr: ${cfg.monA.name}(active,'")
    monA.wait_until_succeeds("ceph -s | grep 'HEALTH_OK'")

    # Verify the recovery.
    monA.wait_until_succeeds("! ceph -s | grep -e 'unknown' -e 'pgs inactive'", timeout=60)
  '';

  # For `withCephfs = true`, after the regular failover, test CephFS and mounts:
  # * bring up an MDS
  # * create a CephFS
  # * mount it via in-kernel ("kclient") and a `ceph-fuse` ("fuseclient")
  #   from 2 different nodes
  # * verify bidirectional visibility of file changes
  # * performs another crash/recovery test (without crashing the clients)
  # * verifiy the mounts survive and keep working.
  cephfsScript = ''
    kclient.wait_for_unit("network.target")
    fuseclient.wait_for_unit("network.target")

    # Start the ceph-mds daemon (which provides CephFS), after creating
    # its keyring and data dir.
    monA.succeed(
        "sudo -u ceph mkdir -p /var/lib/ceph/mds/ceph-${cfg.monA.name}/",
        "ceph auth get-or-create mds.${cfg.monA.name} mon 'allow profile mds' mgr 'allow profile mds' osd 'allow rwx' mds 'allow' > /var/lib/ceph/mds/ceph-${cfg.monA.name}/keyring",
        "chown ceph:ceph /var/lib/ceph/mds/ceph-${cfg.monA.name}/keyring",
        "sync",  # to ensure config survives the forced crashes below
        "systemctl start ceph-mds-${cfg.monA.name}",
    )
    monA.wait_for_unit("ceph-mds-${cfg.monA.name}")

    # Create a CephFS.
    monA.succeed(
        "ceph osd pool create cephfs-data 32 32",
        "ceph osd pool create cephfs-metadata 32 32",
        "ceph fs new cephfs cephfs-metadata cephfs-data",
    )
    # Wait for the MDS to claim the filesystem and become active.
    monA.wait_until_succeeds("ceph fs status cephfs | grep -e 'active'", timeout=60)

    # Distribute the admin keyring (and a plain secret file for the kernel
    # client) to both client machines, so that they can authenticate.
    monA.succeed(
        "cp /etc/ceph/ceph.client.admin.keyring /tmp/shared",
        "ceph-authtool -p /etc/ceph/ceph.client.admin.keyring > /tmp/shared/admin.secret",
    )
    kclient.succeed("cp /tmp/shared/ceph.client.admin.keyring /etc/ceph")
    fuseclient.succeed("cp /tmp/shared/ceph.client.admin.keyring /etc/ceph")
    kclient.succeed("cp /tmp/shared/admin.secret /etc/ceph/admin.secret")

    # Mount CephFS on the kernel client.
    # We force the messenger v2 protocol via "ms_mode=secure"; the cluster
    # has msgr2 enabled (see "ceph mon enable-msgr2" above) and the legacy v1
    # protocol apparently does not reconnect reliably after the servers are restarted.
    # The msgr2 monitor listens on port 3300 (instead of legacy v1 port 6789),
    # so we have to point the device string at that port explicitly.
    # `recover_session=clean` makes the kernel client automatically reconnect
    # (discarding its stale session) after the whole cluster has been down,
    # which would otherwise leave the mount blocklisted and hanging forever.
    # Real CephFS use may not prefer hanging `recover_session=clean`, and
    # prefer manual de-blocklisting to avoid any failed OS syscalls,
    # but for this test, discarding stale sessions is good enough.
    kclient.succeed("mkdir -p /mnt/cephfs")
    kclient.wait_until_succeeds(
        "mount -t ceph ${cfg.monA.ip}:3300:/ /mnt/cephfs -o name=admin,secretfile=/etc/ceph/admin.secret,ms_mode=secure,recover_session=clean"
    )
    kclient.succeed("mountpoint /mnt/cephfs")

    # Mount CephFS on the FUSE client using ceph-fuse.
    fuseclient.succeed("mkdir -p /mnt/cephfs")
    fuseclient.wait_until_succeeds(
        "ceph-fuse --id admin -m ${cfg.monA.ip}:6789 /mnt/cephfs"
    )
    fuseclient.succeed("mountpoint /mnt/cephfs")

    # Both clients mount the same CephFS, so files written by one must be
    # visible to the other. Verify this in both directions.

    # Kernel client writes, FUSE client reads.
    kclient.succeed("echo 'written by kclient' > /mnt/cephfs/from-kclient")
    fuseclient.wait_until_succeeds(
        "test \"$(cat /mnt/cephfs/from-kclient)\" = 'written by kclient'"
    )

    # FUSE client writes, kernel client reads.
    fuseclient.succeed("echo 'written by fuseclient' > /mnt/cephfs/from-fuseclient")
    kclient.wait_until_succeeds(
        "test \"$(cat /mnt/cephfs/from-fuseclient)\" = 'written by fuseclient'"
    )

    # Crash test with CephFS.
    # We deliberately do not crash the CephFS clients here: Their mounts must
    # survive the (temporary) outage of the ceph servers and resume working
    # once the cluster is healthy again.
    monA.crash()
    osd0.crash()
    osd1.crash()
    osd2.crash()

    # Start it up
    osd0.start()
    osd1.start()
    osd2.start()
    monA.start()

    # Ensure the cluster comes back up again.
    # See the note above on why this uses `wait_until_succeeds`.
    monA.wait_until_succeeds("ceph -s | grep 'mon: 1 daemons'")
    monA.wait_until_succeeds("ceph -s | grep 'quorum ${cfg.monA.name}'")
    monA.wait_until_succeeds("ceph osd stat | grep -e '3 osds: 3 up[^,]*, 3 in'")
    monA.wait_until_succeeds("ceph -s | grep 'mgr: ${cfg.monA.name}(active,'")

    monA.wait_until_succeeds("ceph -s | grep 'HEALTH_OK'", timeout=60)

    # Ensure the MDS/CephFS comes back up again, too.
    monA.wait_for_unit("ceph-mds-${cfg.monA.name}")
    monA.wait_until_succeeds("ceph fs status cephfs | grep -e 'active'", timeout=60)
    monA.wait_until_succeeds("ceph -s | grep 'HEALTH_OK'")

    # The clients kept running across the outage, so their CephFS mounts
    # should still be present and should reconnect automatically.
    kclient.succeed("mountpoint /mnt/cephfs")
    fuseclient.succeed("mountpoint /mnt/cephfs")

    # The files written before the crash must still have the correct content.
    kclient.wait_until_succeeds(
        "test \"$(cat /mnt/cephfs/from-fuseclient)\" = 'written by fuseclient'"
    )
    fuseclient.wait_until_succeeds(
        "test \"$(cat /mnt/cephfs/from-kclient)\" = 'written by kclient'"
    )

    # Ensure the mounts are still writable after recovery, in both directions.
    kclient.succeed("echo 'written by kclient after recovery' > /mnt/cephfs/from-kclient-2")
    fuseclient.wait_until_succeeds(
        "test \"$(cat /mnt/cephfs/from-kclient-2)\" = 'written by kclient after recovery'"
    )
    fuseclient.succeed("echo 'written by fuseclient after recovery' > /mnt/cephfs/from-fuseclient-2")
    kclient.wait_until_succeeds(
        "test \"$(cat /mnt/cephfs/from-fuseclient-2)\" = 'written by fuseclient after recovery'"
    )
  '';

in
{
  name = "basic-multi-node-ceph-cluster-bluestore" + lib.optionalString withCephfs "-cephfs";
  meta = {
    maintainers = with lib.maintainers; [
      nh2
      benaryorg
    ];
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
  }
  # CephFS client machines are only needed when testing CephFS.
  // lib.optionalAttrs withCephfs {
    kclient = generateClientHost {
      networkConfig = networkClient cfg.kclient;
    };
    fuseclient = generateClientHost {
      networkConfig = networkClient cfg.fuseclient;
    };
  };

  testScript =
    { ... }:
    ''
      ${helperScript}
      ${baseScript}
      ${lib.optionalString withCephfs cephfsScript}
    '';
}
