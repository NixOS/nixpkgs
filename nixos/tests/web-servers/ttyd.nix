import ../make-test-python.nix ({ lib, pkgs, ... }: {
  name = "ttyd";
  meta.maintainers = with lib.maintainers; [ stunkymonkey ];

  nodes.machine = { pkgs, ... }: {
    services.ttyd = {
      enable = true;
      username = "foo";
      passwordFile = pkgs.writeText "password" "bar";
    };
  };

  testScript = ''
    machine.wait_for_unit("ttyd.service")
    machine.wait_for_open_port(7681)
    response = machine.succeed("curl -vvv -u foo:bar -s -H 'Host: ttyd' http://127.0.0.1:7681/")
    assert '<title>ttyd - Terminal</title>' in response, "Page didn't load successfully"
  '';
})
