import ../../make-test-python.nix (
  { lib, ... }:
  let
    nodeName = "server";
  in
  {
    name = "linkding-defaults";

    nodes."${nodeName}" = {
      services.linkding.enable = true;
    };

    testScript = ''
      ${nodeName}.wait_for_unit("linkding.service")
    '';

    meta.maintainers = [ lib.maintainers.l0b0 ];
  }
)
