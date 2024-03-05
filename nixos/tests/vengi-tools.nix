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
      # Let the window load fully
      machine.sleep(15)
      machine.screenshot("screen")
    '';
})
