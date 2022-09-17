import ./make-test-python.nix ({ pkgs, ... }: {
  name = "vengi-tools";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ fgaz ];
  };

  nodes.machine = { config, pkgs, ... }: {
    imports = [
      ./common/x11.nix
    ];

    services.xserver.enable = true;
    environment.systemPackages = [ pkgs.vengi-tools ];
  };

  enableOCR = true;

  testScript =
    ''
      machine.wait_for_x()
      machine.execute("vengi-voxedit >&2 &")
      machine.wait_for_window("voxedit")
      # OCR on voxedit's window is very expensive, so we avoid wasting a try
      # by letting the window load fully first
      machine.sleep(15)
      machine.wait_for_text("Solid")
      machine.screenshot("screen")
    '';
})
