import ./make-test-python.nix ({ pkgs, ... }: {
  name = "pt2-clone";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ fgaz ];
  };

  nodes.machine = { config, pkgs, ... }: {
    imports = [
      ./common/x11.nix
    ];

    services.xserver.enable = true;
    environment.systemPackages = [ pkgs.pt2-clone ];
  };

  enableOCR = true;

  testScript =
    ''
      machine.wait_for_x()
      # Add a dummy sound card, or the program won't start
      machine.execute("modprobe snd-dummy")

      machine.execute("pt2-clone >&2 &")

      machine.wait_for_window(r"ProTracker")
      machine.sleep(5)
      # One of the few words that actually get recognized
      if "LENGTH" not in machine.get_screen_text():
          raise Exception("Program did not start successfully")
      machine.screenshot("screen")
    '';
})

