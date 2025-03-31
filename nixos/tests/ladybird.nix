import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "ladybird";
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
        programs.ladybird.enable = true;
      };

    enableOCR = true;

    testScript = ''
      machine.wait_for_x()
      machine.succeed("echo '<!DOCTYPE html><html><body><h1>Hello world</h1></body></html>' > page.html")
      machine.execute("Ladybird file://$(pwd)/page.html >&2 &")
      machine.wait_for_window("Ladybird")
      machine.sleep(5)
      machine.wait_for_text("Hello world")
      machine.screenshot("screen")
    '';
  }
)
