{ lib, ... }:
{
  name = "grub-hashed-password";

  meta = with lib.maintainers; {
    maintainers = [
      tomfitzhenry
      rnhmjoj
    ];
  };

  nodes.machine =
    { pkgs, ... }:
    let
      mkGrubPbkdf2HashFile =
        password:
        toString (
          pkgs.runCommandLocal "grub-pbkdf2-hash" { nativeBuildInputs = [ pkgs.grub2 ]; } ''
            printf "%s\n%s\n" "${password}" "${password}" | grub-mkpasswd-pbkdf2 | grep -o 'grub\.pbkdf2\.[^[:space:]]*' > $out
          ''
        );
    in
    {
      virtualisation.useBootLoader = true;

      boot.loader.timeout = null;
      boot.loader.grub = {
        enable = true;
        users.bob.hashedPasswordFile = mkGrubPbkdf2HashFile "bobsecret";

        # Read GRUB from the serial console so its output can be matched
        # deterministically; OCR would work but is flakier, which matters for
        # the multi-step interactive login exercised below.
        extraConfig = "serial; terminal_output serial";
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
    with subtest("Invalid hashedPassword credentials are rejected"):
        grub_login_as("bob", "wrongsecret")
        machine.wait_for_console_text("access denied")

    grub_select_all_configurations()
    with subtest("Valid hashedPassword credentials are accepted"):
        grub_login_as("bob", "bobsecret")
        machine.send_chars("\n")  # press enter to boot
        machine.wait_for_console_text("Linux version")

    with subtest("Machine boots correctly"):
        machine.wait_for_unit("multi-user.target")
  '';
}
