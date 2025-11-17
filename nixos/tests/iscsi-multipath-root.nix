{ pkgs, lib, ... }:
let
  initiatorName = "iqn.2020-08.org.linux-iscsi.initiatorhost:example";
  targetName = "iqn.2003-01.org.linux-iscsi.target.x8664:sn.acf8fd9c23af";
in
{
  name = "iscsi";
  meta = {
    maintainers = pkgs.lib.teams.deshaw.members;
  };

  nodes = {
    target =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      {
        virtualisation.vlans = [
          1
          2
        ];
        services.target = {
          enable = true;
          config = {
            fabric_modules = [ ];
            storage_objects = [
              {
                dev = "/dev/vdb";
                name = "test";
                plugin = "block";
                write_back = true;
                wwn = "92b17c3f-6b40-4168-b082-ceeb7b495522";
              }
            ];
            targets = [
              {
                fabric = "iscsi";
                tpgs = [
                  {
                    enable = true;
                    attributes = {
                      authentication = 0;
                      generate_node_acls = 1;
                    };
                    luns = [
                      {
                        alias = "94dfe06967";
                        alua_tg_pt_gp_name = "default_tg_pt_gp";
                        index = 0;
                        storage_object = "/backstores/block/test";
                      }
                    ];
                    node_acls = [
                      {
                        mapped_luns = [
                          {
                            alias = "d42f5bdf8a";
                            index = 0;
                            tpg_lun = 0;
                            write_protect = false;
                          }
                        ];
                        node_wwn = initiatorName;
                      }
                    ];
                    portals = [
                      {
                        ip_address = "0.0.0.0";
                        iser = false;
                        offload = false;
                        port = 3260;
                      }
                    ];
                    tag = 1;
                  }
                ];
                wwn = targetName;
              }
            ];
          };
        };

        networking.firewall.allowedTCPPorts = [ 3260 ];
        networking.firewall.allowedUDPPorts = [ 3260 ];

        virtualisation.memorySize = 2048;
        virtualisation.emptyDiskImages = [ 2048 ];
      };

    initiatorAuto =
      {
        nodes,
        config,
        pkgs,
        ...
      }:
      {
        virtualisation.vlans = [
          1
          2
        ];

        services.multipath = {
          enable = true;
          defaults = ''
            find_multipaths yes
            user_friendly_names yes
          '';
          pathGroups = [
            {
              alias = 123456;
              wwid = "3600140592b17c3f6b404168b082ceeb7";
            }
          ];
        };

        services.openiscsi = {
          enable = true;
          enableAutoLoginOut = true;
          discoverPortal = "target";
          name = initiatorName;
        };

        environment.systemPackages = with pkgs; [
          xfsprogs
        ];

        environment.etc."initiator-root-disk-closure".source =
          nodes.initiatorRootDisk.config.system.build.toplevel;

        nix.settings = {
          substituters = lib.mkForce [ ];
          hashed-mirrors = null;
          connect-timeout = 1;
        };
      };

    initiatorRootDisk =
      {
        config,
        pkgs,
        modulesPath,
        lib,
        ...
      }:
      {
        boot.initrd.network.enable = true;
        boot.loader.grub.enable = false;

        boot.kernelParams = lib.mkOverride 5 [
          "boot.shell_on_fail"
          "console=tty1"
          "ip=192.168.1.1:::255.255.255.0::ens9:none"
          "ip=192.168.2.1:::255.255.255.0::ens10:none"
        ];

        # defaults to true, puts some code in the initrd that tries to mount an overlayfs on /nix/store
        virtualisation.writableStore = false;
        virtualisation.vlans = [
          1
          2
        ];

        services.multipath = {
          enable = true;
          defaults = ''
            find_multipaths yes
            user_friendly_names yes
          '';
          pathGroups = [
            {
              alias = 123456;
              wwid = "3600140592b17c3f6b404168b082ceeb7";
            }
          ];
        };

        fileSystems = lib.mkOverride 5 {
          "/" = {
            fsType = "xfs";
            device = "/dev/mapper/123456";
            options = [ "_netdev" ];
          };
        };

        boot.initrd.extraFiles."etc/multipath/wwids".source =
          pkgs.writeText "wwids" "/3600140592b17c3f6b404168b082ceeb7/";

        boot.iscsi-initiator = {
          discoverPortal = "target";
          name = initiatorName;
          target = targetName;
          extraIscsiCommands = ''
            iscsiadm -m discovery -o update -t sendtargets -p 192.168.2.3 --login
          '';
        };
      };

  };

  testScript =
    { nodes, ... }:
    ''
      target.start()
      target.wait_for_unit("iscsi-target.service")

      initiatorAuto.start()

      initiatorAuto.wait_for_unit("iscsid.service")
      initiatorAuto.wait_for_unit("iscsi.service")
      initiatorAuto.get_unit_info("iscsi")

      # Expecting this to fail since we should already know about 192.168.1.3
      initiatorAuto.fail("iscsiadm -m discovery -o update -t sendtargets -p 192.168.1.3 --login")
      # Expecting this to succeed since we don't yet know about 192.168.2.3
      initiatorAuto.succeed("iscsiadm -m discovery -o update -t sendtargets -p 192.168.2.3 --login")

      # /dev/sda is provided by iscsi on target
      initiatorAuto.succeed("set -x; while ! test -e /dev/sda; do sleep 1; done")

      initiatorAuto.succeed("mkfs.xfs /dev/sda")
      initiatorAuto.succeed("mkdir /mnt")

      # Start by verifying /dev/sda and /dev/sdb are both the same disk
      initiatorAuto.succeed("mount /dev/sda /mnt")
      initiatorAuto.succeed("touch /mnt/hi")
      initiatorAuto.succeed("umount /mnt")

      initiatorAuto.succeed("mount /dev/sdb /mnt")
      initiatorAuto.succeed("test -e /mnt/hi")
      initiatorAuto.succeed("umount /mnt")

      initiatorAuto.succeed("systemctl restart multipathd")
      initiatorAuto.succeed("systemd-cat multipath -ll")

      # Install our RootDisk machine to 123456, the alias to the device that multipath is now managing
      initiatorAuto.succeed("mount /dev/mapper/123456 /mnt")
      initiatorAuto.succeed("mkdir -p /mnt/etc/{multipath,iscsi}")
      initiatorAuto.succeed("cp -r /etc/multipath/wwids /mnt/etc/multipath/wwids")
      initiatorAuto.succeed("cp -r /etc/iscsi/{nodes,send_targets} /mnt/etc/iscsi")
      initiatorAuto.succeed(
        "nixos-install --no-bootloader --no-root-passwd --system /etc/initiator-root-disk-closure"
      )
      initiatorAuto.succeed("umount /mnt")
      initiatorAuto.shutdown()

      initiatorRootDisk.start()
      initiatorRootDisk.wait_for_unit("multi-user.target")
      initiatorRootDisk.wait_for_unit("iscsid")

      # Log in over both nodes
      initiatorRootDisk.fail("iscsiadm -m discovery -o update -t sendtargets -p 192.168.1.3 --login")
      initiatorRootDisk.fail("iscsiadm -m discovery -o update -t sendtargets -p 192.168.2.3 --login")
      initiatorRootDisk.succeed("systemctl restart multipathd")
      initiatorRootDisk.succeed("systemd-cat multipath -ll")

      # Verify we can write and sync the root disk
      initiatorRootDisk.succeed("mkdir /scratch")
      initiatorRootDisk.succeed("touch /scratch/both-up")
      initiatorRootDisk.succeed("sync /scratch")

      # Verify we can write to the root with ens9 (sda, 192.168.1.3) down
      initiatorRootDisk.succeed("ip link set ens9 down")
      initiatorRootDisk.succeed("touch /scratch/ens9-down")
      initiatorRootDisk.succeed("sync /scratch")
      initiatorRootDisk.succeed("ip link set ens9 up")

      # todo: better way to wait until multipath notices the link is back
      initiatorRootDisk.succeed("sleep 5")
      initiatorRootDisk.succeed("touch /scratch/both-down")
      initiatorRootDisk.succeed("sync /scratch")

      # Verify we can write to the root with ens10 (sdb, 192.168.2.3) down
      initiatorRootDisk.succeed("ip link set ens10 down")
      initiatorRootDisk.succeed("touch /scratch/ens10-down")
      initiatorRootDisk.succeed("sync /scratch")
      initiatorRootDisk.succeed("ip link set ens10 up")
      initiatorRootDisk.succeed("touch /scratch/ens10-down")
      initiatorRootDisk.succeed("sync /scratch")

      initiatorRootDisk.succeed("ip link set ens9 up")
      initiatorRootDisk.succeed("ip link set ens10 up")
      initiatorRootDisk.shutdown()

      # Verify we can boot with the target's eth1 down, forcing
      # it to multipath via the second link
      target.succeed("ip link set eth1 down")
      initiatorRootDisk.start()
      initiatorRootDisk.wait_for_unit("multi-user.target")
      initiatorRootDisk.wait_for_unit("iscsid")
      initiatorRootDisk.succeed("test -e /scratch/both-up")
    '';
}
