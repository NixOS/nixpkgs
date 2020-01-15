import ./make-test.nix ({ pkgs, lib, ... }: {
  name = "mediawiki";
  meta.maintainers = [ lib.maintainers.aanderse ];

  machine =
    { ... }:
    { services.mediawiki.enable = true;
      services.mediawiki.virtualHost.hostName = "localhost";
      services.mediawiki.virtualHost.adminAddr = "root@example.com";
      services.mediawiki.passwordFile = pkgs.writeText "password" "correcthorsebatterystaple";
    };

  testScript = ''
    startAll;

    $machine->waitForUnit('phpfpm-mediawiki.service');
    $machine->succeed('curl -L http://localhost/') =~ /MediaWiki has been installed/ or die;
  '';
})
