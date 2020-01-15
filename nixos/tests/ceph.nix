import ./make-test.nix ({pkgs, lib, ...}: {
  name = "All-in-one-basic-ceph-cluster";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ johanot lejonet ];
  };

  nodes = {
    aio = { pkgs, ... }: {
      virtualisation = {
        memorySize = 1536;
        emptyDiskImages = [ 20480 20480 ];
        vlans = [ 1 ];
      };

      networking = {
        useDHCP = false;
        interfaces.eth1.ipv4.addresses = pkgs.lib.mkOverride 0 [
          { address = "192.168.1.1"; prefixLength = 24; }
        ];
      };

      environment.systemPackages = with pkgs; [
        bash
        sudo
        ceph
        xfsprogs
      ];

      boot.kernelModules = [ "xfs" ];

      services.ceph.enable = true;
      services.ceph.global = {
        fsid = "066ae264-2a5d-4729-8001-6ad265f50b03";
        monInitialMembers = "aio";
        monHost = "192.168.1.1";
      };

      services.ceph.mon = {
        enable = true;
        daemons = [ "aio" ];
      };

      services.ceph.mgr = {
        enable = true;
        daemons = [ "aio" ];
      };

      services.ceph.osd = {
        enable = true;
        daemons = [ "0" "1" ];
      };

      # So that we don't have to battle systemd when bootstraping
      systemd.targets.ceph.wantedBy = lib.mkForce [];
    };
  };

  testScript = { ... }: ''
    startAll;

    $aio->waitForUnit("network.target");

    # Create the ceph-related directories
    $aio->mustSucceed(
      "mkdir -p /var/lib/ceph/mgr/ceph-aio",
      "mkdir -p /var/lib/ceph/mon/ceph-aio",
      "mkdir -p /var/lib/ceph/osd/ceph-{0,1}",
      "chown ceph:ceph -R /var/lib/ceph/",
      "mkdir -p /etc/ceph",
      "chown ceph:ceph -R /etc/ceph"
    );

    # Bootstrap ceph-mon daemon
    $aio->mustSucceed(
      "sudo -u ceph ceph-authtool --create-keyring /tmp/ceph.mon.keyring --gen-key -n mon. --cap mon 'allow *'",
      "sudo -u ceph ceph-authtool --create-keyring /etc/ceph/ceph.client.admin.keyring --gen-key -n client.admin --cap mon 'allow *' --cap osd 'allow *' --cap mds 'allow *' --cap mgr 'allow *'",
      "sudo -u ceph ceph-authtool /tmp/ceph.mon.keyring --import-keyring /etc/ceph/ceph.client.admin.keyring",
      "monmaptool --create --add aio 192.168.1.1 --fsid 066ae264-2a5d-4729-8001-6ad265f50b03 /tmp/monmap",
      "sudo -u ceph ceph-mon --mkfs -i aio --monmap /tmp/monmap --keyring /tmp/ceph.mon.keyring",
      "sudo -u ceph touch /var/lib/ceph/mon/ceph-aio/done",
      "systemctl start ceph-mon-aio"
    );
    $aio->waitForUnit("ceph-mon-aio");
    $aio->mustSucceed("ceph mon enable-msgr2");

    # Can't check ceph status until a mon is up
    $aio->succeed("ceph -s | grep 'mon: 1 daemons'");

    # Start the ceph-mgr daemon, it has no deps and hardly any setup
    $aio->mustSucceed(
      "ceph auth get-or-create mgr.aio mon 'allow profile mgr' osd 'allow *' mds 'allow *' > /var/lib/ceph/mgr/ceph-aio/keyring",
      "systemctl start ceph-mgr-aio"
    );
    $aio->waitForUnit("ceph-mgr-aio");
    $aio->waitUntilSucceeds("ceph -s | grep 'quorum aio'");
    $aio->waitUntilSucceeds("ceph -s | grep 'mgr: aio(active,'");

    # Bootstrap both OSDs
    $aio->mustSucceed(
      "mkfs.xfs /dev/vdb",
      "mkfs.xfs /dev/vdc",
      "mount /dev/vdb /var/lib/ceph/osd/ceph-0",
      "mount /dev/vdc /var/lib/ceph/osd/ceph-1",
      "ceph-authtool --create-keyring /var/lib/ceph/osd/ceph-0/keyring --name osd.0 --add-key AQBCEJNa3s8nHRAANvdsr93KqzBznuIWm2gOGg==",
      "ceph-authtool --create-keyring /var/lib/ceph/osd/ceph-1/keyring --name osd.1 --add-key AQBEEJNac00kExAAXEgy943BGyOpVH1LLlHafQ==",
      "echo '{\"cephx_secret\": \"AQBCEJNa3s8nHRAANvdsr93KqzBznuIWm2gOGg==\"}' | ceph osd new 55ba2294-3e24-478f-bee0-9dca4c231dd9 -i -",
      "echo '{\"cephx_secret\": \"AQBEEJNac00kExAAXEgy943BGyOpVH1LLlHafQ==\"}' | ceph osd new 5e97a838-85b6-43b0-8950-cb56d554d1e5 -i -"
    );

    # Initialize the OSDs with regular filestore
    $aio->mustSucceed(
      "ceph-osd -i 0 --mkfs --osd-uuid 55ba2294-3e24-478f-bee0-9dca4c231dd9",
      "ceph-osd -i 1 --mkfs --osd-uuid 5e97a838-85b6-43b0-8950-cb56d554d1e5",
      "chown -R ceph:ceph /var/lib/ceph/osd",
      "systemctl start ceph-osd-0",
      "systemctl start ceph-osd-1"
    );

    $aio->waitUntilSucceeds("ceph osd stat | grep -e '2 osds: 2 up[^,]*, 2 in'");
    $aio->waitUntilSucceeds("ceph -s | grep 'mgr: aio(active,'");
    $aio->waitUntilSucceeds("ceph -s | grep 'HEALTH_OK'");

    $aio->mustSucceed(
      "ceph osd pool create aio-test 100 100",
      "ceph osd pool ls | grep 'aio-test'",
      "ceph osd pool rename aio-test aio-other-test",
      "ceph osd pool ls | grep 'aio-other-test'",
      "ceph -s | grep '1 pools, 100 pgs'",
      "ceph osd getcrushmap -o crush",
      "crushtool -d crush -o decrushed",
      "sed 's/step chooseleaf firstn 0 type host/step chooseleaf firstn 0 type osd/' decrushed > modcrush",
      "crushtool -c modcrush -o recrushed",
      "ceph osd setcrushmap -i recrushed",
      "ceph osd pool set aio-other-test size 2"
    );
    $aio->waitUntilSucceeds("ceph -s | grep 'HEALTH_OK'");
    $aio->waitUntilSucceeds("ceph -s | grep '100 active+clean'");
    $aio->mustFail(
      "ceph osd pool ls | grep 'aio-test'",
      "ceph osd pool delete aio-other-test aio-other-test --yes-i-really-really-mean-it"
    );

    # As we disable the target in the config, we still want to test that it works as intended
    $aio->mustSucceed(
      "systemctl stop ceph-osd-0",
      "systemctl stop ceph-osd-1",
      "systemctl stop ceph-mgr-aio",
      "systemctl stop ceph-mon-aio"
    );
    $aio->succeed("systemctl start ceph.target");
    $aio->waitForUnit("ceph-mon-aio");
    $aio->waitForUnit("ceph-mgr-aio");
    $aio->waitForUnit("ceph-osd-0");
    $aio->waitForUnit("ceph-osd-1");
    $aio->succeed("ceph -s | grep 'mon: 1 daemons'");
    $aio->waitUntilSucceeds("ceph -s | grep 'quorum aio'");
    $aio->waitUntilSucceeds("ceph osd stat | grep -e '2 osds: 2 up[^,]*, 2 in'");
    $aio->waitUntilSucceeds("ceph -s | grep 'mgr: aio(active,'");
    $aio->waitUntilSucceeds("ceph -s | grep 'HEALTH_OK'");
  '';
})
