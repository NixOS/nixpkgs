{ pkgs, ... }:
{
  name = "ft2-clone";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ fgaz ];
  };

  nodes.machine =
    { pkgs, ... }:
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
      environment.systemPackages = [ pkgs.ft2-clone ];
    };

  enableOCR = true;

  testScript = ''
    machine.wait_for_x()

    machine.execute("ft2-clone >&2 &")

    machine.wait_for_window(r"Fasttracker")
    machine.sleep(5)
    machine.wait_for_text(r"(Songlen|Repstart|Time|About|Nibbles|Help)")
    machine.screenshot("screen")
  '';
}
