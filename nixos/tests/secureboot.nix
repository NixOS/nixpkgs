{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

let
  common = {
    virtualisation.useBootLoader = true;
    virtualisation.useEFIBoot = true;
    virtualisation.useSecureBoot = true;
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    environment.systemPackages = [ pkgs.efibootmgr pkgs.sbsigntool pkgs.sbctl ];
  };
in
{
  basic = makeTest {
    name = "secureboot-installation-prevent-reboot";
    meta.maintainers = with pkgs.lib.maintainers; [ raitobezarius ];

    nodes.machine = common;

    testScript = ''
      machine.start()
      machine.wait_for_unit("multi-user.target")

      machine.succeed("sbctl create-keys")
      machine.succeed("sbctl enroll-keys --yes-this-might-brick-my-machine")
      machine.shutdown()
      # Now we cannot reboot because we did not sign our boot files!
      # machine.sleep(1)
      # Test for Linux Boot Manager
      # assert ('Not Found' in machine.get_screen_text())
    '';
  };
}
