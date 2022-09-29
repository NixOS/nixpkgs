{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in {
  sublime-merge = common {
    buildVersion = "2077";
    x64sha256 = "6xgh/oSatTYHCnQEXiZAoHs3yI1iimLMtzCosBKBVp8=";
  } {};

  sublime-merge-dev = common {
    buildVersion = "2076";
    x64sha256 = "k43D+TqS1DImpJKzYuf3LqmsxF3XF9Fwqn2txL13xAA=";
    dev = true;
  } {};
}
