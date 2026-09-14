{ lib, ... }:

{
  name = "musivault";

  nodes = {
    machine =
      { pkgs, ... }:
      {
        services.musivault = {
          enable = true;
          enableLocalDB = true;
          environment = {
            SESSION_SECRET = "test_session_secret";
            JWT_SECRET = "test_jwt_secret";
            DISCOGS_KEY = "test_key";
            DISCOGS_SECRET = "test_secret";
          };
        };
      };
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("musivault.service")
    machine.wait_for_open_port(5001)
  '';

  meta.maintainers = with lib.maintainers; [ tomhesse ];
}
