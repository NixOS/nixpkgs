import ./make-test-python.nix ({ pkgs, ... }: {
  name = "sfxr-qt";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ fgaz ];
  };

  machine = { config, pkgs, ... }: {
    imports = [
      ./common/x11.nix
    ];

    services.xserver.enable = true;
    environment.systemPackages = [ pkgs.sfxr-qt ];
  };

  enableOCR = true;

  testScript =
    ''
      machine.wait_for_x()
      # Add a dummy sound card, or the program won't start
      machine.execute("modprobe snd-dummy")

      machine.execute("sfxr-qt >&2 &")

      machine.wait_for_window(r"sfxr")
      machine.sleep(10)
      machine.wait_for_text("requency")
      machine.screenshot("screen")
    '';
})
