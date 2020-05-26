{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in {
  sublime-merge = common {
    buildVersion = "1116";
    sha256 = "0cwvn47dv0sg8cp8i3njmp4p58c6wjv6g75g09igx25waysn9cx6";
  } {};

  sublime-merge-dev = common {
    buildVersion = "2011";
    sha256 = "0r5qqappaiicc4srk08az2vx42m7b6a75yn2ji5pv4w4085hlrzp";
    dev = true;
  } {};
}
