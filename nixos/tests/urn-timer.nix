{ pkgs, ... }:
{
  name = "urn-timer";
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
      environment.systemPackages = [ pkgs.urn-timer ];
    };

  enableOCR = true;

  testScript = ''
    machine.wait_for_x()
    machine.execute("urn-gtk ${pkgs.urn-timer.src}/splits_examples/sotn.json >&2 &")
    machine.wait_for_window("urn")
    machine.wait_for_text(r"(Mist|Bat|Reverse|Dracula)")
    machine.screenshot("screen")
  '';
}
