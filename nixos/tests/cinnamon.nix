import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "cinnamon";

  meta = with lib; {
    maintainers = teams.cinnamon.members;
  };

  nodes.machine = { nodes, ... }: {
    imports = [ ./common/user-account.nix ];
    services.xserver.enable = true;
    services.xserver.desktopManager.cinnamon.enable = true;
  };

  enableOCR = true;

  testScript = { nodes, ... }:
    let
      user = nodes.machine.config.users.users.alice;
      uid = toString user.uid;
      bus = "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/${uid}/bus";
      display = "DISPLAY=:0.0";
      env = "${bus} ${display}";
      gdbus = "${env} gdbus";
      su = command: "su - ${user.name} -c '${env} ${command}'";

      # Call javascript in cinnamon (the shell), returns a tuple (success, output),
      # where `success` is true if the dbus call was successful and `output` is what
      # the javascript evaluates to.
      eval = "call --session -d org.Cinnamon -o /org/Cinnamon -m org.Cinnamon.Eval";

      # Should be 2 (RunState.RUNNING) when startup is done.
      # https://github.com/linuxmint/cinnamon/blob/5.4.0/js/ui/main.js#L183-L187
      getRunState = su "${gdbus} ${eval} Main.runState";

      # Start gnome-terminal.
      gnomeTerminalCommand = su "gnome-terminal";

      # Hopefully gnome-terminal's wm class.
      wmClass = su "${gdbus} ${eval} global.display.focus_window.wm_class";
    in
    ''
      machine.wait_for_unit("display-manager.service")

      with subtest("Test if we can see username in slick-greeter"):
          machine.wait_for_text("${user.description}")
          machine.screenshot("slick_greeter_lightdm")

      with subtest("Login with slick-greeter"):
          machine.send_chars("${user.password}\n")
          machine.wait_for_x()
          machine.wait_for_file("${user.home}/.Xauthority")
          machine.succeed("xauth merge ${user.home}/.Xauthority")

      with subtest("Check that logging in has given the user ownership of devices"):
          machine.succeed("getfacl -p /dev/snd/timer | grep -q ${user.name}")

      with subtest("Wait for the Cinnamon shell"):
          # Correct output should be (true, '2')
          machine.wait_until_succeeds("${getRunState} | grep -q 'true,..2'")

      with subtest("Open GNOME Terminal"):
          machine.succeed("${gnomeTerminalCommand}")
          # Correct output should be (true, '"Gnome-terminal"')
          machine.wait_until_succeeds("${wmClass} | grep -q 'true,...Gnome-terminal'")
          machine.sleep(20)
          machine.screenshot("screen")
    '';
})
