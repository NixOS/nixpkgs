import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "mediawiki";
  meta.maintainers = [ lib.maintainers.aanderse ];

  nodes.machine =
    { ... }:
    { services.mediawiki.enable = true;
      services.mediawiki.virtualHost.hostName = "localhost";
      services.mediawiki.virtualHost.adminAddr = "root@example.com";
      services.mediawiki.passwordFile = pkgs.writeText "password" "correcthorsebatterystaple";
      services.mediawiki.extensions = {
        Matomo = pkgs.fetchzip {
          url = "https://github.com/DaSchTour/matomo-mediawiki-extension/archive/v4.0.1.tar.gz";
          sha256 = "0g5rd3zp0avwlmqagc59cg9bbkn3r7wx7p6yr80s644mj6dlvs1b";
        };
        ParserFunctions = null;
      };
    };

  testScript = ''
    start_all()

    machine.wait_for_unit("phpfpm-mediawiki.service")

    page = machine.succeed("curl -fL http://localhost/")
    assert "MediaWiki has been installed" in page
  '';
})
