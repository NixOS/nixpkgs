{ lib, pkgs, ... }:

{
  name = "anbox";
  meta.maintainers = with lib.maintainers; [ mvnetbiz ];

  nodes.machine =
    { pkgs, config, ... }:
    {
      imports = [
        ./common/user-account.nix
        ./common/x11.nix
      ];

      environment.systemPackages = with pkgs; [ android-tools ];

      test-support.displayManager.auto.user = "alice";

      virtualisation.anbox.enable = true;
      boot.kernelPackages = pkgs.linuxKernel.packages.linux_5_15;
      virtualisation.memorySize = 2500;
    };

  testScript =
    { nodes, ... }:
    let
      user = nodes.machine.users.users.alice;
      bus = "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/${toString user.uid}/bus";
    in
    ''
      machine.wait_for_x()

      machine.wait_until_succeeds(
          "sudo -iu alice ${bus} anbox wait-ready"
      )

      machine.wait_until_succeeds("adb shell true")

      print(machine.succeed("adb devices"))
    '';
}
