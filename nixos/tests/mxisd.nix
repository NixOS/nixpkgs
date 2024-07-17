import ./make-test-python.nix (
  { pkgs, ... }:
  {

    name = "mxisd";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ mguentner ];
    };

    nodes = {
      server = args: {
        services.mxisd.enable = true;
        services.mxisd.matrix.domain = "example.org";
      };
    };

    testScript = ''
      start_all()
      server.wait_for_unit("mxisd.service")
      server.wait_for_open_port(8090)
      server.succeed("curl -Ssf 'http://127.0.0.1:8090/_matrix/identity/api/v1'")
    '';
  }
)
