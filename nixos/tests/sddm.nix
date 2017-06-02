{ system ? builtins.currentSystem }:

with import ../lib/testing.nix { inherit system; };

let
  inherit (pkgs) lib;

  tests = {
    default = {
      name = "sddm";

      machine = { lib, ... }: {
        imports = [ ./common/user-account.nix ];
        services.xserver.displayManager.select = "sddm";
        services.xserver.windowManager.select = [ "icewm" ];
      };

      enableOCR = true;

      testScript = { nodes, ... }: let
        user = nodes.machine.config.users.extraUsers.alice;
      in ''
        startAll;
        $machine->waitForText(qr/ALICE/);
        $machine->screenshot("sddm");
        $machine->sendChars("${user.password}\n");
        $machine->waitForFile("/home/alice/.Xauthority");
        $machine->succeed("xauth merge ~alice/.Xauthority");
        $machine->waitForWindow("^IceWM ");
      '';
    };

    autoLogin = {
      name = "sddm-autologin";
      meta = with pkgs.stdenv.lib.maintainers; {
        maintainers = [ ttuegel ];
      };

      machine = { lib, ... }: {
        imports = [ ./common/user-account.nix ];
        services.xserver.displayManager.select = "sddm";
        services.xserver.windowManager.select = [ "icewm" ];
        services.xserver.displayManager.sddm = {
          autoLogin = {
            enable = true;
            user = "alice";
          };
        };
      };

      testScript = { nodes, ... }: ''
        startAll;
        $machine->waitForFile("/home/alice/.Xauthority");
        $machine->succeed("xauth merge ~alice/.Xauthority");
        $machine->waitForWindow("^IceWM ");
      '';
    };
  };
in
  lib.mapAttrs (lib.const makeTest) tests
