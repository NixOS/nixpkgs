import ./make-test-python.nix ({ pkgs, ... } : {

  name = "mxisd";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ mguentner ];
  };

  nodes = {
    server_mxisd = args : {
      services.mxisd.enable = true;
      services.mxisd.matrix.domain = "example.org";
    };

    server_ma1sd = args : {
      services.mxisd.enable = true;
      services.mxisd.matrix.domain = "example.org";
      services.mxisd.package = pkgs.ma1sd;
    };
  };

  testScript = ''
    start_all()
    server_mxisd.wait_for_unit("mxisd.service")
    server_mxisd.wait_for_open_port(8090)
    server_mxisd.succeed("curl -Ssf 'http://127.0.0.1:8090/_matrix/identity/api/v1'")
    server_ma1sd.wait_for_unit("mxisd.service")
    server_ma1sd.wait_for_open_port(8090)
    server_ma1sd.succeed("curl -Ssf 'http://127.0.0.1:8090/_matrix/identity/api/v1'")
  '';
})
