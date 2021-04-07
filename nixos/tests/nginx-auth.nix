import ./make-test-python.nix ({ pkgs, ... }: {
  name = "nginx-auth";

  nodes = {
    webserver = { pkgs, lib, ... }: {
      services.nginx = let
        root = pkgs.runCommand "testdir" {} ''
          mkdir "$out"
          echo hello world > "$out/index.html"
        '';
      in {
        enable = true;

        virtualHosts.lockedroot = {
          inherit root;
          basicAuth.alice = "jane";
        };

        virtualHosts.lockedsubdir = {
          inherit root;
          locations."/sublocation/" = {
            alias = "${root}/";
            basicAuth.bob = "john";
          };
        };
      };
    };
  };

  testScript = ''
    webserver.wait_for_unit("nginx")
    webserver.wait_for_open_port(80)

    webserver.fail("curl --fail --resolve lockedroot:80:127.0.0.1 http://lockedroot")
    webserver.succeed(
        "curl --fail --resolve lockedroot:80:127.0.0.1 http://alice:jane@lockedroot"
    )

    webserver.succeed("curl --fail --resolve lockedsubdir:80:127.0.0.1 http://lockedsubdir")
    webserver.fail(
        "curl --fail --resolve lockedsubdir:80:127.0.0.1 http://lockedsubdir/sublocation/index.html"
    )
    webserver.succeed(
        "curl --fail --resolve lockedsubdir:80:127.0.0.1 http://bob:john@lockedsubdir/sublocation/index.html"
    )
  '';
})
