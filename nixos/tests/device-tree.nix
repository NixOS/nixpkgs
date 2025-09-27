{
  pkgs,
  runTestOn,
}:

let
  inherit (pkgs) lib;
  common = {
    virtualisation.useBootLoader = true;
    virtualisation.useEFIBoot = true;

    hardware.deviceTree = {
      dtbFile = lib.mkOverride 1490 (
        pkgs.runCommand "qemu-aarch64-virt.dtb" { } ''
          ${pkgs.qemu}/bin/qemu-system-aarch64 -cpu max -machine virt,gic-version=max,accel=kvm:tcg,dumpdtb=$out
        ''
      );

      overlays = [
        {
          name = "model";
          dtsText = ''
            /dts-v1/;
            /plugin/;

            / {
                compatible = "linux,dummy-virt";

                fragment@0 {
                    target-path = "/";
                    __overlay__ {
                        model = "test model";
                    };
                };
            };
          '';
        }
      ];
    };

    specialisation.something.configuration = {
      hardware.deviceTree.platform = "rockchip";
      hardware.deviceTree.dtsText = ''
        /dts-v1/;

        #include "rk3588.dtsi"

        / {
          model = "Test Model";
          compatible = "rockchip,rk3588";
        };

        &sdhci {
          status = "okay";
        };
      '';
    };
  };
in

{
  systemd-boot = runTestOn [ "aarch64-linux" ] {
    name = "systemd-boot-devicetree";
    meta.maintainers = with lib.maintainers; [
      qbisi
    ];

    nodes.machine =
      { pkgs, lib, ... }:
      {
        imports = [ common ];

        boot.loader.systemd-boot.enable = true;
      };

    testScript =
      { nodes, ... }:
      ''
        machine.start()
        machine.wait_for_unit("multi-user.target")

        machine.succeed("grep 'test model' /sys/firmware/devicetree/base/model")

        machine.succeed(r"grep 'devicetree /EFI/nixos/[a-z0-9]\{32\}.*fromtext' /boot/loader/entries/nixos-generation-1-specialisation-something.conf")
      '';
  };

  grub = runTestOn [ "aarch64-linux" ] {
    name = "grub-devicetree";
    meta.maintainers = with lib.maintainers; [
      qbisi
    ];

    nodes.machine =
      { pkgs, lib, ... }:
      {
        imports = [ common ];

        boot.loader.grub = {
          enable = true;
          device = "nodev";
          efiSupport = true;
          efiInstallAsRemovable = true;
        };
      };

    testScript =
      { nodes, ... }:
      ''
        machine.start()
        machine.wait_for_unit("multi-user.target")

        machine.succeed("grep 'test model' /sys/firmware/devicetree/base/model")

        machine.succeed(r"grep 'devicetree .*fromtext.dtb' /boot/grub/grub.cfg")
      '';
  };
}
