{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in {
  sublime-merge = common {
    buildVersion = "2077";
    x64sha256 = "6xgh/oSatTYHCnQEXiZAoHs3yI1iimLMtzCosBKBVp8=";
  } {};

  sublime-merge-dev = common {
    buildVersion = "2078";
    x64sha256 = "33oJOnsOUr9W+OGMetafaGtXUa+CHxxLjmtDoZliw0k=";
    dev = true;
  } {};
}
