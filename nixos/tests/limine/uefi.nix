{ lib, ... }:
{
  name = "uefi";
  meta.maintainers = with lib.maintainers; [
    lzcunt
    phip1611
    programmerlexi
  ];
  meta.platforms = [
    "aarch64-linux"
    "i686-linux"
    "x86_64-linux"
  ];
  nodes.machine =
    { ... }:
    {
      virtualisation.useBootLoader = true;
      virtualisation.useEFIBoot = true;

      boot.loader.efi.canTouchEfiVariables = true;
      boot.loader.limine.enable = true;
      boot.loader.limine.efiSupport = true;
      boot.loader.timeout = 0;
    };

  testScript = ''
    machine.start()
    with subtest('Machine boots correctly'):
      machine.wait_for_unit('multi-user.target')
  '';
}
