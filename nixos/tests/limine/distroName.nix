{ pkgs, ... }:
{
  name = "distroName";
  meta = {
    inherit (pkgs.limine.meta) maintainers;
  };

  nodes.machine =
    { ... }:
    {
      virtualisation.useBootLoader = true;
      virtualisation.useEFIBoot = true;

      boot.loader.efi.canTouchEfiVariables = true;
      boot.loader.limine.enable = true;
      boot.loader.limine.efiSupport = true;
      boot.loader.timeout = 0;

      system.nixos.distroName = "BestDistroEver";
    };

  testScript = /* python */ ''
    machine.start()
    with subtest('Machine boots correctly'):
      machine.wait_for_unit('multi-user.target')

    machine.succeed("grep \"BestDistroEver\" /boot/limine/limine.conf")
    machine.fail("grep \"NixOS\" /boot/limine/limine.conf")
  '';
}
