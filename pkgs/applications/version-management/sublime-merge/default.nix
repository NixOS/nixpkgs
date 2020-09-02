{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in {
  sublime-merge = common {
    buildVersion = "2020";
    sha256 = "0r5qqappaiicc4srk08az2vx42m7b6a75yn2ji5pv4w4085hlrzp";
  } {};

  sublime-merge-dev = common {
    buildVersion = "2031";
    sha256 = "1vv3qcggicy5fb4nm2k5a6nw1f20cwxgrmn3xv2dvgx7mpzbhknp";
    dev = true;
  } {};
}
