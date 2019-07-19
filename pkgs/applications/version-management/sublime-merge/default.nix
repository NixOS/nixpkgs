{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in {
  sublime-merge = common {
    buildVersion = "1116";
    sha256 = "0cwvn47dv0sg8cp8i3njmp4p58c6wjv6g75g09igx25waysn9cx6";
  } {};

  sublime-merge-dev = common {
    buildVersion = "1111";
    sha256 = "d287b77b36febe52623db4546bef978dceb0654257b9a70c798d9cd394305c0d";
    dev = true;
  } {};
}
