import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "moodle";
  meta.maintainers = [ lib.maintainers.aanderse ];

  nodes.machine =
    { ... }:
    { services.moodle.enable = true;
      services.moodle.virtualHost.hostName = "localhost";
      services.moodle.virtualHost.adminAddr = "root@example.com";
      services.moodle.initialPassword = "correcthorsebatterystaple";

      # Ensure the virtual machine has enough memory to avoid errors like:
      # Fatal error: Out of memory (allocated 152047616) (tried to allocate 33554440 bytes)
      virtualisation.memorySize = 2000;
    };

  testScript = ''
    start_all()
    machine.wait_for_unit("phpfpm-moodle.service", timeout=1800)
    machine.wait_until_succeeds("curl http://localhost/ | grep 'You are not logged in'")
  '';
})
