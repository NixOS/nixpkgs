{ pkgs, ... }:
{
  name = "pt2-clone";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ fgaz ];
  };

  nodes.machine =
    { config, pkgs, ... }:
    {
      imports = [
        ./common/x11.nix
      ];

      boot.kernelModules = [ "snd-dummy" ];
      services.pulseaudio = {
        enable = true;
        systemWide = true;
      };
      services.pipewire.enable = false;
      environment.systemPackages = [ pkgs.pt2-clone ];
    };

  enableOCR = true;

  testScript = ''
    machine.wait_for_x()

    machine.execute("pt2-clone >&2 &")

    machine.wait_for_window(r"ProTracker")
    machine.sleep(5)
    # One of the few words that actually get recognized
    machine.wait_for_text("LENGTH")
    machine.screenshot("screen")
  '';
}
