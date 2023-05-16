{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };

let
  inherit (pkgs) lib;

  tests = {
    default = {
      name = "sddm";

      nodes.machine = { ... }: {
        imports = [ ./common/user-account.nix ];
        services.xserver.enable = true;
        services.xserver.displayManager.sddm.enable = true;
        services.xserver.displayManager.defaultSession = "none+icewm";
        services.xserver.windowManager.icewm.enable = true;
      };

      enableOCR = true;

      testScript = { nodes, ... }: let
<<<<<<< HEAD
        user = nodes.machine.users.users.alice;
=======
        user = nodes.machine.config.users.users.alice;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      in ''
        start_all()
        machine.wait_for_text("(?i)select your user")
        machine.screenshot("sddm")
        machine.send_chars("${user.password}\n")
<<<<<<< HEAD
        machine.wait_for_file("/tmp/xauth_*")
        machine.succeed("xauth merge /tmp/xauth_*")
=======
        machine.wait_for_file("${user.home}/.Xauthority")
        machine.succeed("xauth merge ${user.home}/.Xauthority")
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        machine.wait_for_window("^IceWM ")
      '';
    };

    autoLogin = {
      name = "sddm-autologin";
      meta = with pkgs.lib.maintainers; {
        maintainers = [ ttuegel ];
      };

      nodes.machine = { ... }: {
        imports = [ ./common/user-account.nix ];
        services.xserver.enable = true;
        services.xserver.displayManager = {
          sddm.enable = true;
          autoLogin = {
            enable = true;
            user = "alice";
          };
        };
        services.xserver.displayManager.defaultSession = "none+icewm";
        services.xserver.windowManager.icewm.enable = true;
      };

<<<<<<< HEAD
      testScript = { nodes, ... }: ''
        start_all()
        machine.wait_for_file("/tmp/xauth_*")
        machine.succeed("xauth merge /tmp/xauth_*")
=======
      testScript = { nodes, ... }: let
        user = nodes.machine.config.users.users.alice;
      in ''
        start_all()
        machine.wait_for_file("${user.home}/.Xauthority")
        machine.succeed("xauth merge ${user.home}/.Xauthority")
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        machine.wait_for_window("^IceWM ")
      '';
    };
  };
in
  lib.mapAttrs (lib.const makeTest) tests
