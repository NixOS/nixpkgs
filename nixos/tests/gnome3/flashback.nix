# GNOME Flashback Terminal tests for various custom sessions.

{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../../.. { inherit system config; }
}:

with import ../../lib/testing.nix { inherit system pkgs; };
with pkgs.lib;

let

  baseConfig = {
    imports = [ ../common/user-account.nix ];

    services.xserver.enable = true;

    # See: https://github.com/NixOS/nixpkgs/issues/66443
    services.xserver.displayManager.gdm.enable = false;
    services.xserver.displayManager.lightdm.enable = true;
    services.xserver.displayManager.lightdm.autoLogin.enable = true;
    services.xserver.displayManager.lightdm.autoLogin.user = "alice";
    services.xserver.desktopManager.gnome3.enable = true;

    virtualisation.memorySize = 2047;
  };

  makeFlashbackTest =
    { wmName
    , wmLabel ? ""
    , wmCommand ? ""
    , useMetacity ? false
    }:
    makeTest rec {
      name = "gnome-flashback-${wmName}";

      meta = with pkgs.stdenv.lib.maintainers; {
        maintainers = pkgs.gnome3.maintainers;
      };

      machine = { ... }: {
        imports = [ baseConfig ];

        services.xserver.desktopManager.default = "gnome-flashback-${wmName}";

        services.xserver.desktopManager.gnome3.flashback = {
          enableMetacity = useMetacity;

          customSessions = mkIf (!useMetacity) [
            { inherit wmName wmLabel wmCommand; }
          ];
        };

      };

      testScript =
        ''
          $machine->waitForX;

          # wait for alice to be logged in
          $machine->waitForUnit("default.target","alice");

          # Check that logging in has given the user ownership of devices.
          $machine->succeed("getfacl -p /dev/snd/timer | grep -q alice");

          $machine->succeed("su - alice -c 'DISPLAY=:0.0 gnome-terminal &'");
          $machine->succeed("xauth merge ~alice/.Xauthority");
          $machine->waitForWindow(qr/alice.*machine/);
          $machine->succeed("timeout 900 bash -c 'while read msg; do if [[ \$msg =~ \"GNOME Shell started\" ]]; then break; fi; done < <(journalctl -f)'");
          $machine->sleep(10);
          $machine->screenshot("screen");
      '';
    };

in

{

  metacity = makeFlashbackTest {
    useMetacity = true;
    wmName = "metacity";
  };

  # TODO: These are currently broken with gnome-session 3.34
  # See: https://github.com/NixOS/nixpkgs/pull/71212#issuecomment-544303107
  # i3 = makeFlashbackTest {
  #   wmName = "i3";
  #   wmLabel = "i3";
  #   wmCommand = "${pkgs.i3}/bin/i3";
  # };

  # xmonad = makeFlashbackTest {
  #   wmName = "xmonad";
  #   wmLabel = "XMonad";
  #   wmCommand = "${pkgs.haskellPackages.xmonad}/bin/xmonad";
  # };

}
