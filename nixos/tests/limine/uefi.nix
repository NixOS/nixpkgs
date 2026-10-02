{ lib, pkgs, ... }:
{
  name = "uefi";
  meta = {
    inherit (pkgs.limine.meta) maintainers;
  };

  nodes.machine =
    { ... }:
    {
      virtualisation.useBootLoader = true;
      virtualisation.useEFIBoot = true;
      virtualisation.efi.keepVariables = true;

      boot.loader.efi.canTouchEfiVariables = true;
      boot.loader.limine.enable = true;
      boot.loader.limine.efiSupport = true;
      boot.loader.limine.extraConfig = "remember_last_entry: yes";
      boot.loader.timeout = 0;

      specialisation.updated.configuration = {
        environment.etc."stable-current-marker".text = "updated";
      };
    };

  testScript =
    { nodes, ... }:
    let
      originalSystem = nodes.machine.system.build.toplevel;
      updatedSystem = nodes.machine.specialisation.updated.configuration.system.build.toplevel;
    in
    ''
      machine.start(allow_reboot=True)
      with subtest('Machine boots correctly'):
        machine.wait_for_unit('multi-user.target')

      with subtest('A stable current-system entry is generated'):
        machine.succeed("grep -x '/NixOS' /boot/limine/limine.conf")
        machine.succeed("grep -x '/+NixOS default profile' /boot/limine/limine.conf")
        machine.succeed("grep -x 'default_entry: 1' /boot/limine/limine.conf")
        machine.succeed("grep -A8 -x '/NixOS' /boot/limine/limine.conf | grep -F 'init=${originalSystem}/init'")

      with subtest('The stable entry follows the configuration being installed'):
        machine.succeed("${updatedSystem}/bin/switch-to-configuration boot")
        machine.succeed("grep -A8 -x '/NixOS' /boot/limine/limine.conf | grep -F 'init=${updatedSystem}/init'")
        machine.succeed("grep -x '/+NixOS default profile' /boot/limine/limine.conf")

      with subtest('remember_last_entry resolves the stable entry after its payload changes'):
        machine.reboot()
        machine.wait_for_unit('multi-user.target')
        machine.succeed("grep -x updated /etc/stable-current-marker")
    '';
}
