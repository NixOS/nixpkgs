{ lib, pkgs, ... }:
{
  name = "grub";

  meta = with lib.maintainers; {
    maintainers = [ rnhmjoj ];
  };

  nodes.machine =
    { ... }:
    {
      virtualisation.useBootLoader = true;

      boot.loader.timeout = null;
      boot.loader.grub = {
        enable = true;
        users.alice.password = "supersecret";

        # OCR is not accurate enough
        extraConfig = "serial; terminal_output serial";
      };
    };

  testScript =
    { nodes, ... }:
    let
      emptySystem = pkgs.runCommand "grub-empty-source" { } ''
        mkdir $out
        touch $out/kernel $out/initrd
      '';
    in
    ''
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
          machine.wait_for_console_text("access denied")

      grub_select_all_configurations()
      with subtest("Valid credentials are accepted"):
          grub_login_as("alice", "supersecret")
          machine.send_chars("\n")  # press enter to boot
          machine.wait_for_console_text("Linux version")

      with subtest("Machine boots correctly"):
          machine.wait_for_unit("multi-user.target")

      with subtest("Reject an empty source without copying kernels"):
          # A separate boot filesystem would enable copying regardless of copyKernels.
          assert machine.succeed("stat -c %d /boot") == machine.succeed("stat -c %d /nix/store")
          previous_menu = machine.succeed("cat /boot/grub/grub.cfg")
          output = machine.fail("${nodes.machine.system.build.installBootLoader} ${emptySystem} 2>&1")
          assert "cannot install empty boot image ${emptySystem}/kernel" in output, output
          assert machine.succeed("cat /boot/grub/grub.cfg") == previous_menu
    '';
}
