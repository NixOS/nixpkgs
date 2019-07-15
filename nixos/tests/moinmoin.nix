import ./make-test.nix ({ pkgs, lib, ... }: {
  name = "moinmoin";
  meta.maintainers = [ ]; # waiting for https://github.com/NixOS/nixpkgs/pull/65397

  machine =
    { ... }:
    { services.moinmoin.enable = true;
      services.moinmoin.wikis.ExampleWiki.superUsers = [ "admin" ];
      services.moinmoin.wikis.ExampleWiki.webHost = "localhost";

      services.nginx.virtualHosts.localhost.enableACME = false;
      services.nginx.virtualHosts.localhost.forceSSL = false;
    };

  testScript = ''
    startAll;

    $machine->waitForUnit('moin-ExampleWiki.service');
    $machine->waitForUnit('nginx.service');
    $machine->waitForFile('/run/moin/ExampleWiki/gunicorn.sock');
    $machine->succeed('curl -L http://localhost/') =~ /If you have just installed/ or die;
    $machine->succeed('moin-ExampleWiki account create --name=admin --email=admin@example.com --password=foo 2>&1') =~ /status success/ or die;
  '';
})
