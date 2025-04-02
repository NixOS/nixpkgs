# NOTE: Tests related to occursOnlyOrAfterInArray go here.
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
    name = "occursOnlyOrAfterInArray";
    src = ./occursOnlyOrAfterInArray.bash;
  };

  shfmt = shfmt {
    name = "occursOnlyOrAfterInArray";
    src = ./occursOnlyOrAfterInArray.bash;
  };

  # TODO: Positive tests.

  # TODO: Negative tests.
}
