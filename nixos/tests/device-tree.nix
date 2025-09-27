{
  pkgs,
  runTestOn,
}:

let
  supportedSystems = [
    "aarch64-linux"
  ];
  common =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (pkgs.stdenv.hostPlatform) qemuArch;
    in
    {
      virtualisation.useBootLoader = true;
      virtualisation.useEFIBoot = true;

      hardware.deviceTree = {
        name = "qemu-${qemuArch}-virt.dtb";
        package = lib.mkForce (
          pkgs.runCommand "qemu-dtb" { } ''
            mkdir $out
            ${pkgs.qemu}/bin/qemu-system-${qemuArch} \
              -cpu max -machine virt,gic-version=max,accel=kvm:tcg,dumpdtb=$out/${config.hardware.deviceTree.name}
          ''
        );
      };
    };
  testScript =
    { nodes, ... }:
    ''
      machine.start()
      machine.wait_for_unit("multi-user.target")

      machine.succeed("grep 'linux,dummy-virt' /sys/firmware/devicetree/base/model")
    '';
in

{
  systemd-boot = runTestOn supportedSystems {
    name = "device-tree-systemd-boot";
    meta.maintainers = with pkgs.lib.maintainers; [
      qbisi
    ];

    nodes.machine = {
      imports = [ common ];

      boot.loader.systemd-boot.enable = true;
    };

    inherit testScript;
  };

  grub = runTestOn supportedSystems {
    name = "device-tree-grub";
    meta.maintainers = with pkgs.lib.maintainers; [
      qbisi
    ];

    nodes.machine = {
      imports = [ common ];

      boot.loader.grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        efiInstallAsRemovable = true;
      };
    };

    inherit testScript;
  };
}
