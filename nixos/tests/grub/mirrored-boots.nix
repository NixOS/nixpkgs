{ lib, ... }:
{
  name = "grub-mirrored-boots";

  meta = with lib.maintainers; {
    maintainers = [
      tomfitzhenry
      rnhmjoj
    ];
  };

  nodes.machine =
    { lib, ... }:
    {
      virtualisation.useBootLoader = true;

      boot.loader.timeout = null;
      boot.loader.grub = {
        enable = true;
        device = lib.mkOverride 0 "";
        mirroredBoots = [
          {
            path = "/boot1";
            devices = [ "/dev/vda" ];
          }
          {
            path = "/boot2";
            devices = [ "nodev" ];
          }
        ];

        # Read GRUB from the serial console so its output can be matched
        # deterministically with wait_for_console_text, rather than via OCR.
        extraConfig = "serial; terminal_output serial";
      };
    };

  testScript = ''
    machine.start()

    # wait for grub screen
    machine.wait_for_console_text("GNU GRUB")

    machine.send_chars("\n")  # press enter to boot default option

    with subtest("Machine boots correctly"):
        machine.wait_for_unit("multi-user.target")

    with subtest("Verify boot path 1 GRUB installation and configuration"):
        machine.succeed("test -d /boot1/grub")
        machine.succeed("test -f /boot1/grub/grub.cfg")
        machine.succeed("test -f /boot1/grub/state")
        machine.succeed("grep -q 'menuentry' /boot1/grub/grub.cfg")

    with subtest("Verify boot path 2 GRUB installation and configuration"):
        machine.succeed("test -d /boot2/grub")
        machine.succeed("test -f /boot2/grub/grub.cfg")
        machine.succeed("test -f /boot2/grub/state")
        machine.succeed("grep -q 'menuentry' /boot2/grub/grub.cfg")
  '';
}
