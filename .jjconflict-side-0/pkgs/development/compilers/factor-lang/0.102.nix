{ callPackage, fetchurl, ... }@args:

callPackage ./unwrapped.nix (
  rec {
    version = "0.102";
    src = fetchurl {
      url = "https://downloads.factorcode.org/releases/${version}/factor-src-${version}.zip";
      hash = "sha256-bQDrq9sYWkCiUlELze0zGgW56DMMXckKGBpjVaMuOrU=";
    };
  }
  // (builtins.removeAttrs args [
    "callPackage"
    "fetchurl"
  ])
)
