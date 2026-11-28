{ pkgs, ... }:
{
  name = "menuLayout";
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
      boot.loader.limine.expandGenerations = false;
      boot.loader.limine.extraEntriesPosition = "beforeGenerations";
      boot.loader.limine.extraEntries = ''
        /Extra entry
            protocol: efi
            path: boot():/EFI/extra.efi
      '';
      boot.loader.timeout = 0;
    };

  testScript = /* python */ ''
    machine.start()
    with subtest('Machine boots correctly'):
      machine.wait_for_unit('multi-user.target')

    with subtest('Generation folder starts collapsed'):
      machine.succeed("grep -x '/NixOS generations' /boot/limine/limine.conf")
      machine.fail("grep -F '/+NixOS generations' /boot/limine/limine.conf")

    with subtest('Extra entries come before the generation folder'):
      extra = int(machine.succeed("grep -nx '/Extra entry' /boot/limine/limine.conf | cut -d: -f1"))
      gens = int(machine.succeed("grep -nx '/NixOS generations' /boot/limine/limine.conf | cut -d: -f1"))
      assert extra < gens, f"extra entry on line {extra}, generations on line {gens}"
  '';
}
