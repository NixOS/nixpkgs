# NOTE: Tests related to getRunpathEntries go here.
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
    name = "getRunpathEntries";
    src = ./getRunpathEntries.bash;
  };

  shfmt = shfmt {
    name = "getRunpathEntries";
    src = ./getRunpathEntries.bash;
  };

  # TODO: Positive tests.

  # TODO: Negative tests.
}
