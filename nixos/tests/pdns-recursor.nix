import ./make-test.nix ({ pkgs, lib, ... }: {
  name = "powerdns";

  nodes.server = { ... }: {
    services.pdns-recursor.enable = true;
  };

  testScript = ''
    $server->waitForUnit("pdns-recursor");
    $server->succeed("echo | ${lib.getBin pkgs.netcat}/bin/nc -v localhost 53")
  '';
})
