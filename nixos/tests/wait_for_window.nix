# This tests the test-framework's wait_for_window().
# This is a regression test for https://github.com/NixOS/nixpkgs/issues/106685

let
  common = {
    services.xserver = {
      enable = true;
      desktopManager.gnome3.enable = true;
      displayManager.autoLogin = {
        enable = true;
        user = "alice";
      };
    };
    users.users.alice.isNormalUser = true;
    virtualisation.memorySize = 1024;
  };
  configs = {
    lightdm = {
      imports = [ common ];
      services.xserver.displayManager.lightdm.enable = true;
    };
    gdmwayland = {
      imports = [ common ];
      services.xserver.displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    };
    gdmxorg = {
      imports = [ common ];
      services.xserver.displayManager.gdm = {
        enable = true;
        wayland = false;
      };
    };
  };
in builtins.mapAttrs (name: config:
  import ./make-test-python.nix {
    inherit name;
    machine = {
      imports = [ config ];
      networking.hostName = name;
    };
    testScript = ''
      ${name}.wait_for_window("GNOME Shell", "alice")
    '';
  } { }) configs
