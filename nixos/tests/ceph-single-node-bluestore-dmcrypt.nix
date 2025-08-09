{ lib, ... }:

let
  # the single node ipv6 address
  ip = "2001:db8:ffff::";
  # the global ceph cluster id
  cluster = "54465b37-b9d8-4539-a1f9-dd33c75ee45a";
  # the fsids of OSDs
  osd-fsid-map = {
    "0" = "1c1b7ea9-06bf-4d30-9a01-37ac3a0254aa";
    "1" = "bd5a6f49-69d5-428c-ac25-a99f0c44375c";
    "2" = "c90de6c7-86c6-41da-9694-e794096dfc5c";
  };
in
{
  name = "basic-single-node-ceph-cluster-bluestore-dmcrypt";
  meta.maintainers = with lib.maintainers; [
    benaryorg
    nh2
  ];

  nodes.ceph =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      # disks for bluestore
      virtualisation.emptyDiskImages = [
        20480
        20480
        20480
      ];

      # networking setup (no external connectivity required, only local IPv6)
      networking.useDHCP = false;
      systemd.network = {
        enable = true;
        wait-online.extraArgs = [
          "-i"
          "lo"
        ];
        networks = {
          "40-loopback" = {
            enable = true;
            name = "lo";
            DHCP = "no";
            addresses = [ { Address = "${ip}/128"; } ];
          };
        };
      };

      # do not start the ceph target by default so we can format the disks first
      systemd.targets.ceph.wantedBy = lib.mkForce [ ];

      # add the packages to systemPackages so the testscript doesn't run into any unexpected issues
      # this shouldn't be required on production systems which have their required packages in the unit paths only
      # but it helps in case one needs to actually run the tooling anyway
      environment.systemPackages = with pkgs; [
        ceph
        cryptsetup
        lvm2
      ];

      services.ceph = {
        enable = true;
        client.enable = true;
        extraConfig = {
          public_addr = ip;
          cluster_addr = ip;
          # ipv6
          ms_bind_ipv4 = "false";
          ms_bind_ipv6 = "true";
          # msgr2 settings
          ms_cluster_mode = "secure";
          ms_service_mode = "secure";
          ms_client_mode = "secure";
          ms_mon_cluster_mode = "secure";
          ms_mon_service_mode = "secure";
          ms_mon_client_mode = "secure";
          # less default modules, cuts down on memory and startup time in the tests
          mgr_initial_modules = "";
          # distribute by OSD, not by host, as per https://docs.ceph.com/en/reef/cephadm/install/#single-host
          osd_crush_chooseleaf_type = "0";
        };
        client.extraConfig."mon.0" = {
          host = "ceph";
          mon_addr = "v2:[${ip}]:3300";
          public_addr = "v2:[${ip}]:3300";
        };
        global = {
          fsid = cluster;
          clusterNetwork = "${ip}/64";
          publicNetwork = "${ip}/64";
          monInitialMembers = "0";
        };

        mon = {
          enable = true;
          daemons = [ "0" ];
        };

        osd = {
          enable = true;
          daemons = builtins.attrNames osd-fsid-map;
        };

        mgr = {
          enable = true;
          daemons = [ "ceph" ];
        };
      };

      systemd.services =
        let
          osd-name = id: "ceph-osd-${id}";
          osd-pre-start = id: [
            "!${config.services.ceph.osd.package.out}/bin/ceph-volume lvm activate --bluestore ${id} ${osd-fsid-map.${id}} --no-systemd"
            "${config.services.ceph.osd.package.lib}/libexec/ceph/ceph-osd-prestart.sh --id ${id} --cluster ${config.services.ceph.global.clusterName}"
          ];
          osd-post-stop = id: [
            "!${config.services.ceph.osd.package.out}/bin/ceph-volume lvm deactivate ${id}"
          ];
          map-osd = id: {
            name = osd-name id;
            value = {
              serviceConfig.ExecStartPre = lib.mkForce (osd-pre-start id);
              serviceConfig.ExecStopPost = osd-post-stop id;
              unitConfig.ConditionPathExists = lib.mkForce [ ];
              unitConfig.StartLimitBurst = lib.mkForce 4;
              path = with pkgs; [
                util-linux
                lvm2
                cryptsetup
              ];
            };
          };
        in
        lib.pipe config.services.ceph.osd.daemons [
          (builtins.map map-osd)
          builtins.listToAttrs
        ];
    };

  testScript = ''
    start_all()

    ceph.wait_for_unit("default.target")

    # Bootstrap ceph-mon daemon
    ceph.succeed(
        "mkdir -p /var/lib/ceph/bootstrap-osd",
        "ceph-authtool --create-keyring /tmp/ceph.mon.keyring --gen-key -n mon. --cap mon 'allow *'",
        "ceph-authtool --create-keyring /etc/ceph/ceph.client.admin.keyring --gen-key -n client.admin --cap mon 'allow *' --cap osd 'allow *' --cap mds 'allow *' --cap mgr 'allow *'",
        "ceph-authtool --create-keyring /var/lib/ceph/bootstrap-osd/ceph.keyring --gen-key -n client.bootstrap-osd --cap mon 'profile bootstrap-osd' --cap mgr 'allow r'",
        "ceph-authtool /tmp/ceph.mon.keyring --import-keyring /etc/ceph/ceph.client.admin.keyring",
        "ceph-authtool /tmp/ceph.mon.keyring --import-keyring /var/lib/ceph/bootstrap-osd/ceph.keyring",
        "monmaptool --create --fsid ${cluster} --addv 0 'v2:[${ip}]:3300/0' --clobber /tmp/ceph.initial-monmap",
        "mkdir -p /var/lib/ceph/mon/ceph-0",
        "ceph-mon --mkfs -i 0 --monmap /tmp/ceph.initial-monmap --keyring /tmp/ceph.mon.keyring",
        "chown ceph:ceph -R /tmp/ceph.mon.keyring /var/lib/ceph",
        "systemctl start ceph-mon-0.service",
    )

    ceph.wait_for_unit("ceph-mon-0.service")
    # should the mon not start or bind for some reason this gives us a better error message than the config commands running into a timeout
    ceph.wait_for_open_port(3300, "${ip}")
    ceph.succeed(
        # required for HEALTH_OK
        "ceph config set mon auth_allow_insecure_global_id_reclaim false",
        # IPv6
        "ceph config set global ms_bind_ipv4 false",
        "ceph config set global ms_bind_ipv6 true",
        # the new (secure) protocol
        "ceph config set global ms_bind_msgr1 false",
        "ceph config set global ms_bind_msgr2 true",
        # just a small little thing
        "ceph config set mon mon_compact_on_start true",
    )

    # Can't check ceph status until a mon is up
    ceph.succeed("ceph -s | grep 'mon: 1 daemons'")

    # Bootstrap OSDs (do this before starting the mgr because cryptsetup and the mgr both eat a lot of memory)
    ceph.succeed(
        # this will automatically do what's required for LVM, cryptsetup, and stores all the data in Ceph's internal databases
        "ceph-volume lvm prepare --bluestore --data /dev/vdb --dmcrypt --no-systemd --osd-id 0 --osd-fsid ${osd-fsid-map."0"}",
        "ceph-volume lvm prepare --bluestore --data /dev/vdc --dmcrypt --no-systemd --osd-id 1 --osd-fsid ${osd-fsid-map."1"}",
        "ceph-volume lvm prepare --bluestore --data /dev/vdd --dmcrypt --no-systemd --osd-id 2 --osd-fsid ${osd-fsid-map."2"}",
        "sudo ceph-volume lvm deactivate 0",
        "sudo ceph-volume lvm deactivate 1",
        "sudo ceph-volume lvm deactivate 2",
        "chown -R ceph:ceph /var/lib/ceph",
    )

    # Start OSDs (again, argon2id eats memory, so this happens before starting the mgr)
    ceph.succeed(
        "systemctl start ceph-osd-0.service",
        "systemctl start ceph-osd-1.service",
        "systemctl start ceph-osd-2.service",
    )
    ceph.wait_until_succeeds("ceph -s | grep 'quorum 0'")
    ceph.wait_until_succeeds("ceph osd stat | grep -e '3 osds: 3 up[^,]*, 3 in'")

    # Start the ceph-mgr daemon, after copying in the keyring
    ceph.succeed(
        "mkdir -p /var/lib/ceph/mgr/ceph-ceph/",
        "ceph auth get-or-create -o /var/lib/ceph/mgr/ceph-ceph/keyring mgr.ceph mon 'allow profile mgr' osd 'allow *' mds 'allow *'",
        "chown -R ceph:ceph /var/lib/ceph/mgr/ceph-ceph/",
        "systemctl start ceph-mgr-ceph.service",
    )
    ceph.wait_for_unit("ceph-mgr-ceph")
    ceph.wait_until_succeeds("ceph -s | grep 'quorum 0'")
    ceph.wait_until_succeeds("ceph -s | grep 'mgr: ceph(active,'")
    ceph.wait_until_succeeds("ceph osd stat | grep -e '3 osds: 3 up[^,]*, 3 in'")
    ceph.wait_until_succeeds("ceph -s | grep 'HEALTH_OK'")

    # test the actual storage
    ceph.succeed(
        "ceph osd pool create single-node-test 32 32",
        "ceph osd pool ls | grep 'single-node-test'",

        # We need to enable an application on the pool, otherwise it will
        # stay unhealthy in state POOL_APP_NOT_ENABLED.
        # Creating a CephFS would do this automatically, but we haven't done that here.
        # See: https://docs.ceph.com/en/reef/rados/operations/pools/#associating-a-pool-with-an-application
        # We use the custom application name "nixos-test" for this.
        "ceph osd pool application enable single-node-test nixos-test",

        "ceph osd pool rename single-node-test single-node-other-test",
        "ceph osd pool ls | grep 'single-node-other-test'",
    )
    ceph.wait_until_succeeds("ceph -s | grep '2 pools, 33 pgs'")
    ceph.wait_until_succeeds("ceph -s | grep 'HEALTH_OK'")
    ceph.wait_until_succeeds("ceph -s | grep '33 active+clean'")
    ceph.fail(
        # the old pool should be gone
        "ceph osd pool ls | grep 'multi-node-test'",
        # deleting the pool should fail without setting mon_allow_pool_delete
        "ceph osd pool delete single-node-other-test single-node-other-test --yes-i-really-really-mean-it",
    )

    # rebooting gets rid of any potential tmpfs mounts or device-mapper devices
    ceph.shutdown()
    ceph.start()
    ceph.wait_for_unit("default.target")

    # Start it up (again OSDs first due to memory constraints of cryptsetup and mgr)
    ceph.systemctl("start ceph-mon-0.service")
    ceph.wait_for_unit("ceph-mon-0")
    ceph.systemctl("start ceph-osd-0.service")
    ceph.wait_for_unit("ceph-osd-0")
    ceph.systemctl("start ceph-osd-1.service")
    ceph.wait_for_unit("ceph-osd-1")
    ceph.systemctl("start ceph-osd-2.service")
    ceph.wait_for_unit("ceph-osd-2")
    ceph.systemctl("start ceph-mgr-ceph.service")
    ceph.wait_for_unit("ceph-mgr-ceph")

    # Ensure the cluster comes back up again
    ceph.succeed("ceph -s | grep 'mon: 1 daemons'")
    ceph.wait_until_succeeds("ceph -s | grep 'quorum 0'")
    ceph.wait_until_succeeds("ceph osd stat | grep -E '3 osds: 3 up[^,]*, 3 in'")
    ceph.wait_until_succeeds("ceph -s | grep 'mgr: ceph(active,'")
    ceph.wait_until_succeeds("ceph -s | grep 'HEALTH_OK'")
  '';
}
