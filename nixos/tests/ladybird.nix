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
    # On first launch, the welcome tab is selected before the requested page.
    machine.wait_for_text("Welcome to Ladybird")
    machine.send_key("ctrl-tab")
    machine.wait_for_text("Hello world")
    machine.screenshot("screen")
  '';
}
