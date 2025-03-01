# NOTE: Tests related to mapsAreEqual go here.
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
    name = "mapsAreEqual";
    src = ./mapsAreEqual.bash;
  };

  shfmt = shfmt {
    name = "mapsAreEqual";
    src = ./mapsAreEqual.bash;
  };

  # TODO: Positive tests.

  # TODO: Negative tests.
}
