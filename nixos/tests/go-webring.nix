{ pkgs, ... }:

let
  port = 3142;
in
{
  name = "go-webring";
  meta.maintainers = pkgs.go-webring.meta.maintainers;

  nodes = {
    machine =
      { ... }:
      {
        services.go-webring = {
          enable = true;
          listenAddress = "127.0.0.1:${toString port}";
          homePageTemplate = pkgs.writeText "index.html" ''
            <html>
            <head><title>My Webring</title></head>
            <body>
            <h1>My Webring</h1>
            {{ . }}
            </body>
            </html>
          '';
          host = "localhost";
          members = [
            {
              username = "sam";
              site = "sometilde.com/~sam";
            }
            {
              username = "bob";
              site = "bobssite.com";
            }
          ];
        };
      };
  };
  testScript = ''
    start_all()
    machine.wait_for_unit("go-webring.service")
    machine.wait_for_open_port(${toString port})
    machine.succeed("curl --fail 'http://localhost:${toString port}/' | grep 'My Webring'")
  '';
}
