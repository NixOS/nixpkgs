{ lib, pkgs, ... }:
{
  name = "nginx-mime";
  meta.maintainers = with pkgs.lib.maintainers; [ izorkin ];

  nodes = {
    server =
      { pkgs, ... }:
      {
        services.nginx = {
          enable = true;
          virtualHosts."localhost" = { };
        };
      };
  };

  testScript = ''
    server.start()
    server.wait_for_unit("nginx")
    # Check optimal size of types_hash
    server.fail("journalctl --unit nginx --grep 'could not build optimal types_hash'")
    server.shutdown()
  '';
}
