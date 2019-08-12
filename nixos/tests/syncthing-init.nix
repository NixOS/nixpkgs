import ./make-test.nix ({ lib, pkgs, ... }: let

  testId = "7CFNTQM-IMTJBHJ-3UWRDIU-ZGQJFR6-VCXZ3NB-XUH3KZO-N52ITXR-LAIYUAU";

in {
  name = "syncthing-init";
  meta.maintainers = with pkgs.stdenv.lib.maintainers; [ lassulus ];

  machine = {
    services.syncthing = {
      enable = true;
      declarative = {
        devices.testDevice = {
          id = testId;
        };
        folders.testFolder = {
          path = "/tmp/test";
          devices = [ "testDevice" ];
        };
      };
    };
  };

  testScript = ''
    my $config;

    $machine->waitForUnit("syncthing-init.service");
    $config = $machine->succeed("cat /var/lib/syncthing/.config/syncthing/config.xml");
   
    $config =~ /${testId}/ or die;
    $config =~ /testFolder/ or die;
  '';
})

