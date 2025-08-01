{ pkgs, lib, ... }:
{
  name = "static-web-server";
  meta = {
    maintainers = with lib.maintainers; [ mac-chaffee ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
      services.static-web-server = {
        enable = true;
        listen = "[::]:8080";
        root = toString (
          pkgs.writeTextDir "nixos-test.html" ''
            <h1>Hello NixOS!</h1>
          ''
        );
        configuration = {
          general = {
            directory-listing = true;
          };
        };
      };
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("static-web-server.socket")
    machine.wait_for_open_port(8080)
    # We don't use wait_until_succeeds() because we're testing socket
    # activation which better work on the first request
    response = machine.succeed("curl -fsS localhost:8080")
    assert "nixos-test.html" in response, "The directory listing page did not include a link to our nixos-test.html file"
    response = machine.succeed("curl -fsS localhost:8080/nixos-test.html")
    assert "Hello NixOS!" in response
    machine.wait_for_unit("static-web-server.service")
  '';
}
