{ lib, ... }:
let
  inherit (lib) mkOption;
in
{
  wrong1 = mkOption {
  };
  # This is not actually reported separately, so could be omitted from the test
  # but it makes the example more realistic.
  # Making it parse this _config_ as options would too risky. What if it's not
  # options but other values, that abort, throw, diverge, etc?
  nest.wrong2 = mkOption {
  };
}
