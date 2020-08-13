{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in {
  sublime-merge = common {
    buildVersion = "2020";
    sha256 = "0r5qqappaiicc4srk08az2vx42m7b6a75yn2ji5pv4w4085hlrzp";
  } {};

  sublime-merge-dev = common {
    buildVersion = "2022";
    sha256 = "0fhxz6nx24wbspn7vfli3pvfv6fdbd591m619pvivig3scpidj61";
    dev = true;
  } {};
}
