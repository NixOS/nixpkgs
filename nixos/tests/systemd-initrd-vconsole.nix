import ./make-test-python.nix ({ lib, pkgs, ... }: {
  name = "systemd-initrd-vconsole";

  nodes.machine = { pkgs, ... }: {
    boot.kernelParams = lib.mkAfter [ "rd.systemd.unit=rescue.target" "loglevel=3" "udev.log_level=3" "systemd.log_level=warning" ];

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

    # Wait for shell to become ready
    for _ in range(300):
      machine.send_console("printf '%s to receive commands:\\n' Ready\n")
      try:
        machine.wait_for_console_text("Ready to receive commands:", timeout=1)
        break
      except Exception:
        continue
    else:
      raise RuntimeError("Rescue shell never became ready")

    # Check keymap
    machine.send_console("(printf '%s to receive text:\\n' Ready && read text && echo \"$text\") </dev/tty1\n")
    machine.wait_for_console_text("Ready to receive text:")
    for key in "asdfjkl;\n":
      machine.send_key(key)
    machine.wait_for_console_text("arstneio")
  '';
})
