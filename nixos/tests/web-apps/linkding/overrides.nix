import ../../make-test-python.nix (
  { lib, ... }:
  let
    nodeName = "server";
  in
  {
    name = "linkding-overrides";

    nodes."${nodeName}" =
      {
        pkgs,
        ...
      }:
      {
        services.linkding = {
          enable = true;
          package = pkgs.linkding.overrideAttrs (_old: {
            name = "custom-linkding";
          });
          host = "127.0.0.2";
          port = 8000;
        };
      };

    testScript = ''
      ${nodeName}.wait_for_unit("linkding.service")
      ${nodeName}.succeed("curl --fail http://127.0.0.2:8000")
    '';

    meta.maintainers = [ lib.maintainers.l0b0 ];
  }
)
