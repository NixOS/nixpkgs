import ./make-test-python.nix ({ pkgs, firefoxPackage, ... }: {
  name = "firefox";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ eelco shlevy ];
  };

  nodes.machine =
    { pkgs, ... }:

    { imports = [ ./common/x11.nix ];
      environment.systemPackages = [
        firefoxPackage
        pkgs.xdotool
      ];

      sound.enable = true;
      virtualisation.audio = true;
    };

  testScript = ''
      machine.wait_for_x()

      with subtest("Wait until Firefox has finished loading the Valgrind docs page"):
          machine.execute(
              "xterm -e 'firefox file://${pkgs.valgrind.doc}/share/doc/valgrind/html/index.html' >&2 &"
          )
          machine.wait_for_window("Valgrind")
          machine.sleep(40)

      with subtest("Check whether Firefox can play sound"):
          with machine.record_audio("record"):
              machine.succeed(
                  "firefox file://${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/phone-incoming-call.oga >&2 &"
              )
              machine.wait_for_window("phone-incoming-call.oga")
              machine.sleep(10)

      with subtest("Close sound test tab"):
          machine.execute("xdotool key ctrl+w")

      with subtest("Close default browser prompt"):
          machine.execute("xdotool key space")

      with subtest("Wait until Firefox draws the developer tool panel"):
          machine.sleep(10)
          machine.succeed("xwininfo -root -tree | grep Valgrind")
          machine.screenshot("screen")
    '';

})
