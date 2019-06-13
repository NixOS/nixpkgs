{ callPackage, fetchFromGitHub }:

((callPackage ./cargo-vendor.nix {}).cargo_vendor {}).overrideAttrs (attrs: {
  src = fetchFromGitHub {
    owner = "alexcrichton";
    repo = "cargo-vendor";
    rev = "9355661303ce2870d68a69d99953fce22581e31e";
    sha256 = "0d4j3r09am3ynwhczimzv39264f5xz37jxa9js123y46w5by3wd2";
  };
})
