{ pkgs, lib, ... }:
let
  pciID = "1b36:0005"; # Specific to `pci-testdev` device type
  pciAddr = "0b.0";

  baseNode = {
    virtualisation.qemu.options = [
      # IOMMU is supported only on q35
      "-machine"
      "q35"
      # IOMMU emulation
      "-device"
      "amd-iommu"
      # Virtual PCI device
      "-device"
      "pci-testdev,addr=${pciAddr}"
    ];

    virtualisation.vfio = {
      enable = true;
      pciIDs = [ pciID ];
      hostDrivers = [ "fake_driver" ];
    };
  };
in
{
  name = "vfio";
  meta.maintainers = with pkgs.lib.maintainers; [ d-brasher ];

  nodes = {
    machine = baseNode;
    initrdMachine =
      { config, ... }:
      {
        imports = [ baseNode ];
        virtualisation.vfio.loadInInitrd = true;

        # Pass path of initrd in store
        environment.etc."initrd-path".text = "${config.system.build.initialRamdisk}";
      };
  };

  testScript = ''
    start_all()

    for vm in [machine, initrdMachine]:
      with subtest(f"{vm.name}: test if virtual pci device exists"):
        device = vm.succeed(
          "grep -l 'PCI_ID=${lib.strings.toUpper pciID}' "
          "/sys/bus/pci/devices/*/uevent"
        ).strip().removesuffix("/uevent")
        vm.succeed(f"test $(basename $(readlink {device}/driver)) = vfio-pci")

      with subtest(f"{vm.name}: test if kernelParams contains vfio-pci.ids"):
        vm.succeed("grep -w vfio-pci.ids=${pciID} /proc/cmdline")

      with subtest(f"{vm.name}: test if VFIO kernel modules are loaded"):
        vm.succeed("test -d /sys/module/vfio")
        vm.succeed("test -d /sys/module/vfio_pci")

      with subtest(f"{vm.name}: test if softdep line is in modprobe config"):
        vm.succeed(
          "grep -R 'softdep fake_driver pre: vfio-pci' /etc/modprobe.d"
        )

      with subtest(f"{vm.name}: test if vfio-pci is bound to pci device"):
        vm.succeed(
          "readlink /sys/bus/pci/devices/0000:00:${pciAddr}/driver | grep vfio-pci"
        )

    with subtest("initrdMachine: test if VFIO modules are present in initrd"):
      initrdMachine.succeed("mkdir -p /tmp/initrd && zstdcat $(cat /etc/initrd-path)/initrd | cpio -id -D /tmp/initrd")
      initrdMachine.succeed("find /tmp/initrd/ -name 'vfio.ko*' | grep -q .")
      initrdMachine.succeed("find /tmp/initrd/ -name 'vfio-pci.ko*' | grep -q .")
  '';
}
