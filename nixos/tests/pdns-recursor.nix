import ./make-test-python.nix ({ pkgs, ... }: {
  name = "powerdns";

  nodes.server = { ... }: {
    services.pdns-recursor.enable = true;
  };

  testScript = ''
    server.wait_for_unit("pdns-recursor")
    server.wait_for_open_port("53")
  '';
})
