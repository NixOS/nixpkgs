import ./make-test-python.nix ({ pkgs, ... }: {
  name = "nginx-sso";
  meta = {
    maintainers = with pkgs.lib.maintainers; [ ambroisie ];
  };

  nodes.machine = {
    services.nginx.sso = {
      enable = true;
      configuration = {
        listen = { addr = "127.0.0.1"; port = 8080; };

        providers.token.tokens = {
          myuser = "MyToken";
        };

        acl = {
          rule_sets = [
            {
              rules = [ { field = "x-application"; equals = "MyApp"; } ];
              allow = [ "myuser" ];
            }
          ];
        };
      };
    };
  };

  testScript = ''
    start_all()

    machine.wait_for_unit("nginx-sso.service")
    machine.wait_for_open_port(8080)

    with subtest("No valid user -> 401"):
        machine.fail("curl -sSf http://localhost:8080/auth")

    with subtest("Valid user but no matching ACL -> 403"):
        machine.fail(
            "curl -sSf -H 'Authorization: Token MyToken' http://localhost:8080/auth"
        )

    with subtest("Valid user and matching ACL -> 200"):
        machine.succeed(
            "curl -sSf -H 'Authorization: Token MyToken' -H 'X-Application: MyApp' http://localhost:8080/auth"
        )
  '';
})
