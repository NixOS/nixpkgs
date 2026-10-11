{ lib, callPackage, ... }@args:

callPackage ./generic.nix (
  args
  // rec {
    brand = "Behringer";
    type = "WING";
    version = "3.3.2";
    url =
      let
        lower = lib.strings.toLower type;
        cap =
          (lib.strings.toUpper (builtins.substring 0 1 lower))
          + (builtins.substring 1 (builtins.stringLength lower - 1) lower);
      in
      "https://cdn-media.empowertribe.com/54ca5aa1529e442b977a9b77bc81c458/${cap}-Edit_LINUX_${version}.tar.gz";
    hash = "sha256-MAhYfjErJTDwJKt3JN7J1w2e3QAy1fmgwGIJwtNETkE=";
    homepage = "https://www.behringer.com/en/products/0603-afc";
  }
)
