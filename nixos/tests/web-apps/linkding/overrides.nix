import ../../make-test-python.nix (
  { lib, ... }:
  let
    nodeName = "server";
  in
  {
    name = "linkding-overrides";

    nodes."${nodeName}" =
      {
        options,
        pkgs,
        ...
      }:
      {
        services.linkding = {
          dataDir = "/tmp/linkding";
          enable = true;
          package = pkgs.linkding.overrideAttrs (_old: {
            name = "custom-linkding";
          });
          port = options.services.linkding.port.default + 1;
        };
      };

    testScript = ''
      ${nodeName}.wait_for_unit("linkding.service")
    '';

    meta.maintainers = [ lib.maintainers.l0b0 ];
  }
)
