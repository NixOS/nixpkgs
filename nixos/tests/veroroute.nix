{ pkgs, ... }:
{
  name = "veroroute";
  meta.maintainers = with pkgs.lib.maintainers; [ nh2 ];

  enableOCR = true;

  nodes.machine =
    { ... }:
    {
      imports = [
        ./common/x11.nix
      ];

      services.xserver.enable = true;
      environment.systemPackages = [
        pkgs.veroroute
        pkgs.xdotool
      ];
    };

  testScript = ''
    start_all()
    machine.wait_for_x()

    machine.execute("veroroute >&2 &")
    machine.wait_until_succeeds("xdotool search --pid $(pidof veroroute)")
    machine.wait_for_text("File")  # menu entry renders correctly
    machine.screenshot("screen")
  '';
}
