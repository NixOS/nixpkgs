import ./make-test-python.nix ({ lib, pkgs, ... }: {
  name = "systemd-initrd-vconsole";

  nodes.machine = { pkgs, ... }: {
    boot.kernelParams = [ "rd.systemd.unit=rescue.target" ];

    boot.initrd.systemd = {
      enable = true;
      emergencyAccess = true;
    };

    console = {
      earlySetup = true;
      keyMap = "colemak";
    };
  };

  testScript = ''
    # Boot into rescue shell in initrd
    machine.start()
    machine.wait_for_console_text("Press Enter for maintenance")
    machine.send_console("\n")
    machine.wait_for_console_text("Logging in with home")

    # Check keymap
    machine.send_console("(printf '%s to receive text: \\n' Ready && read text && echo \"$text\") </dev/tty1\n")
    machine.wait_for_console_text("Ready to receive text:")
    for key in "asdfjkl;\n":
      machine.send_key(key)
    machine.wait_for_console_text("arstneio")
    machine.send_console("systemctl poweroff\n")
  '';
})
