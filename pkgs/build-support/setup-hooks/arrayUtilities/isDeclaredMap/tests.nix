# NOTE: Tests related to isDeclaredMap go here.
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
    name = "isDeclaredMap";
    src = ./isDeclaredMap.bash;
  };

  shfmt = shfmt {
    name = "isDeclaredMap";
    src = ./isDeclaredMap.bash;
  };

  # TODO: Positive tests.

  # TODO: Negative tests.
}
