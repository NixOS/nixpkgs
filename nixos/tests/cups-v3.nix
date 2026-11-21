{ pkgs, ... }:
pkgs.testers.nixosTest {
  name = "cups-v3-basic";

  nodes.machine = { ... }: {
    imports = [ ../modules/services/printing/cups-v3.nix ];
    services.printing.enable = false;
    services.cups-v3 = {
      enable = true;
      localMode = "system";
      logLevel = "debug";
      sharing.enable = false;
    };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("cups-local.service")
    machine.wait_for_file("/run/cups3/cups.sock")

    # Legacy socket must be absent (services.printing.enable = false)
    machine.fail("test -S /run/cups/cups.sock")

    # Directories provisioned correctly
    machine.succeed("test -d /etc/cups3")
    machine.succeed("test -d /var/lib/cups3")
    machine.succeed("stat -c '%U' /var/lib/cups3 | grep -qx cups3")
    machine.succeed("stat -c '%a' /run/cups3 | grep -qx '755'")

    # Service identity
    machine.succeed(
        "systemctl show cups-local.service --property=User "
        "| grep -qx 'User=cups3'"
    )

    # Binaries on PATH
    for b in ["lp", "lpstat", "cancel", "cupslocald"]:
        machine.succeed(f"command -v {b}")

    # No legacy CUPS running
    machine.fail("systemctl is-active cups.service")

    # ipp-usb
    machine.succeed(
        "systemctl show ipp-usb.service --property=LoadState "
        "| grep -qx 'LoadState=loaded'"
    )
    machine.fail("systemctl is-active ipp-usb.service")
    machine.succeed("test -e /etc/udev/rules.d/71-ipp-usb.rules")

    # Scanning support (services.cups-v3.ipp-usb.scanning, default true)
    machine.succeed("command -v scanimage")
  '';
}
