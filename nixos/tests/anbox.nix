import ./make-test-python.nix ({ pkgs, ... }:

{
  name = "anbox";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ mvnetbiz ];
  };

  machine = { pkgs, config, ... }: {
    imports = [
      ./common/user-account.nix
      ./common/x11.nix
    ];

    environment.systemPackages = with pkgs; [ android-tools ];

    test-support.displayManager.auto.user = "alice";

    virtualisation.anbox.enable = true;
    virtualisation.memorySize = 2500;
  };

  testScript = { nodes, ... }: let
    user = nodes.machine.config.users.users.alice;
    bus = "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/${toString user.uid}/bus";
  in ''
    machine.wait_for_x()

    machine.wait_until_succeeds(
        "sudo -iu alice ${bus} anbox wait-ready"
    )

    machine.wait_until_succeeds("adb shell true")

    print(machine.succeed("adb devices"))
  '';
})
