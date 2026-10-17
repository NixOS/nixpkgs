{
  system,
  pkgs,
  runTest,
}:

let
  inherit (pkgs) lib;

  makeZfsTest =
    {
      kernelPackages,
      enableSystemdStage1 ? false,
      zfsPackage,
      extraTest ? "",
    }:
    runTest {
      name = zfsPackage.kernelModuleAttribute;
      meta.maintainers = with lib.maintainers; [ elvishjerricco ];

      nodes.machine =
        {
          pkgs,
          lib,
          ...
        }:
        let
          usersharePath = "/var/lib/samba/usershares";
        in
        {
          virtualisation = {
            emptyDiskImages = [
              4096
              4096
            ];
            useBootLoader = true;
            useEFIBoot = true;
          };
          boot.loader.systemd-boot.enable = true;
          boot.loader.timeout = 0;
          boot.loader.efi.canTouchEfiVariables = true;
          networking.hostId = "deadbeef";
          boot.kernelPackages = kernelPackages;
          boot.zfs.package = zfsPackage;
          boot.supportedFilesystems = [ "zfs" ];
          boot.initrd.systemd.enable = enableSystemdStage1;

          environment.systemPackages = [ pkgs.parted ];

          # /dev/disk/by-id doesn't get populated in the NixOS test framework
          boot.zfs.devNodes = "/dev/disk/by-uuid";

          boot.zfs.forceImportRoot = lib.mkDefault false;

          specialisation.samba.configuration = {
            services.samba = {
              enable = true;
              settings.global = {
                "registry shares" = true;
                "usershare path" = "${usersharePath}";
                "usershare allow guests" = true;
                "usershare max shares" = "100";
                "usershare owner only" = false;
              };
            };
            systemd.services.samba-smbd.serviceConfig.ExecStartPre =
              "${pkgs.coreutils}/bin/mkdir -m +t -p ${usersharePath}";
            virtualisation.fileSystems = {
              "/tmp/mnt" = {
                device = "rpool/root";
                fsType = "zfs";
              };
            };
          };

          specialisation.encryption.configuration = {
            boot.zfs.requestEncryptionCredentials = [ "automatic" ];
            virtualisation.fileSystems."/automatic" = {
              device = "automatic";
              fsType = "zfs";
            };
            virtualisation.fileSystems."/manual" = {
              device = "manual";
              fsType = "zfs";
            };
            virtualisation.fileSystems."/manual/encrypted" = {
              device = "manual/encrypted";
              fsType = "zfs";
              options = [ "noauto" ];
            };
            virtualisation.fileSystems."/manual/httpkey" = {
              device = "manual/httpkey";
              fsType = "zfs";
              options = [ "noauto" ];
            };
          };

          specialisation.forcepool.configuration = {
            systemd.services.zfs-import-forcepool.wantedBy = lib.mkVMOverride [ "forcepool.mount" ];
            systemd.targets.zfs.wantedBy = lib.mkVMOverride [ ];
            boot.zfs.forceImportAll = true;
            boot.zfs.forceImportRoot = true;
            virtualisation.fileSystems."/forcepool" = {
              device = "forcepool";
              fsType = "zfs";
              options = [ "noauto" ];
            };
          };

          services.nginx = {
            enable = true;
            virtualHosts = {
              localhost = {
                locations = {
                  "/zfskey" = {
                    return = ''200 "httpkeyabc"'';
                  };
                };
              };
            };
          };
        };

      testScript =
        { nodes, ... }:
        let
          samba = nodes.machine.specialisation.samba.configuration.system.build.toplevel;
          encryption = nodes.machine.specialisation.encryption.configuration.system.build.toplevel;
          forcepool = nodes.machine.specialisation.forcepool.configuration.system.build.toplevel;
        in
        # python
        ''
          machine.wait_for_unit("multi-user.target")
          machine.succeed(
              "zpool status",
              "parted --script /dev/vdb mklabel msdos",
              "parted --script /dev/vdb -- mkpart primary 1024M -1s",
              "parted --script /dev/vdc mklabel msdos",
              "parted --script /dev/vdc -- mkpart primary 1024M -1s",
          )

          with subtest("sharesmb works"):
              machine.succeed(
                  "zpool create rpool /dev/vdb1",
                  "zfs create -o mountpoint=legacy rpool/root",
                  # shared datasets cannot have legacy mountpoint
                  "zfs create rpool/shared_smb",
                  "${samba}/bin/switch-to-configuration boot",
                  "sync",
              )
              machine.crash()
              machine.wait_for_unit("multi-user.target")
              machine.succeed("zfs set sharesmb=on rpool/shared_smb")
              machine.succeed(
                  "smbclient -gNL localhost | grep rpool_shared_smb",
                  "umount /tmp/mnt",
                  "zpool destroy rpool",
              )

          with subtest("encryption works"):
              machine.succeed(
                  'echo password | zpool create -O mountpoint=legacy '
                  + "-O encryption=aes-256-gcm -O keyformat=passphrase automatic /dev/vdb1",
                  "zpool create -O mountpoint=legacy manual /dev/vdc1",
                  "echo otherpass | zfs create "
                  + "-o encryption=aes-256-gcm -o keyformat=passphrase manual/encrypted",
                  "zfs create -o encryption=aes-256-gcm -o keyformat=passphrase "
                  + "-o keylocation=http://localhost/zfskey manual/httpkey",
                  "${encryption}/bin/switch-to-configuration boot",
                  "sync",
                  "zpool export automatic",
                  "zpool export manual",
              )
              machine.crash()
              machine.start()
              machine.wait_for_console_text("Starting password query on")
              machine.send_console("password\n")
              machine.wait_for_unit("multi-user.target")
              machine.succeed(
                  "zfs get -Ho value keystatus manual/encrypted | grep -Fx unavailable",
                  "echo otherpass | zfs load-key manual/encrypted",
                  "systemctl start manual-encrypted.mount",
                  "zfs load-key manual/httpkey",
                  "systemctl start manual-httpkey.mount",
                  "umount /automatic /manual/encrypted /manual/httpkey /manual",
                  "zpool destroy automatic",
                  "zpool destroy manual",
              )

          with subtest("boot.zfs.forceImportAll works"):
              machine.succeed(
                  "rm /etc/hostid",
                  "zgenhostid deadcafe",
                  "zpool create forcepool /dev/vdb1 -O mountpoint=legacy",
                  "${forcepool}/bin/switch-to-configuration boot",
                  "rm /etc/hostid",
                  "sync",
              )
              machine.crash()
              machine.wait_for_unit("multi-user.target")
              machine.fail("zpool import forcepool")
              machine.succeed(
                  "systemctl start forcepool.mount",
                  "mount | grep forcepool",
              )
        ''
        + extraTest;

    };

