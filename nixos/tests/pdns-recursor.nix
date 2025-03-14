import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "powerdns-recursor";

    nodes.server =
      { ... }:
      {
        services.pdns-recursor.enable = true;
        services.pdns-recursor.exportHosts = true;
        networking.hosts."192.0.2.1" = [ "example.com" ];
      };

    testScript = ''
      server.wait_for_unit("pdns-recursor")
      server.wait_for_open_port(53)
      assert "192.0.2.1" in server.succeed("host example.com localhost")
    '';
  }
)
