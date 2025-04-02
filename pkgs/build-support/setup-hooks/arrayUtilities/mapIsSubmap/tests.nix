# NOTE: Tests related to mapIsSubmap go here.
{
  lib,
  testers,
}:
let
  inherit (lib.attrsets) recurseIntoAttrs;
  inherit (testers) shellcheck shfmt;
in
recurseIntoAttrs {
  shellcheck = shellcheck {
    name = "mapIsSubmap";
    src = ./mapIsSubmap.bash;
  };

  shfmt = shfmt {
    name = "mapIsSubmap";
    src = ./mapIsSubmap.bash;
  };

  # TODO: Positive tests.

  # TODO: Negative tests.
}
