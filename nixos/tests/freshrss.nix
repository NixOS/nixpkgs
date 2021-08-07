import ./make-test-python.nix ({ lib, pkgs, ... }: {
  name = "freshrss";
  meta.maintainers = with lib.maintainers; [ etu ];

  machine = { ... }: {
    services.freshrss.enable = true;
  };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.wait_for_open_port(80)

    response = machine.succeed("curl -vvv -s -H 'Host: freshrss' http://127.0.0.1:80/")
    assert "<title>FreshRSS</title>" in response, "Title not found on page"
    assert '<meta http-equiv="Refresh" content="0; url=i/" />' in response, "Redirect to install not found on page"

    response = machine.succeed("curl -vvv -s -H 'Host: freshrss' http://127.0.0.1:80/i/")
    assert '<title>Installation · FreshRSS</title>' in response, "Installation page didn't load successfully"
  '';
})
