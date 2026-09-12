{ lib, ... }: {
  name = "whisparr-eros";
  meta.maintainers = with lib.maintainers; [ connor-grady ];

  nodes.machine = { pkgs, ... }: {
    services.whisparr = {
      enable = true;
      package = pkgs.whisparr-eros;
    };
  };

  testScript =
    { nodes, ... }:
    let
      cfg = nodes.machine.services.whisparr;
    in
    ''
      machine.wait_for_unit("whisparr.service")
      machine.wait_for_open_port(${toString cfg.settings.server.port})
      machine.wait_until_succeeds("curl --fail http://localhost:${toString cfg.settings.server.port}/")
    '';
}
