import ./make-test-python.nix ({ pkgs, lib, ... }: {
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
    start_all()

    machine.wait_for_unit("phpfpm-mediawiki.service")

    page = machine.succeed("curl -L http://localhost/")
    assert "MediaWiki has been installed" in page
  '';
})
