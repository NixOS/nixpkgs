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
      ${nodeName}.succeed("curl --fail http://127.0.0.1:9090")
    '';

    meta.maintainers = [ lib.maintainers.l0b0 ];
  }
)
