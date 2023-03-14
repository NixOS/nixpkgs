import ./make-test-python.nix ({ pkgs, ...} : {
  name = "xfce";

  nodes.machine =
    { pkgs, ... }:

    {
      imports = [
        ./common/user-account.nix
      ];

      services.xserver.enable = true;

      services.xserver.displayManager = {
        lightdm.enable = true;
        autoLogin = {
          enable = true;
          user = "alice";
        };
      };

      services.xserver.desktopManager.xfce.enable = true;

      hardware.pulseaudio.enable = true; # needed for the factl test, /dev/snd/* exists without them but udev doesn't care then

    };

  testScript = { nodes, ... }: let
    user = nodes.machine.config.users.users.alice;
  in ''
      machine.wait_for_x()
      machine.wait_for_file("${user.home}/.Xauthority")
      machine.succeed("xauth merge ${user.home}/.Xauthority")
      machine.wait_for_window("xfce4-panel")
      machine.sleep(10)

      # Check that logging in has given the user ownership of devices.
      machine.succeed("getfacl -p /dev/snd/timer | grep -q ${user.name}")

      machine.succeed("su - ${user.name} -c 'DISPLAY=:0.0 xfce4-terminal >&2 &'")
      machine.wait_for_window("Terminal")
      machine.sleep(10)
      machine.screenshot("screen")
    '';
})
