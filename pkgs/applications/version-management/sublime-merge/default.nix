{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in {
  sublime-merge = common {
    buildVersion = "2033";
    sha256 = "1ym806df2hsw1ml932mshlw7cdxfi6jwa3mkh5m7gbmn7qwpm4xb";
  } {};

  sublime-merge-dev = common {
    buildVersion = "2031";
    sha256 = "1vv3qcggicy5fb4nm2k5a6nw1f20cwxgrmn3xv2dvgx7mpzbhknp";
    dev = true;
  } {};
}
