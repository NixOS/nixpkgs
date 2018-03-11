import ./make-test.nix ({ pkgs, ... }: {
  name = "powerdns";

  nodes.server = { config, pkgs, ... }: {
    services.powerdns.enable = true;
  };

  testScript = ''
    $server->waitForUnit("pdns");
    $server->succeed("${pkgs.dnsutils}/bin/dig version.bind txt chaos \@127.0.0.1");
  '';
})
