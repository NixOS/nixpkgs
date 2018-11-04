import ./make-test.nix ({ pkgs, ... } : {

  name = "mxisd";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ mguentner ];
  };

  nodes = {
    server_mxisd = args : {
      services.mxisd.enable = true;
    };
  };

  testScript = ''
    startAll;
    $server_mxisd->waitForUnit("mxisd.service");
    $server_mxisd->waitUntilSucceeds("curl \"http://127.0.0.1:8090/_matrix/identity/api/v1\"");
    $server_mxisd->succeed("curl \"http://127.0.0.1:8090/_matrix/identity/api/v1\"")
  '';
})
