{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in {
  sublime-merge = common {
    buildVersion = "2063";
    sha256 = "0sdp0adrrjsz19blp1yb6yjc6kdrvdrpzr1j6wm49phhw9qg3awp";
  } {};

  sublime-merge-dev = common {
    buildVersion = "2062";
    sha256 = "035f4gxbg9mb8p8yynpc6a1id9b8krfnr0gl98ib09bdh96ddan3";
    dev = true;
  } {};
}
