{ pkgs, ... }:

{
  name = "cardwire";

  nodes.machine =
    { pkgs, lib, ... }:
    {
      services.cardwired.enable = true;
      services.dbus.enable = true;

      boot.kernelParams = [
        "intel_iommu=on"
        "iommu=pt"
      ];

      virtualisation.qemu.options = [
        "-machine q35,accel=kvm,kernel-irqchip=split"
        "-device intel-iommu,intremap=on,device-iotlb=on"
        "-vga none"
        "-device virtio-gpu-pci,id=igpu,max_outputs=2"
        "-device virtio-gpu-pci,id=dgpu,max_outputs=1"
      ];
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("default.target")
    with subtest("Wait for boot and services"):
        machine.wait_for_unit("multi-user.target")
        machine.wait_for_unit("dbus.service")
        machine.wait_for_unit("cardwired.service")

    with subtest("Check for DRM Devices"):
        dri_out = machine.succeed("ls -a /dev/dri")
        assert "renderD128" in dri_out, "Missing DRM"
        assert "card0" in dri_out, "Missing DRM"
        assert "renderD129" in dri_out, "Missing DRM"
        assert "card1" in dri_out, "Missing DRM"

    with subtest("Ensure cardwire is started and dbus works"):
        machine.wait_until_succeeds("cardwire help")

    with subtest("Ensure files are present"):
      machine.succeed("cat /etc/cardwire/cardwire.toml")
      machine.succeed("cat /var/lib/cardwire/gpu_state.json")
      machine.succeed("cat /var/lib/cardwire/mode.json")

    with subtest("Switch to Integrated mode"):
        assert "renderD128" in machine.succeed("cardwire list"), "Missing RenderD128 in cardwire"
        machine.succeed("test -e /dev/dri/renderD129")
        assert "Mode has been set to Integrated" in machine.succeed("cardwire set integrated")
        machine.fail(": < /dev/dri/renderD129")
        assert "integrated" in machine.succeed("cat /var/lib/cardwire/mode.json")

    with subtest("Switchback to hybrid mode"):
        assert "Mode has been set to Hybrid" in machine.succeed("cardwire set hybrid")
        machine.succeed(": < /dev/dri/renderD129")
        assert "hybrid" in machine.succeed("cat /var/lib/cardwire/mode.json")

    with subtest("Try to block default gpu"):
      cardwire_out = machine.succeed("cardwire gpu 0 --block 2>&1")
      assert "Per GPU block is only available on manual mode" in cardwire_out, "Default gpu got blocked"
  '';
}
