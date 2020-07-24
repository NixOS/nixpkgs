import ./make-test-python.nix ({ pkgs, ... }: {
  name = "powerdns";

  nodes.server = { ... }: {
    services.powerdns.enable = true;
    environment.systemPackages = [ pkgs.dnsutils ];
  };

  testScript = ''
    server.wait_for_unit("pdns")
    server.succeed("dig version.bind txt chaos \@127.0.0.1")
  '';
})
