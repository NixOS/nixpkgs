# NOTE: Tests related to isDeclaredArray go here.
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
    name = "isDeclaredArray";
    src = ./isDeclaredArray.bash;
  };

  shfmt = shfmt {
    name = "isDeclaredArray";
    src = ./isDeclaredArray.bash;
  };

  # TODO: Positive tests.

  # TODO: Negative tests.
}
