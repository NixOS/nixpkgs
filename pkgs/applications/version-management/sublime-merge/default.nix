{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in {
  sublime-merge = common {
    buildVersion = "2032";
    sha256 = "b782c768383893ba7803c2cffd428b09bec46be8a65e61a5f17964bdcc2aaf7c";
  } {};

  sublime-merge-dev = common {
    buildVersion = "2033";
    sha256 = "ab937a393eb6ae776a81b30ec5a589ae37763885ba8a91680d5c43e19a01a8fa";
    dev = true;
  } {};
}