in
{
  series_2_3 = makeZfsTest {
    zfsPackage = pkgs.zfs_2_3;
    kernelPackages = pkgs.linuxPackages;
  };

  series_2_4 = makeZfsTest {
    zfsPackage = pkgs.zfs_2_4;
    kernelPackages = pkgs.linuxPackages;
  };

  unstable = makeZfsTest {
    zfsPackage = pkgs.zfs_unstable;
    kernelPackages = pkgs.linuxPackages;
  };

  unstableWithSystemdStage1 = makeZfsTest {
    zfsPackage = pkgs.zfs_unstable;
    kernelPackages = pkgs.linuxPackages;
    enableSystemdStage1 = true;
  };

  installerBoot =
    (import ./installer.nix {
      inherit system;
      systemdStage1 = false;
    }).separateBootZfs;

  installer =
    (import ./installer.nix {
      inherit system;
      systemdStage1 = false;
    }).zfsroot;

  installerBootWithSystemdStage1 =
    (import ./installer.nix {
      inherit system;
      systemdStage1 = true;
    }).separateBootZfs;

  installerWithSystemdStage1 =
    (import ./installer.nix {
      inherit system;
      systemdStage1 = true;
    }).zfsroot;

  expand-partitions = runTest {
    name = "multi-disk-zfs";
    nodes = {
      machine =
        { pkgs, ... }:
        {
          environment.systemPackages = [ pkgs.parted ];
          boot.supportedFilesystems = [ "zfs" ];
          networking.hostId = "00000000";

          virtualisation = {
            emptyDiskImages = [
              20480
              20480
              20480
              20480
              20480
              20480
            ];
          };

          specialisation.resize.configuration = {
            services.zfs.expandOnBoot = [ "tank" ];
          };
        };
    };

    testScript =
      { nodes, ... }:
      ''
        start_all()
        machine.wait_for_unit("default.target")
        print(machine.succeed('mount'))

        print(machine.succeed('parted --script /dev/vdb -- mklabel gpt'))
        print(machine.succeed('parted --script /dev/vdb -- mkpart primary 1M 70M'))

        print(machine.succeed('parted --script /dev/vdc -- mklabel gpt'))
        print(machine.succeed('parted --script /dev/vdc -- mkpart primary 1M 70M'))

        print(machine.succeed('zpool create tank mirror /dev/vdb1 /dev/vdc1 mirror /dev/vdd /dev/vde mirror /dev/vdf /dev/vdg'))
        print(machine.succeed('zpool list -v'))
        print(machine.succeed('mount'))
        start_size = int(machine.succeed('df -k --output=size /tank | tail -n1').strip())

        print(machine.succeed("/run/current-system/specialisation/resize/bin/switch-to-configuration test >&2"))
        machine.wait_for_unit("zpool-expand-pools.service")
        machine.wait_for_unit("zpool-expand@tank.service")

        print(machine.succeed('zpool list -v'))
        new_size = int(machine.succeed('df -k --output=size /tank | tail -n1').strip())

        if (new_size - start_size) > 20000000:
          print("Disk grew appropriately.")
        else:
          print(f"Disk went from {start_size} to {new_size}, which doesn't seem right.")
          exit(1)
      '';
  };

  zfs-mount-generator = runTest {
    name = "zfs-mount-generator";
    nodes.machine =
      { ... }:
      {
        boot.supportedFilesystems = [ "zfs" ];
        networking.hostId = "00000000";
        virtualisation = {
          emptyDiskImages = [ 4096 ];
        };
      };

    testScript = ''
      from datetime import timedelta

      machine.wait_for_unit("multi-user.target")

      machine.succeed(
          "zpool create -O mountpoint=none test /dev/vdb",

          # Enable list caching for the test pool.
          "mkdir /etc/zfs/zfs-list.cache",
          "touch /etc/zfs/zfs-list.cache/test",

          # Trigger the zedlet.
          "zfs create -o mountpoint=/tmp/foo test/foo",
      )

      # Wait for the zedlet to update the cache with the new dataset.
      machine.wait_until_succeeds(
          "grep -F test/foo /etc/zfs/zfs-list.cache/test",
          timeout=timedelta(seconds=120)
      )

      machine.succeed(
          # Rerun systemd generators.
          "systemctl daemon-reload",
          "systemctl cat tmp-foo.mount | grep zfs-mount-generator",
          "systemctl is-active tmp-foo.mount",
      )
    '';
  };

  # ZED brings a physically returned mirror drive back online and
  # triggers a resilver.
  auto-online = runTest {
    name = "zfs-auto-online";
    meta.maintainers = with lib.maintainers; [
      tomfitzhenry
    ];

    nodes.hotplug =
      { ... }:
      {
        boot.supportedFilesystems = [ "zfs" ];
        boot.zfs.forceImportRoot = false;
        networking.hostId = "deadbeef";
        virtualisation.qemu.options = [
          "-device"
          "virtio-scsi-pci,id=scsi0"
        ];
      };

    testScript =
      { ... }:
      ''
        from datetime import timedelta

        hotplug.wait_for_unit("multi-user.target", timeout=timedelta(minutes=5))

        DISK_BYTES = 2048 * 1024 * 1024
        # Backend/device id -> explicit SCSI serial. The serial is what udev
        # turns into the persistent /dev/disk/by-id link that ZED matches.
        SERIALS = {"diskA": "ZA", "diskB": "ZB"}

        def by_id(name):
            return f"/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_{SERIALS[name]}"

        def attach(name):
            img = hotplug.state_dir / f"{name}.img"
            if not img.exists():
                with open(img, "wb") as f:
                    f.truncate(DISK_BYTES)
            # QEMU keeps the if=none backend across device_del, so a repeated
            # drive_add reports a duplicate id, which is harmless.
            out = hotplug.send_monitor_command(
                f"drive_add 0 id={name},if=none,file={img},format=raw"
            )
            assert "Error" not in out or "Duplicate ID" in out, out
            out = hotplug.send_monitor_command(
                f"device_add scsi-hd,id={name},drive={name},bus=scsi0.0,serial={SERIALS[name]}"
            )
            assert "Error" not in out, out
            hotplug.wait_until_succeeds(
                f"test -e {by_id(name)}", timeout=timedelta(seconds=120)
            )
            return by_id(name)

        def unplug(name):
            out = hotplug.send_monitor_command(f"device_del {name}")
            assert "Error" not in out, out
            hotplug.wait_until_fails(
                f"test -e {by_id(name)}", timeout=timedelta(seconds=120)
            )

        with subtest("ZED auto-onlines a physically returned mirror leg"):
            a, b = attach("diskA"), attach("diskB")

            hotplug.succeed(
                f"zpool create -f -O primarycache=none tank mirror {a} {b}",
                timeout=timedelta(seconds=120),
            )
            hotplug.succeed(
                "zfs create -o primarycache=none tank/data",
                timeout=timedelta(seconds=60),
            )
            # primarycache=none is set before any test file is written, so the
            # read can never be served from the ARC.
            cache = hotplug.succeed(
                "zfs get -H -o value primarycache tank/data",
                timeout=timedelta(seconds=60),
            ).strip()
            print("tank/data primarycache =", cache)
            assert cache == "none", cache

            # A control file present on both legs, checksummed now. foo's
            # expected hash is recorded once leg A is gone.
            hotplug.succeed(
                "printf pre > /tank/data/pre; sync; sha256sum /tank/data/pre > /tmp/pre.sha",
                timeout=timedelta(seconds=120),
            )

            unplug("diskA")
            hotplug.wait_until_succeeds(
                "zpool list -H -o health tank | grep -qx DEGRADED",
                timeout=timedelta(seconds=120),
            )
            # foo is written while the pool is degraded, so only the
            # surviving leg B can receive it.
            hotplug.succeed(
                "printf foo > /tank/data/foo; sync; sha256sum /tank/data/foo > /tmp/foo.sha",
                timeout=timedelta(seconds=120),
            )

            attach("diskA")
            hotplug.wait_until_succeeds(
                "zpool status tank | grep -q 'resilvered.*with 0 errors'",
                timeout=timedelta(seconds=240),
            )
            hotplug.wait_until_succeeds(
                "zpool status -x | grep -qx 'all pools are healthy'",
                timeout=timedelta(seconds=120),
            )

            # Pull B, the leg that certainly holds foo, and drop the page
            # cache so the read must come from a vdev. Over a 2-disk mirror
            # this can only work if ZED resilvered A; otherwise A is stale
            # and B is gone.
            unplug("diskB")
            hotplug.succeed(
                "sync; echo 3 > /proc/sys/vm/drop_caches",
                timeout=timedelta(seconds=120),
            )

            readback = hotplug.succeed(
                "timeout 60 cat /tank/data/foo",
                timeout=timedelta(seconds=90),
            ).strip()
            print("read back /tank/data/foo with leg B pulled:", readback)
            assert readback == "foo", readback
            hotplug.succeed(
                "timeout 60 sha256sum -c /tmp/foo.sha",
                timeout=timedelta(seconds=90),
            )
            hotplug.succeed(
                "timeout 60 sha256sum -c /tmp/pre.sha",
                timeout=timedelta(seconds=90),
            )

            # Reinsert B and let ZED heal the mirror again.
            attach("diskB")
            hotplug.wait_until_succeeds(
                "zpool status -x | grep -qx 'all pools are healthy'",
                timeout=timedelta(seconds=240),
            )
      '';
  };
}
