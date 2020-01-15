import ./make-test.nix ({ pkgs, ... }: {
  name = "powerdns";

  nodes.server = { ... }: {
    services.pdns-recursor.enable = true;
  };

  testScript = ''
    $server->waitForUnit("pdns-recursor");
    $server->waitForOpenPort("53");
  '';
})
