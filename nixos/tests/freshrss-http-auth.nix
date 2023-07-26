import ./make-test-python.nix ({ lib, pkgs, ... }: {
  name = "freshrss";
  meta.maintainers = with lib.maintainers; [ mattchrist ];

  nodes.machine = { pkgs, ... }: {
    services.freshrss = {
      enable = true;
      baseUrl = "http://localhost";
      dataDir = "/srv/freshrss";
      authType = "http_auth";
    };
  };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.wait_for_open_port(80)
    response = machine.succeed("curl -vvv -s -H 'Host: freshrss' -H 'Remote-User: testuser' http://127.0.0.1:80/i/")
    assert 'Account: testuser' in response, "http_auth method didn't work."
  '';
})
