import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "plotinus";
    meta = {
      maintainers = pkgs.plotinus.meta.maintainers;
      timeout = 600;
    };

    nodes.machine =
      { pkgs, ... }:

      {
        imports = [ ./common/x11.nix ];
        programs.plotinus.enable = true;
        environment.systemPackages = [
          pkgs.gnome-pomodoro
          pkgs.xdotool
        ];
      };

    testScript = ''
      machine.wait_for_x()
      machine.succeed("gnome-pomodoro >&2 &")
      machine.wait_for_window("Pomodoro", timeout=120)
      machine.succeed(
          "xdotool search --sync --onlyvisible --class gnome-pomodoro "
          + "windowfocus --sync key --clearmodifiers --delay 1 'ctrl+shift+p'"
      )
      machine.sleep(5)  # wait for the popup
      machine.screenshot("popup")
      machine.succeed("xdotool key --delay 100 p r e f e r e n c e s Return")
      machine.wait_for_window("Preferences", timeout=120)
    '';
  }
)
