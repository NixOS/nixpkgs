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
        services.displayManager.sddm.enable = true;
        services.displayManager.defaultSession = "none+icewm";
        services.xserver.windowManager.icewm.enable = true;
      };

      enableOCR = true;

      testScript = { nodes, ... }: let
        user = nodes.machine.users.users.alice;
      in ''
        start_all()
        machine.wait_for_text("(?i)select your user")
        machine.screenshot("sddm")
        machine.send_chars("${user.password}\n")
        machine.wait_for_file("/tmp/xauth_*")
        machine.succeed("xauth merge /tmp/xauth_*")
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
        services.displayManager = {
          sddm.enable = true;
          autoLogin = {
            enable = true;
            user = "alice";
          };
        };
        services.displayManager.defaultSession = "none+icewm";
        services.xserver.windowManager.icewm.enable = true;
      };

      testScript = { nodes, ... }: ''
        start_all()
        machine.wait_for_file("/tmp/xauth_*")
        machine.succeed("xauth merge /tmp/xauth_*")
        machine.wait_for_window("^IceWM ")
      '';
    };
  };
in
  lib.mapAttrs (lib.const makeTest) tests
