import ./make-test-python.nix ({ lib, ... }:
{
  name = "chrony";

  meta = {
    maintainers = with lib.maintainers; [ fpletz ];
  };

  nodes = {
    machine = {
      services.chrony.enable = true;

      specialisation.hardened.configuration = {
        services.chrony.enableMemoryLocking = true;
        environment.memoryAllocator.provider = "graphene-hardened";
        # dhcpcd privsep is incompatible with graphene-hardened
        networking.useNetworkd = true;
      };
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
})
