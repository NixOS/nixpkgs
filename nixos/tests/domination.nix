import ./make-test-python.nix ({ pkgs, ... }: {
  name = "domination";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ fgaz ];
  };

  nodes.machine = { config, pkgs, ... }: {
    imports = [
      ./common/x11.nix
    ];

    services.xserver.enable = true;
    environment.systemPackages = [ pkgs.domination ];
  };

  enableOCR = true;

  testScript =
    ''
      machine.wait_for_x()
      machine.execute("domination >&2 &")
      machine.wait_for_window("Menu")
      machine.wait_for_text("New Game")
      machine.screenshot("screen")
    '';
})
