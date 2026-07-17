{ pkgs, ... }:
{
  name = "domination";
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
      environment.systemPackages = [ pkgs.domination ];
    };

  enableOCR = true;

  testScript = ''
    machine.wait_for_x()
    # Add a dummy sound card, or an error reporting popup will appear,
    # covering the main window and preventing OCR
    machine.execute("modprobe snd-dummy")
    machine.execute("domination >&2 &")
    machine.wait_for_window("Menu")
    machine.wait_for_text(r"(New Game|Start Server|Load Game|Help Manual|Join Game|About|Play Online)")
    machine.screenshot("screen")
  '';
}
