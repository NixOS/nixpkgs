{ lib, ... }:
{
  name = "grub-efi";

  meta = with lib.maintainers; {
    maintainers = [
      tomfitzhenry
      rnhmjoj
    ];
  };

  nodes.machine =
    { ... }:
    {
      virtualisation.useBootLoader = true;
      virtualisation.useEFIBoot = true;

      boot.loader.grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";

        # Read GRUB from the serial console so its output can be matched
        # deterministically with wait_for_console_text, rather than via OCR.
        extraConfig = "serial; terminal_output serial";
      };
      boot.loader.efi.canTouchEfiVariables = true;
    };

  testScript = ''
    machine.start()

    with subtest("Enters GRUB"):
        machine.wait_for_console_text("GNU GRUB")

    with subtest("Loads kernel"):
        machine.wait_for_console_text("Linux version")

    with subtest("Reaches multi-user target"):
        machine.wait_for_unit("multi-user.target")

    with subtest("Boots via UEFI"):
        machine.succeed("test -d /sys/firmware/efi")
  '';
}
