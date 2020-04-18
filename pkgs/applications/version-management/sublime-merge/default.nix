{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in {
  sublime-merge = common {
    buildVersion = "1116";
    sha256 = "0cwvn47dv0sg8cp8i3njmp4p58c6wjv6g75g09igx25waysn9cx6";
  } {};

  sublime-merge-dev = common {
    buildVersion = "1115";
    sha256 = "0dwgc9libqipwdgdc84maj1i3c8hbadz2318x1pibl6hbqy15bxl";
    dev = true;
  } {};
}
