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

      machine = { ... }: {
        imports = [ ./common/user-account.nix ];
        services.xserver.enable = true;
        services.xserver.displayManager.sddm.enable = true;
        services.xserver.displayManager.defaultSession = "none+icewm";
        services.xserver.windowManager.icewm.enable = true;
      };

      enableOCR = true;

      testScript = { nodes, ... }: let
        user = nodes.machine.config.users.users.alice;
      in ''
        start_all()
        machine.wait_for_text("(?i)select your user")
        machine.screenshot("sddm")
        machine.send_chars("${user.password}\n")
        machine.wait_for_file("${user.home}/.Xauthority")
        machine.succeed("xauth merge ${user.home}/.Xauthority")
        machine.wait_for_window("^IceWM ")
      '';
    };

    autoLogin = {
      name = "sddm-autologin";
      meta = with pkgs.stdenv.lib.maintainers; {
        maintainers = [ ttuegel ];
      };

      machine = { ... }: {
        imports = [ ./common/user-account.nix ];
        services.xserver.enable = true;
        services.xserver.displayManager.sddm = {
          enable = true;
          autoLogin = {
            enable = true;
            user = "alice";
          };
        };
        services.xserver.displayManager.defaultSession = "none+icewm";
        services.xserver.windowManager.icewm.enable = true;
      };

      testScript = { nodes, ... }: let
        user = nodes.machine.config.users.users.alice;
      in ''
        start_all()
        machine.wait_for_file("${user.home}/.Xauthority")
        machine.succeed("xauth merge ${user.home}/.Xauthority")
        machine.wait_for_window("^IceWM ")
      '';
    };
  };
in
  lib.mapAttrs (lib.const makeTest) tests
