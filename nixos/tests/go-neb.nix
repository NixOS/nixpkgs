import ./make-test-python.nix ({ pkgs, ... }:
{
  name = "go-neb";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ hexa maralorn ];
  };

  nodes = {
    server = {
      services.go-neb = {
        enable = true;
        baseUrl = "http://localhost";
        config = {
          clients = [ {
            UserId = "@test:localhost";
            AccessToken = "changeme";
            HomeServerUrl = "http://localhost";
            Sync = false;
            AutoJoinRooms = false;
            DisplayName = "neverbeseen";
          } ];
          services = [ {
            ID = "wikipedia_service";
            Type = "wikipedia";
            UserID = "@test:localhost";
            Config = { };
          } ];
        };
      };
    };
  };

  testScript = ''
    start_all()
    server.wait_for_unit("go-neb.service")
    server.wait_until_succeeds(
        "curl -L http://localhost:4050/services/hooks/d2lraXBlZGlhX3NlcnZpY2U"
    )
    server.wait_until_succeeds(
        "journalctl -eu go-neb -o cat | grep -q service_id=wikipedia_service"
    )
  '';

})
