{ pkgs, lib, ... }:

let
  port = 1234;
in
{
  name = "mollysocket";
  meta.maintainers = with lib.maintainers; [ dotlambda ];

  nodes.mollysocket =
    { ... }:
    {
      services.mollysocket = {
        enable = true;
        settings = {
          inherit port;
        };
      };
    };

  testScript = ''
    mollysocket.wait_for_unit("mollysocket.service")
    mollysocket.wait_for_open_port(${toString port})

    out = mollysocket.succeed("curl --fail http://127.0.0.1:${toString port}")
    assert "Version ${pkgs.mollysocket.version}" in out
  '';
}
