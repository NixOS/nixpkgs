{ lib, ... }:

{
  name = "qemu-firmware";
  meta.maintainers = [ lib.maintainers.katexochen ];

  nodes.machine =
    { pkgs, ... }:
    {
      virtualisation.qemu.firmware = {
        enable = true;
        packages = [
          pkgs.qemu
          pkgs.OVMF-amdsev.fd
          pkgs.OVMF-inteltdx.fd
        ];
      };
      environment.systemPackages = [ pkgs.jq ];
    };

  testScript = ''
    machine.wait_for_unit("multi-user.target")

    with subtest("descriptors are merged into /etc/qemu/firmware"):
        machine.succeed("test -e /etc/qemu/firmware/60-edk2-x86_64.json")
        machine.succeed("test -e /etc/qemu/firmware/61-edk2-ovmf-x64-amdsev.json")
        machine.succeed("test -e /etc/qemu/firmware/61-edk2-ovmf-x64-inteltdx.json")

    with subtest("descriptors reference existing firmware images"):
        machine.succeed(
            "jq -er '.mapping | .filename // .executable.filename' "
            + "/etc/qemu/firmware/*.json | xargs stat --"
        )

    with subtest("systemd-vmspawn discovers the descriptors"):
        listed = machine.succeed("systemd-vmspawn --firmware=list")
        assert "61-edk2-ovmf-x64-amdsev.json" in listed
        assert "61-edk2-ovmf-x64-inteltdx.json" in listed
        assert "60-edk2-x86_64.json" in listed
  '';
}
