{ lib, ... }:
{
  name = "grub-efi";

  meta = with lib.maintainers; {
    maintainers = [
      tomfitzhenry
      rnhmjoj
    ];
    platforms = lib.platforms.linux;
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
        #
        # GRUB's own "serial" terminal (8250/16550 COM ports) only exists on
        # x86. On EFI, GRUB exposes the platform serial via the EFI SerialIO
        # protocol as the terminfo terminal "serial_efi0", which EDK2 routes
        # to the serial port the test reads; this works on both x86_64 and
        # aarch64. We switch it to the "dumb" terminfo type so GRUB emits
        # plain sequential text without cursor-address or clear-screen escape
        # sequences, keeping the console log linear and readable.
        extraConfig = "terminal_output serial_efi0; terminfo serial_efi0 dumb";
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
