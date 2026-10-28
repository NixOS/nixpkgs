{ pkgs, lib, ... }:
{
  name = "local-content-share";
  meta.maintainers = pkgs.local-content-share.meta.maintainers;

  nodes.machine =
    { pkgs, ... }:
    {
      services.local-content-share = {
        enable = true;
        port = 8081;
      };
    };

  testScript =
    { nodes, ... }:
    let
      cfg = nodes.machine.services.local-content-share;
    in
    ''
      machine.wait_for_unit("local-content-share.service")
      machine.wait_for_open_port(${toString cfg.port})
      machine.wait_until_succeeds("curl -sS -f http://127.0.0.1:${toString cfg.port}/", timeout=300)
    '';
}
