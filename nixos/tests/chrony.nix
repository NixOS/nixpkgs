{
  name = "chrony";

  nodes.machine = {
    services.chrony.enable = true;

    specialisation.hardened.configuration = {
      environment.memoryAllocator.provider = "graphene-hardened";
    };
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit('multi-user.target')
    machine.succeed('systemctl is-active chronyd.service')
    machine.succeed('/run/booted-system/specialisation/hardened/bin/switch-to-configuration test')
    machine.succeed('systemctl restart chronyd.service')
    machine.wait_for_unit('chronyd.service')
  '';
}
