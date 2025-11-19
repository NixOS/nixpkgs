{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.tests.incus;

  # limit building of VMs to these systems as nested virtualization is
  # required to test VMs, but support for this is poor outside x86
  # will print warnings on those systems rather than failing outright
  vmsEnabled = lib.elem pkgs.stdenv.system [ "x86_64-linux" ];

  instanceScript = lib.pipe cfg.instances [
    (lib.filterAttrs (
      name: instance:
      let
        keep = instance.type != "virtual-machine" || vmsEnabled;
      in
      lib.warnIf (!keep) ''
        Skipping virtual-machine ${name} as VMs are disabled on ${pkgs.stdenv.system}
      '' keep
    ))
    (lib.foldlAttrs (
      acc: name: instance:
      acc + instance.testScript
    ) "")
  ];
in
{
  name = "${cfg.package.name}-${cfg.name}";

  meta = {
    maintainers = lib.teams.lxc.members;
  };

  nodes.server = {
    virtualisation = {
      cores = 2;
      memorySize = 4096;
      diskSize = 20 * 1024;
      emptyDiskImages = [
        # vdb for zfs
        2048
        # vdc for lvm
        2048
      ];

      incus = {
        enable = true;
        package = cfg.package;

        preseed = {
          networks = [
            {
              name = "incusbr0";
              type = "bridge";
              config = {
                "ipv4.address" = "10.0.10.1/24";
                "ipv4.nat" = "true";
              };
            }
          ]
          ++ lib.optionals cfg.network.ovs [
            {
              name = "ovsbr0";
              type = "bridge";
              config = {
                "bridge.driver" = "openvswitch";
                "ipv4.address" = "10.0.20.1/24";
                "ipv4.nat" = "true";
              };
            }
          ];
          profiles = [
            {
              name = "default";
              devices = {
                eth0 = {
                  name = "eth0";
                  network = "incusbr0";
                  type = "nic";
                };
                root = {
                  path = "/";
                  pool = "default";
                  size = "35GiB";
                  type = "disk";
                };
              };
            }
          ];
          storage_pools = [
            {
              name = "default";
              driver = "dir";
            }
          ];
        };
      };

      vswitch.enable = cfg.network.ovs;
    };

    boot.supportedFilesystems = { inherit (cfg.storage) zfs; };
    boot.zfs.forceImportRoot = false;

    environment.systemPackages = [ pkgs.parted ];

    networking.hostId = "01234567";
    networking.firewall.trustedInterfaces = [ "incusbr0" ];
    networking.nftables.enable = true;

    security.apparmor.enable = cfg.appArmor;
    services.dbus.apparmor = (if cfg.appArmor then "enabled" else "disabled");

    services.lvm = {
      boot.thin.enable = cfg.storage.lvm;
      dmeventd.enable = cfg.storage.lvm;
    };

    users.users.testuser = {
      isNormalUser = true;
      shell = pkgs.bashInteractive;
      group = "incus";
      uid = 1000;
    };
  };

  testScript =
    lib.readFile ./incus_machine.py
    +
      # python
      ''
        server = IncusHost(machine)
      ''
    +
      lib.optionalString cfg.network.ovs # python
        ''
          with subtest("Verify openvswitch bridge"):
              server.succeed("incus network info ovsbr0")


          with subtest("Verify openvswitch bridge"):
              server.succeed("ovs-vsctl br-exists ovsbr0")
        ''

    +
      lib.optionalString cfg.storage.zfs # python
        ''
          with subtest("Verify zfs pool created and usable"):
              server.succeed(
                  "zpool status",
                  "parted --script /dev/vdb mklabel gpt",
                  "zpool create zfs_pool /dev/vdb",
              )

              server.succeed("incus storage create zfs_pool zfs source=zfs_pool/incus")
              server.succeed("zfs list zfs_pool/incus")

              server.succeed("incus storage volume create zfs_pool test_fs --type filesystem")
              server.succeed("incus storage volume create zfs_pool test_vol --type block")

              server.succeed("incus storage show zfs_pool")
              server.succeed("incus storage volume list zfs_pool")
              server.succeed("incus storage volume show zfs_pool test_fs")
              server.succeed("incus storage volume show zfs_pool test_vol")

              server.succeed("incus create zfs1 --empty --storage zfs_pool")
              server.succeed("incus list zfs1")
        ''

    +
      lib.optionalString cfg.storage.lvm # python
        ''
          with subtest("Verify lvm pool created and usable"):
              server.succeed("incus storage create lvm_pool lvm source=/dev/vdc lvm.vg_name=incus_pool")
              server.succeed("vgs incus_pool")

              server.succeed("incus storage volume create lvm_pool test_fs --type filesystem")
              server.succeed("incus storage volume create lvm_pool test_vol --type block")

              server.succeed("incus storage show lvm_pool")

              server.succeed("incus storage volume list lvm_pool")
              server.succeed("incus storage volume show lvm_pool test_fs")
              server.succeed("incus storage volume show lvm_pool test_vol")

              server.succeed("incus create lvm1 --empty --storage lvm_pool")
              server.succeed("incus list lvm1")
        ''
    +
      lib.optionalString cfg.appArmor # python
        ''
          with subtest("Verify AppArmor service is started without issue"):
              # restart AppArmor service since the Incus AppArmor folders are
              # created after AA service is started
              server.systemctl("restart apparmor.service")
              server.succeed("systemctl --no-pager -l status apparmor.service")
              server.wait_for_unit("apparmor.service")
        ''
    +
      lib.optionalString cfg.feature.user # python
        ''
          with subtest("incus-user allows restricted access for users"):
              server.fail("incus project show user-1000")
              server.succeed("su - testuser bash -c 'incus list'")
              # a project is created dynamically for the user
              server.succeed("incus project show user-1000")
              # users shouldn't be able to list storage pools
              server.fail("su - testuser bash -c 'incus storage list'")
              # user can create an instance
              server.succeed("su - testuser bash -c 'incus create --empty'")
        ''
    + instanceScript;
}
