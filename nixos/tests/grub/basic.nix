{ lib, ... }:
{
  name = "grub";

  meta = with lib.maintainers; {
    maintainers = [ rnhmjoj ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };

  nodes.machine =
    { ... }:
    {
      virtualisation.useBootLoader = true;

      boot.loader.timeout = null;
      boot.loader.grub = {
        enable = true;
        users.alice.password = "supersecret";

        # OCR is not accurate enough. Use GRUB's own serial terminal and the
        # "dumb" terminfo type so the menu is emitted as plain sequential text
        # without cursor-address or clear-screen escape sequences.
        extraConfig = "serial; terminal_output serial; terminfo serial dumb";
      };
    };

  testScript = ''
    def grub_login_as(user, password):
        """
        Enters user and password to log into GRUB
        """
        machine.wait_for_console_text("Enter username:")
        machine.send_chars(user + "\n")
        machine.wait_for_console_text("Enter password:")
        machine.send_chars(password + "\n")


    def grub_select_all_configurations():
        """
        Selects "All configurations" from the GRUB menu
        to trigger a login request.
        """
        machine.send_monitor_command("sendkey down")
        machine.send_monitor_command("sendkey ret")


    machine.start()

    # wait for grub screen
    machine.wait_for_console_text("GNU GRUB")

    grub_select_all_configurations()
    with subtest("Invalid credentials are rejected"):
        grub_login_as("wronguser", "wrongsecret")
        machine.wait_for_console_text("error: access denied.")

    grub_select_all_configurations()
    with subtest("Valid credentials are accepted"):
        grub_login_as("alice", "supersecret")
        machine.send_chars("\n")  # press enter to boot
        machine.wait_for_console_text("Linux version")

    with subtest("Machine boots correctly"):
        machine.wait_for_unit("multi-user.target")
  '';
}
