import ./make-test.nix ({ pkgs, ...} : {
  name = "gnome3";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ domenkozar eelco chaoflow lethalman ];
  };

  machine =
    { ... }:

    { imports = [ ./common/user-account.nix ];

      services.xserver.enable = true;

      services.xserver.displayManager.gdm.enable = false;
      services.xserver.displayManager.lightdm.enable = true;
      services.xserver.displayManager.lightdm.autoLogin.enable = true;
      services.xserver.displayManager.lightdm.autoLogin.user = "alice";
      services.xserver.desktopManager.gnome3.enable = true;
      services.xserver.desktopManager.default = "gnome-xorg";

      virtualisation.memorySize = 1024;
    };

  testScript =
    ''
      $machine->waitForX;

      # wait for alice to be logged in
      $machine->waitForUnit("default.target","alice");

      # Check that logging in has given the user ownership of devices.
      $machine->succeed("getfacl /dev/snd/timer | grep -q alice");

      $machine->succeed("su - alice -c 'DISPLAY=:0.0 gnome-terminal &'");
      $machine->succeed("xauth merge ~alice/.Xauthority");
      $machine->waitForWindow(qr/alice.*machine/);
      $machine->succeed("timeout 900 bash -c 'while read msg; do if [[ \$msg =~ \"GNOME Shell started\" ]]; then break; fi; done < <(journalctl -f)'");
      $machine->sleep(10);
      $machine->screenshot("screen");
    '';
})
