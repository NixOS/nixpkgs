import ./make-test.nix ({ pkgs, lib, ... }: {
  name = "moodle";
  meta.maintainers = [ lib.maintainers.aanderse ];

  machine =
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
    startAll;
    $machine->waitForUnit('phpfpm-moodle.service');
    $machine->succeed('curl http://localhost/') =~ /You are not logged in/ or die;
  '';
})
