{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../.. { inherit system config; },
}:

with import ../lib/testing-python.nix { inherit system pkgs; };

let

  makeZfsTest =
    {
      kernelPackages,
      enableSystemdStage1 ? false,
      zfsPackage,
      extraTest ? "",
    }:
    makeTest {
      name = zfsPackage.kernelModuleAttribute;
      meta = with pkgs.lib.maintainers; {
        maintainers = [ elvishjerricco ];
      };

      nodes.machine =
        {
          config,
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

          specialisation.samba.configuration = {
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
            systemd.services.samba-smbd.serviceConfig.ExecStartPre = "${pkgs.coreutils}/bin/mkdir -m +t -p ${usersharePath}";
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
                  "bootctl set-default nixos-generation-1-specialisation-samba.conf",
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
                  "bootctl set-default nixos-generation-1-specialisation-encryption.conf",
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
                  "bootctl set-default nixos-generation-1-specialisation-forcepool.conf",
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

  # maintainer: @raitobezarius
  series_2_1 = makeZfsTest {
    zfsPackage = pkgs.zfs_2_1;
    kernelPackages = pkgs.linuxPackages;
  };

  series_2_2 = makeZfsTest {
    zfsPackage = pkgs.zfs_2_2;
    kernelPackages = pkgs.linuxPackages;
  };

  unstable = makeZfsTest rec {
    zfsPackage = pkgs.zfs_unstable;
    kernelPackages = zfsPackage.latestCompatibleLinuxPackages;
  };

  unstableWithSystemdStage1 = makeZfsTest rec {
    zfsPackage = pkgs.zfs_unstable;
    kernelPackages = zfsPackage.latestCompatibleLinuxPackages;
    enableSystemdStage1 = true;
  };

  installerBoot = (import ./installer.nix { }).separateBootZfs;
  installer = (import ./installer.nix { }).zfsroot;

  expand-partitions = makeTest {
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
}
