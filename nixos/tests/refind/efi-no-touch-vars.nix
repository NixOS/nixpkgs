{ lib, pkgs, ... }:
{
  name = "refind-efi-no-touch-vars";
  meta = {
    inherit (pkgs.refind.meta) maintainers;
  };

  nodes.machine =
    { ... }:
    {
      virtualisation.useBootLoader = true;
      virtualisation.useEFIBoot = true;

      boot.loader.grub.enable = false;
      boot.loader.efi.canTouchEfiVariables = false;
      boot.loader.refind.enable = true;
      boot.loader.timeout = 1;
    };

  testScript = ''
    machine.start()
    with subtest('Machine boots correctly'):
      machine.wait_for_unit('multi-user.target')
  '';
}
