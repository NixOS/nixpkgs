import ../../make-test-python.nix ({pkgs, ...}:
{
  name = "pixelfed-standard";
  meta.maintainers = with pkgs.lib.maintainers; [ raitobezarius ];

  nodes = {
    server = { pkgs, ... }: {
      services.pixelfed = {
        enable = true;
        domain = "pixelfed.local";
        # Configure NGINX.
        nginx = {};
        secretFile = (pkgs.writeText "secrets.env" ''
          # Snakeoil secret, can be any random 32-chars secret via CSPRNG.
          APP_KEY=adKK9EcY8Hcj3PLU7rzG9rJ6KKTOtYfA
        '');
        settings."FORCE_HTTPS_URLS" = false;
      };
    };
  };

  testScript = ''
    # Wait for Pixelfed PHP pool
    server.wait_for_unit("phpfpm-pixelfed.service")
    # Wait for NGINX
    server.wait_for_unit("nginx.service")
    # Wait for HTTP port
    server.wait_for_open_port(80)
    # Access the homepage.
    server.succeed("curl -H 'Host: pixelfed.local' http://localhost")
    # Create an account
    server.succeed("pixelfed-manage user:create --name=test --username=test --email=test@test.com --password=test")
    # Create a OAuth token.
    # TODO: figure out how to use it to send a image/toot
    # server.succeed("pixelfed-manage passport:client --personal")
    # server.succeed("curl -H 'Host: pixefed.local' -H 'Accept: application/json' -H 'Authorization: Bearer secret' -F'status'='test' http://localhost/api/v1/statuses")
  '';
})
