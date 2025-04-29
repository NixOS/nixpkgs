import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "mindustry";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ fgaz ];
    };

    nodes.machine =
      { config, pkgs, ... }:
      {
        imports = [
          ./common/x11.nix
        ];

        services.xserver.enable = true;
        environment.systemPackages = [ pkgs.mindustry ];
      };

    enableOCR = true;

    testScript = ''
      machine.wait_for_x()
      machine.execute("mindustry >&2 &")
      machine.wait_for_window("Mindustry")
      # Loading can take a while. Avoid wasting cycles on OCR during that time
      machine.sleep(60)
      machine.wait_for_text(r"(Play|Database|Editor|Mods|Settings|Quit)")
      machine.screenshot("screen")
    '';
  }
)
