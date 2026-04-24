# Similar to ceph-single-node-bluestore-dmcrypt test, but uses the upstream ceph
# systemd units directly via systemd.packages instead of the NixOS services.ceph
# module.
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
  name = "basic-single-node-ceph-cluster-systemd";
  meta.maintainers = with lib.maintainers; [
    benaryorg
    josh
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
      virtualisation.memorySize = 2048;

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

      # Use upstream ceph systemd units directly
      systemd.packages = [ pkgs.ceph ];

      # add the packages to systemPackages so the testscript doesn't run into any unexpected issues
      # this shouldn't be required on production systems which have their required packages in the unit paths only
      # but it helps in case one needs to actually run the tooling anyway
      environment.systemPackages = with pkgs; [
        ceph
        cryptsetup
        lvm2
      ];

      environment.etc."ceph/ceph.conf".text = ''
        [global]
        fsid = ${cluster}
        mon initial members = 0
        public addr = ${ip}
        cluster addr = ${ip}
        public network = ${ip}/64
        cluster network = ${ip}/64
        ms bind ipv4 = false
        ms bind ipv6 = true
        ms cluster mode = secure
        ms service mode = secure
        ms client mode = secure
        ms mon cluster mode = secure
        ms mon service mode = secure
        ms mon client mode = secure
        mgr initial modules =
        osd crush chooseleaf type = 0

        [mon.0]
        host = ceph
        mon addr = v2:[${ip}]:3300
        public addr = v2:[${ip}]:3300
      '';

      users.users.ceph = {
        uid = config.ids.uids.ceph;
        group = "ceph";
        extraGroups = [ "disk" ];
        isSystemUser = true;
      };
      users.groups.ceph = {
        gid = config.ids.gids.ceph;
      };

      systemd.tmpfiles.settings."10-ceph" = {
        "/etc/ceph".d = {
          user = "ceph";
          group = "ceph";
        };
        "/run/ceph".d = {
          user = "ceph";
          group = "ceph";
          mode = "0770";
        };
        "/var/lib/ceph".d = {
          user = "ceph";
          group = "ceph";
        };
        "/var/lib/ceph/mon".d = {
          user = "ceph";
          group = "ceph";
        };
        "/var/lib/ceph/mgr".d = {
          user = "ceph";
          group = "ceph";
        };
        "/var/lib/ceph/osd".d = {
          user = "ceph";
          group = "ceph";
        };
      };

      # Enable ceph units on boot. systemd.packages can't handle this automatically
      # for a full list see: `systemd/50-ceph.preset` in the Ceph sources
      systemd.targets.ceph.wantedBy = [ "multi-user.target" ];
      systemd.targets.ceph-mon.wantedBy = [ "ceph.target" ];
      systemd.targets.ceph-mgr.wantedBy = [ "ceph.target" ];
      systemd.targets.ceph-osd.wantedBy = [ "ceph.target" ];

      systemd.services =
        let
          osd-ids = builtins.attrNames osd-fsid-map;
          volume-unit = id: "ceph-volume@lvm-${id}-${osd-fsid-map.${id}}";
          osd-volume = i: id: {
            name = volume-unit id;
            value = {
              overrideStrategy = "asDropin";
              serviceConfig.ExecStart = [
                "" # Override ExecStart to disable systemd generation over read only /etc
                "${pkgs.ceph.out}/bin/ceph-volume lvm activate --bluestore ${id} ${osd-fsid-map.${id}} --no-systemd"
              ];

              # Sequence osd activation to stay within test VM memory limits
              after = lib.optional (i > 0) "${volume-unit (builtins.elemAt osd-ids (i - 1))}.service";
              before = [ "ceph-osd@${id}.service" ];
              requiredBy = [ "ceph-osd@${id}.service" ];

              # Skip activation on first boot before bootstrap keyrings exist
              unitConfig.ConditionPathExists = "/var/lib/ceph/bootstrap-osd/ceph.keyring";

              path = with pkgs; [
                util-linux
                lvm2
                cryptsetup
              ];
            };
          };
          osd-instance = id: {
            name = "ceph-osd@${id}";
            value = {
              overrideStrategy = "asDropin";
              wantedBy = [ "ceph-osd.target" ];
              unitConfig.ConditionPathExists = "/var/lib/ceph/bootstrap-osd/ceph.keyring";
            };
          };
        in
        {
          "ceph-mon@0" = {
            overrideStrategy = "asDropin";
            wantedBy = [ "ceph-mon.target" ];
            unitConfig.ConditionPathExists = "/var/lib/ceph/mon/ceph-0";
          };
          "ceph-mgr@ceph" = {
            overrideStrategy = "asDropin";
            wantedBy = [ "ceph-mgr.target" ];
            unitConfig.ConditionPathExists = "/var/lib/ceph/mgr/ceph-ceph/keyring";
          };
        }
        // builtins.listToAttrs (lib.imap0 osd-volume osd-ids)
        // builtins.listToAttrs (map osd-instance osd-ids);
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
        "systemctl start ceph-mon@0.service",
    )

    ceph.wait_for_unit("ceph-mon@0.service")
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

    # Start OSDs one at a time to stay under memory limits
    ceph.succeed("systemctl start ceph-osd@0.service")
    ceph.succeed("systemctl start ceph-osd@1.service")
    ceph.succeed("systemctl start ceph-osd@2.service")
    ceph.wait_until_succeeds("ceph -s | grep 'quorum 0'")
    ceph.wait_until_succeeds("ceph osd stat | grep -e '3 osds: 3 up[^,]*, 3 in'")

    # Start the ceph-mgr daemon, after copying in the keyring
    ceph.succeed(
        "mkdir -p /var/lib/ceph/mgr/ceph-ceph/",
        "ceph auth get-or-create -o /var/lib/ceph/mgr/ceph-ceph/keyring mgr.ceph mon 'allow profile mgr' osd 'allow *' mds 'allow *'",
        "chown -R ceph:ceph /var/lib/ceph/mgr/ceph-ceph/",
        "systemctl start ceph-mgr@ceph.service",
    )
    ceph.wait_for_unit("ceph-mgr@ceph.service")
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

    # Rebooting gets rid of any potential tmpfs mounts or device-mapper devices.
    ceph.shutdown()
    ceph.start()
    ceph.wait_for_unit("default.target")
    ceph.wait_for_unit("ceph-mon@0.service")
    ceph.wait_for_unit("ceph-osd@0.service")
    ceph.wait_for_unit("ceph-osd@1.service")
    ceph.wait_for_unit("ceph-osd@2.service")
    ceph.wait_for_unit("ceph-mgr@ceph.service")

    # Ensure the cluster comes back up again
    ceph.succeed("ceph -s | grep 'mon: 1 daemons'")
    ceph.wait_until_succeeds("ceph -s | grep 'quorum 0'")
    ceph.wait_until_succeeds("ceph osd stat | grep -E '3 osds: 3 up[^,]*, 3 in'")
    ceph.wait_until_succeeds("ceph -s | grep 'mgr: ceph(active,'")
    ceph.wait_until_succeeds("ceph -s | grep 'HEALTH_OK'")
  '';
}
