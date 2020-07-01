import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "moinmoin";
  meta.maintainers = with lib.maintainers; [ mmilata ];

  machine =
    { ... }:
    { services.moinmoin.enable = true;
      services.moinmoin.wikis.ExampleWiki.superUsers = [ "admin" ];
      services.moinmoin.wikis.ExampleWiki.webHost = "localhost";

      services.nginx.virtualHosts.localhost.enableACME = false;
      services.nginx.virtualHosts.localhost.forceSSL = false;
    };

  testScript = ''
    start_all()

    machine.wait_for_unit("moin-ExampleWiki.service")
    machine.wait_for_unit("nginx.service")
    machine.wait_for_file("/run/moin/ExampleWiki/gunicorn.sock")

    assert "If you have just installed" in machine.succeed("curl -L http://localhost/")

    assert "status success" in machine.succeed(
        "moin-ExampleWiki account create --name=admin --email=admin@example.com --password=foo 2>&1"
    )
  '';
})
