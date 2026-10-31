{
  lib,
  mkPackage ? builtins.getAttr "nginx",
  name ? "default",
  ...
}:
{
  name = "nginx-mime-${name}";
  meta.maintainers = with lib.maintainers; [ izorkin ];

  nodes = {
    server =
      { pkgs, ... }:
      {
        services.nginx = {
          enable = true;
          package = mkPackage pkgs;
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
