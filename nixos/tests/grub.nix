{ pkgs, runTest }:

{
  # Basic GRUB setup with BIOS and a password
  basic = runTest {
    name = "grub-basic";
    meta.maintainers = with pkgs.lib.maintainers; [ rnhmjoj ];

    nodes.machine = { ... }: {
      virtualisation.useBootLoader = true;
      boot.loader.timeout = null;
      boot.loader.grub = {
        enable = true;
        users.alice.password = "supersecret";
        # OCR is not accurate enough
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
    };

  # Test boot loader entries on EFI
  bls-efi = runTest {
    name = "grub-bls-efi";
    meta.maintainers = with pkgs.lib.maintainers; [ rnhmjoj ];

    nodes.machine = { pkgs, ... }: {
      virtualisation.useBootLoader = true;
      virtualisation.useEFIBoot = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.loader.grub.enable = true;
      boot.loader.grub.efiSupport = true;
    };

    testScript = ''
      with subtest("Machine boots correctly"):
          machine.wait_for_unit("multi-user.target")

      with subtest("Boot entries are installed"):
          entries = machine.succeed("bootctl list")
          print(entries)
          error = "NixOS boot entry not found in bootctl list."
          assert "version: Generation 1" in entries, error

      with subtest("systemctl kexec can detect the kernel"):
          machine.succeed("systemctl kexec --dry-run")

      with subtest("systemctl kexec really works"):
          machine.execute("systemctl kexec", check_return=False)
          machine.connected = False
          machine.connect()
          machine.wait_for_unit("multi-user.target")
    '';
  };

  # Test boot loader entries on BIOS
  bls-bios = runTest {
    name = "grub-bls-bios";
    meta.maintainers = with pkgs.lib.maintainers; [ rnhmjoj ];

    nodes.machine = { pkgs, ... }: {
      virtualisation.useBootLoader = true;
      boot.loader.grub.enable = true;
    };

    testScript = ''
      with subtest("Machine boots correctly"):
          machine.wait_for_unit("multi-user.target")

      with subtest("Boot entries are installed"):
          machine.succeed("test -f /boot/loader/entries/nixos-generation-1.conf")

      with subtest("systemctl kexec can detect the kernel"):
          machine.succeed("systemctl kexec --dry-run")

      with subtest("systemctl kexec really works"):
          machine.execute("systemctl kexec", check_return=False)
          machine.connected = False
          machine.connect()
          machine.wait_for_unit("multi-user.target")
    '';
  };

}
