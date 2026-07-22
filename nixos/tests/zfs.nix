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

          specialisation.noautoencryption.configuration = {
            # Import an extra (non-root) pool via ZFS-native logic. Its key
            # loading is handled by the zfs-import-<pool> service, which must
            # skip datasets marked canmount=off/noauto.
            boot.zfs.extraPools = [ "noautotank" ];
            boot.zfs.requestEncryptionCredentials = true;
            # If a passphrase is ever requested during boot (i.e. the fix
            # regressed), fail fast instead of hanging forever.
            boot.zfs.passwordTimeout = 10;
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
          noautoencryption =
            nodes.machine.specialisation.noautoencryption.configuration.system.build.toplevel;
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

          with subtest("encrypted canmount=noauto/off datasets are left alone at boot"):
              # An extra (non-root) pool with a plain auto-mounted dataset and
              # two encrypted datasets that should not be mounted at boot: one
              # canmount=noauto, one canmount=off. Their passphrases are only
              # available via an interactive prompt (keylocation=prompt).
              #
              # Without the fix, the zfs-import-<pool> service would run
              # `systemd-ask-password` for these datasets during boot, blocking
              # on a passphrase that never comes; after passwordTimeout (set to
              # 10s here) it retries and ultimately the service *fails*. With the
              # fix it skips both datasets, so the import service succeeds and no
              # prompt is ever shown.
              machine.succeed(
                  "zpool create -O mountpoint=none noautotank /dev/vdc1",
                  "zfs create -o mountpoint=/plain noautotank/plain",
                  "echo pass-for-noauto | zfs create -o encryption=aes-256-gcm "
                  + "-o keyformat=passphrase -o canmount=noauto "
                  + "-o mountpoint=/secret noautotank/secret-noauto",
                  "echo pass-for-off | zfs create -o encryption=aes-256-gcm "
                  + "-o keyformat=passphrase -o canmount=off noautotank/secret-off",
                  "${noautoencryption}/bin/switch-to-configuration boot",
                  "sync",
                  "zpool export noautotank",
              )
              machine.crash()
              # The import service must succeed (i.e. not have gotten stuck on /
              # failed a passphrase prompt for the noauto/off datasets). This
              # is the assertion that regresses without the fix.
              machine.wait_for_unit("zfs-import-noautotank.service")
              machine.wait_for_unit("multi-user.target")
              # It must never have asked for either dataset's key.
              machine.fail(
                  "journalctl -u zfs-import-noautotank.service | grep -F 'Enter key for noautotank/secret-noauto'",
                  "journalctl -u zfs-import-noautotank.service | grep -F 'Enter key for noautotank/secret-off'",
              )
              # Pool imported, plain dataset auto-mounted.
              machine.succeed(
                  "zpool status noautotank",
                  "mount | grep -F ' on /plain '",
              )
              # The encrypted noauto/off datasets must be untouched: key not
              # loaded, not mounted.
              machine.succeed(
                  "zfs get -Ho value keystatus noautotank/secret-noauto | grep -Fx unavailable",
                  "zfs get -Ho value mounted noautotank/secret-noauto | grep -Fx no",
                  "zfs get -Ho value keystatus noautotank/secret-off | grep -Fx unavailable",
              )
              # The noauto dataset is still usable on demand.
              machine.succeed(
                  "echo pass-for-noauto | zfs load-key noautotank/secret-noauto",
                  "zfs mount noautotank/secret-noauto",
                  "mount | grep -F ' on /secret '",
                  "umount /plain /secret",
                  "zpool destroy noautotank",
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
}
