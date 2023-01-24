import ./make-test-python.nix ({ lib, ... }: {
  name = "limine";
  meta = with lib.maintainers; {
    maintainers = [ czapek ];
  };

  nodes.machine = { ... }: {
    virtualisation.useBootLoader = true;
    virtualisation.useEFIBoot = true;

    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.limine.enable = true;
    boot.loader.timeout = 0;
  };

  testScript = ''
    machine.start()

    with subtest('Machine boots correctly'):
      machine.wait_for_unit('multi-user.target')
  '';
})
