{ lib, pkgs, ... }:
{
  name = "refindspecialisations";
  meta = {
    inherit (pkgs.limine.meta) maintainers;
  };

  nodes.machine =
    { ... }:
    {
      virtualisation.useBootLoader = true;
      virtualisation.useEFIBoot = true;

      specialisation.test = { };

      boot.loader.grub.enable = false;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.loader.refind.enable = true;
      boot.loader.timeout = 1;
    };

  testScript = ''
    machine.start()
    with subtest('Machine boots correctly'):
      machine.wait_for_unit('multi-user.target')
  '';
}
