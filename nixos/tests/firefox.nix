import ./make-test-python.nix ({ pkgs, esr ? false, ... }: {
  name = "firefox";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ eelco shlevy ];
  };

  machine =
    { pkgs, ... }:

    { imports = [ ./common/x11.nix ];
      environment.systemPackages =
        (if esr then [ pkgs.firefox-esr ] else [ pkgs.firefox ])
        ++ [ pkgs.xdotool ];
    };

  testScript = ''
      machine.wait_for_x()

      with subtest("wait until Firefox has finished loading the Valgrind docs page"):
          machine.execute(
              "xterm -e 'firefox file://${pkgs.valgrind.doc}/share/doc/valgrind/html/index.html' &"
          )
          machine.wait_for_window("Valgrind")
          machine.sleep(40)

      with subtest("Close default browser prompt"):
          machine.execute("xdotool key space")

      with subtest("Hide default browser window"):
          machine.sleep(2)
          machine.execute("xdotool key F12")

      with subtest("wait until Firefox draws the developer tool panel"):
          machine.sleep(10)
          machine.succeed("xwininfo -root -tree | grep Valgrind")
          machine.screenshot("screen")
    '';

})
