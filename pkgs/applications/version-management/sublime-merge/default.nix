{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in {
  sublime-merge = common {
    buildVersion = "2020";
    sha256 = "0r5qqappaiicc4srk08az2vx42m7b6a75yn2ji5pv4w4085hlrzp";
  } {};

  sublime-merge-dev = common {
    buildVersion = "2011";
    sha256 = "0r5qqappaiicc4srk08az2vx42m7b6a75yn2ji5pv4w4085hlrzp";
    dev = true;
  } {};
}
