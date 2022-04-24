{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };

let

  makeZfsTest = name:
    { kernelPackage ? if enableUnstable then pkgs.linuxPackages_latest else pkgs.linuxPackages
    , enableUnstable ? false
    , extraTest ? ""
    }:
    makeTest {
      name = "zfs-" + name;
      meta = with pkgs.lib.maintainers; {
        maintainers = [ adisbladis ];
      };

      nodes.machine = { pkgs, lib, ... }:
        let
          usersharePath = "/var/lib/samba/usershares";
        in {
        virtualisation.emptyDiskImages = [ 4096 ];
        networking.hostId = "deadbeef";
        boot.kernelPackages = kernelPackage;
        boot.supportedFilesystems = [ "zfs" ];
        boot.zfs.enableUnstable = enableUnstable;

        services.samba = {
          enable = true;
          extraConfig = ''
            registry shares = yes
            usershare path = ${usersharePath}
            usershare allow guests = yes
            usershare max shares = 100
            usershare owner only = no
          '';
        };
        systemd.services.samba-smbd.serviceConfig.ExecStartPre =
          "${pkgs.coreutils}/bin/mkdir -m +t -p ${usersharePath}";

        environment.systemPackages = [ pkgs.parted ];

        # Setup regular fileSystems machinery to ensure forceImportAll can be
        # tested via the regular service units.
        virtualisation.fileSystems = {
          "/forcepool" = {
            device = "forcepool";
            fsType = "zfs";
            options = [ "noauto" ];
          };
        };

        # forcepool doesn't exist at first boot, and we need to manually test
        # the import after tweaking the hostId.
        systemd.services.zfs-import-forcepool.wantedBy = lib.mkVMOverride [];
        systemd.targets.zfs.wantedBy = lib.mkVMOverride [];
        boot.zfs.forceImportAll = true;
        # /dev/disk/by-id doesn't get populated in the NixOS test framework
        boot.zfs.devNodes = "/dev/disk/by-uuid";
      };

      testScript = ''
        machine.succeed(
            "modprobe zfs",
            "zpool status",
            "ls /dev",
            "mkdir /tmp/mnt",
            "udevadm settle",
            "parted --script /dev/vdb mklabel msdos",
            "parted --script /dev/vdb -- mkpart primary 1024M -1s",
            "udevadm settle",
            "zpool create rpool /dev/vdb1",
            "zfs create -o mountpoint=legacy rpool/root",
            # shared datasets cannot have legacy mountpoint
            "zfs create rpool/shared_smb",
            "mount -t zfs rpool/root /tmp/mnt",
            "udevadm settle",
            # wait for samba services
            "systemctl is-system-running --wait",
            "zfs set sharesmb=on rpool/shared_smb",
            "zfs share rpool/shared_smb",
            "smbclient -gNL localhost | grep rpool_shared_smb",
            "umount /tmp/mnt",
            "zpool destroy rpool",
            "udevadm settle",
        )

        machine.succeed(
            'echo password | zpool create -o altroot="/tmp/mnt" '
            + "-O encryption=aes-256-gcm -O keyformat=passphrase rpool /dev/vdb1",
            "zfs create -o mountpoint=legacy rpool/root",
            "mount -t zfs rpool/root /tmp/mnt",
            "udevadm settle",
            "umount /tmp/mnt",
            "zpool destroy rpool",
            "udevadm settle",
        )

        with subtest("boot.zfs.forceImportAll works"):
            machine.succeed(
                "rm /etc/hostid",
                "zgenhostid deadcafe",
                "zpool create forcepool /dev/vdb1 -O mountpoint=legacy",
            )
            machine.shutdown()
            machine.start()
            machine.succeed("udevadm settle")
            machine.fail("zpool import forcepool")
            machine.succeed(
                "systemctl start zfs-import-forcepool.service",
                "mount -t zfs forcepool /tmp/mnt",
            )
      '' + extraTest;

    };


in {

  stable = makeZfsTest "stable" { };

  unstable = makeZfsTest "unstable" {
    enableUnstable = true;
  };

  installer = (import ./installer.nix { }).zfsroot;

  expand-partitions = makeTest {
    name = "multi-disk-zfs";
    nodes = {
      machine = { pkgs, ... }: {
        environment.systemPackages = [ pkgs.parted ];
        boot.supportedFilesystems = [ "zfs" ];
        networking.hostId = "00000000";

        virtualisation = {
          emptyDiskImages = [ 20480 20480 20480 20480 20480 20480 ];
        };

        specialisation.resize.configuration = {
          services.zfs.expandOnBoot = [ "tank" ];
        };
      };
    };

    testScript = { nodes, ... }:
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
}
