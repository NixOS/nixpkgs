import ./make-test-python.nix ({ pkgs, ... }: {
  name = "plotinus";
  meta = {
    maintainers = pkgs.plotinus.meta.maintainers;
  };

  machine =
    { pkgs, ... }:

    { imports = [ ./common/x11.nix ];
      programs.plotinus.enable = true;
      environment.systemPackages = [ pkgs.gnome.gnome-calculator pkgs.xdotool ];
    };

  testScript = ''
    machine.wait_for_x()
    machine.succeed("gnome-calculator >&2 &")
    machine.wait_for_window("gnome-calculator")
    machine.succeed(
        "xdotool search --sync --onlyvisible --class gnome-calculator "
        + "windowfocus --sync key --clearmodifiers --delay 1 'ctrl+shift+p'"
    )
    machine.sleep(5)  # wait for the popup
    machine.succeed("xdotool key --delay 100 p r e f e r e n c e s Return")
    machine.wait_for_window("Preferences")
    machine.screenshot("screen")
  '';
})
