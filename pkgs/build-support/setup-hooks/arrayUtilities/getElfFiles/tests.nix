# NOTE: Tests related to getElfFiles go here.
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
    name = "getElfFiles";
    src = ./getElfFiles.bash;
  };

  shfmt = shfmt {
    name = "getElfFiles";
    src = ./getElfFiles.bash;
  };

  # TODO: Positive tests.

  # TODO: Negative tests.
}
