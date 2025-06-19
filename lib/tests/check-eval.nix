# Throws an error if any of our lib tests fail.

let
  lib = import ../default.nix;
  tests = [
    "misc"
    "systems"
  ];
  failures = builtins.concatLists (map (f: import (./. + "/${f}.nix")) tests);
in
lib.debug.throwTestFailures {
  inherit failures;
  description = "check-eval.nix tests";
}
