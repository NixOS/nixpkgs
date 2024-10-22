import ./make-test-python.nix ({ pkgs, ... }: {
  name = "libresprite";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ fgaz ];
  };

  nodes.machine = { config, pkgs, ... }: {
    imports = [
      ./common/x11.nix
    ];

    services.xserver.enable = true;
    environment.systemPackages = [
      pkgs.imagemagick
      pkgs.libresprite
    ];
  };

  enableOCR = true;

  testScript =
    ''
      machine.wait_for_x()
      machine.succeed("convert -font DejaVu-Sans +antialias label:'IT WORKS' image.png")
      machine.execute("libresprite image.png >&2 &")
      machine.wait_for_window("LibreSprite v${pkgs.libresprite.version}")
      machine.wait_for_text("IT WORKS")
      machine.screenshot("screen")
    '';
})
