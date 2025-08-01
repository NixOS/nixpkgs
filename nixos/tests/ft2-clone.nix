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
      environment.systemPackages = [ pkgs.ft2-clone ];
    };

  enableOCR = true;

  testScript = ''
    machine.wait_for_x()
    # Add a dummy sound card, or the program won't start
    machine.execute("modprobe snd-dummy")

    machine.execute("ft2-clone >&2 &")

    machine.wait_for_window(r"Fasttracker")
    machine.sleep(5)
    machine.wait_for_text(r"(Songlen|Repstart|Time|About|Nibbles|Help)")
    machine.screenshot("screen")
  '';
}
