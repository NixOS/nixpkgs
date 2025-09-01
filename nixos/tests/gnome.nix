{ pkgs, lib, ... }:
{
  name = "gnome";
  meta.maintainers = lib.teams.gnome.members;

  nodes.machine =
    { ... }:

    {
      imports = [ ./common/user-account.nix ];

      services.xserver.enable = true;

      services.displayManager.gdm = {
        enable = true;
        debug = true;
      };

      services.displayManager.autoLogin = {
        enable = true;
        user = "alice";
      };

      services.desktopManager.gnome.enable = true;
      services.desktopManager.gnome.debug = true;

      systemd.user.services = {
        "org.gnome.Shell@wayland" = {
          serviceConfig = {
            ExecStart = [
              # Clear the list before overriding it.
              ""
              # Eval API is now internal so Shell needs to run in unsafe mode.
              # TODO: improve test driver so that it supports openqa-like manipulation
              # that would allow us to drop this mess.
              "${pkgs.gnome-shell}/bin/gnome-shell --unsafe-mode"
            ];
          };
        };
      };

    };

  testScript =
    { nodes, ... }:
    let
      # Keep line widths somewhat manageable
      user = nodes.machine.users.users.alice;
      uid = toString user.uid;
      bus = "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/${uid}/bus";
      # Run a command in the appropriate user environment
      run = command: "su - ${user.name} -c '${bus} ${command}'";

      # Call javascript in gnome shell, returns a tuple (success, output), where
      # `success` is true if the dbus call was successful and output is what the
      # javascript evaluates to.
      eval =
        command:
        run "gdbus call --session -d org.gnome.Shell -o /org/gnome/Shell -m org.gnome.Shell.Eval ${command}";

      # False when startup is done
      startingUp = eval "Main.layoutManager._startingUp";

      # Start Console
      launchConsole = run "gapplication launch org.gnome.Console";

      # Hopefully Console's wm class
      wmClass = eval "global.display.focus_window.wm_class";
    in
    ''
      with subtest("Login to GNOME with GDM"):
          # wait for gdm to start
          machine.wait_for_unit("display-manager.service")
          # wait for the wayland server
          machine.wait_for_file("/run/user/${uid}/wayland-0")
          # wait for alice to be logged in
          machine.wait_for_unit("default.target", "${user.name}")
          # check that logging in has given the user ownership of devices
          assert "alice" in machine.succeed("getfacl -p /dev/snd/timer")

      with subtest("Wait for GNOME Shell"):
          # correct output should be (true, 'false')
          machine.wait_until_succeeds(
              "${startingUp} | grep -q 'true,..false'"
          )

      with subtest("Open Console"):
          # Close the Activities view so that Shell can correctly track the focused window.
          machine.send_key("esc")

          machine.succeed(
              "${launchConsole}"
          )
          # correct output should be (true, '"org.gnome.Console"')
          machine.wait_until_succeeds(
              "${wmClass} | grep -q 'true,...org.gnome.Console'"
          )
          machine.sleep(20)
          machine.screenshot("screen")
    '';
}
