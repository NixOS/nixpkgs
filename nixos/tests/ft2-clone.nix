import ./make-test-python.nix ({ pkgs, ... }: {
  name = "ft2-clone";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ fgaz ];
  };

  machine = { config, pkgs, ... }: {
    imports = [
      ./common/x11.nix
    ];

    services.xserver.enable = true;
    sound.enable = true;
    environment.systemPackages = [ pkgs.ft2-clone ];
  };

  enableOCR = true;

  testScript =
    ''
      machine.wait_for_x()
      # Add a dummy sound card, or the program won't start
      machine.execute("modprobe snd-dummy")

      machine.execute("ft2-clone >&2 &")

      machine.wait_for_window(r"Fasttracker")
      machine.sleep(5)
      # One of the few words that actually get recognized
      if "Songlen" not in machine.get_screen_text():
          raise Exception("Program did not start successfully")
      machine.screenshot("screen")
    '';
})

