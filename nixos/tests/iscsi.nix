import ./make-test-python.nix ({ pkgs, lib, ... }:
let
  initiatorName = "iqn.2020-08.org.linux-iscsi.initiatorhost:example";
  targetName = "iqn.2003-01.org.linux-iscsi.target.x8664:sn.acf8fd9c23af";

  initiatorRootConfig = { config, pkgs, modulesPath, lib, ... }: {
    imports = [
      ../modules/testing/test-instrumentation.nix
      ../modules/virtualisation/qemu-vm.nix
    ];

    boot.loader.grub.enable = false;
    boot.kernelParams = lib.mkOverride 5 ([
      "boot.shell_on_fail"
      "console=tty1"
    ] ++ lib.optional (config.networking ? "primaryIPAddress") "ip=${config.networking.primaryIPAddress}:::255.255.255.0::ens9:none");
    # extremely useful for debugging
    # virtualisation.qemu.consoles = lib.mkForce [ "tty1" ];
    # defaults to true, puts some code in the initrd that tries to mount an overlayfs on /nix/store
    virtualisation.writableStore = false;

    fileSystems = lib.mkOverride 5 {
      "/" = {
        fsType = "xfs";
        device = "/dev/sda";
      };
    };

    services.openiscsi = {
      enable = true;
      name = initiatorName;
    };

    boot.iscsi-initiator = {
      discoverPortal = "target";
      name = initiatorName;
      target = targetName;
    };
  };

  initiatorRootSystem = (pkgs.nixos initiatorRootConfig).config.system.build.toplevel;
in {
  name = "iscsi";
  skipLint = true;

  nodes = {
    target = { config, pkgs, lib, ... }: {
      services.target = {
        enable = true;
        config = {
          fabric_modules = [ ];
          storage_objects = [{
            dev = "/dev/vdb";
            name = "test";
            plugin = "block";
            write_back = true;
            wwn = "92b17c3f-6b40-4168-b082-ceeb7b495522";
          }];
          targets = [{
            fabric = "iscsi";
            tpgs = [{
              enable = true;
              attributes = {
                authentication = 0;
                generate_node_acls = 1;
              };
              luns = [{
                alias = "94dfe06967";
                alua_tg_pt_gp_name = "default_tg_pt_gp";
                index = 0;
                storage_object = "/backstores/block/test";
              }];
              node_acls = [{
                mapped_luns = [{
                  alias = "d42f5bdf8a";
                  index = 0;
                  tpg_lun = 0;
                  write_protect = false;
                }];
                node_wwn = initiatorName;
              }];
              portals = [{
                ip_address = "0.0.0.0";
                iser = false;
                offload = false;
                port = 3260;
              }];
              tag = 1;
            }];
            wwn = targetName;
          }];
        };
      };

      networking.firewall.allowedTCPPorts = [ 3260 ];
      networking.firewall.allowedUDPPorts = [ 3260 ];

      virtualisation.memorySize = 2048;
      virtualisation.emptyDiskImages = [ 2048 ];

      system.extraDependencies = [ initiatorRootSystem ];

      nix.binaryCaches = lib.mkForce [ ];
      nix.extraOptions = ''
        hashed-mirrors =
        connect-timeout = 1
      '';
    };

    initiatorAuto = { config, pkgs, ... }: {
      services.openiscsi = {
        enable = true;
        enableAutoLoginOut = true;
        discoverPortal = "target";
        name = initiatorName;
      };

      environment.systemPackages = with pkgs; [
        xfsprogs
      ];
    };

    initiatorRootTargetName = initiatorRootConfig;
  };

  testScript = ''
    target.start()
    initiatorAuto.start()
    target.wait_for_unit("iscsi-target.service")

    initiatorAuto.wait_for_unit("iscsid.service")
    initiatorAuto.wait_for_unit("iscsi.service")
    initiatorAuto.get_unit_info("iscsi")

    initiatorAuto.succeed("mkfs.xfs /dev/sda")
    initiatorAuto.shutdown()
    target.stop_job("iscsi-target")
    target.succeed("mkdir /mnt; mount /dev/vdb /mnt")

    target.succeed('nixos-install --no-bootloader --no-root-passwd --system ${initiatorRootSystem}')
    target.succeed("umount /mnt; rmdir /mnt")
    target.start_job("iscsi-target")

    initiatorRootTargetName.start()
    initiatorRootTargetName.wait_for_unit("multi-user.target")
    initiatorRootTargetName.wait_for_unit("iscsid")
    initiatorRootTargetName.succeed("touch test")
  '';
})
