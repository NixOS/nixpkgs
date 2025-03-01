# NOTE: Tests related to occursInArray go here.
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
    name = "occursInArray";
    src = ./occursInArray.bash;
  };

  shfmt = shfmt {
    name = "occursInArray";
    src = ./occursInArray.bash;
  };

  # TODO: Positive tests.

  # TODO: Negative tests.
}
