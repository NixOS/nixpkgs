{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in {
  sublime-merge = common {
    buildVersion = "2071";
    sha256 = "xYVk5Fx6VdoHzf0cbmhwKyEr5HDEZgPgDoBWQg/tS0U=";
  } {};

  sublime-merge-dev = common {
    buildVersion = "2070";
    sha256 = "2AA2HBF19g34ov6ytjL2caqS7Ro4eyj18vzwINm0CTw=";
    dev = true;
  } {};
}
