import ./make-test.nix ({ pkgs, ... }: {
  name = "limesurvey";
  meta.maintainers = [ pkgs.stdenv.lib.maintainers.aanderse ];

  machine =
    { ... }:
    { services.limesurvey.enable = true;
      services.limesurvey.virtualHost.hostName = "example.local";
      services.limesurvey.virtualHost.adminAddr = "root@example.local";

      # limesurvey won't work without a dot in the hostname
      networking.hosts."127.0.0.1" = [ "example.local" ];
    };

  testScript = ''
    startAll;

    $machine->waitForUnit('phpfpm-limesurvey.service');
    $machine->succeed('curl http://example.local/') =~ /The following surveys are available/ or die;
  '';
})
