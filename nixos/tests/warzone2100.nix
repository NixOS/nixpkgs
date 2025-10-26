{ pkgs, ... }:
{
  name = "warzone2100";
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
      environment.systemPackages = [ pkgs.warzone2100 ];
    };

  enableOCR = true;

  testScript = ''
    machine.wait_for_x()
    machine.execute("warzone2100 >&2 &")
    machine.wait_for_window("Warzone 2100")
    machine.wait_for_text(r"(Single Player|Multi Player|Tutorial|Options|Quit Game)")
    machine.screenshot("screen")
  '';
}
