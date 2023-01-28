import ./make-test-python.nix ({ pkgs, ... }: {
  name = "shattered-pixel-dungeon";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ fgaz ];
  };

  nodes.machine = { config, pkgs, ... }: {
    imports = [
      ./common/x11.nix
    ];

    services.xserver.enable = true;
    sound.enable = true;
    environment.systemPackages = [ pkgs.shattered-pixel-dungeon ];
  };

  enableOCR = true;

  testScript =
    ''
      machine.wait_for_x()
      machine.execute("shattered-pixel-dungeon >&2 &")
      machine.wait_for_window(r"Shattered Pixel Dungeon")
      machine.sleep(5)
      if "Enter" not in machine.get_screen_text():
          raise Exception("Program did not start successfully")
      machine.screenshot("screen")
    '';
})

