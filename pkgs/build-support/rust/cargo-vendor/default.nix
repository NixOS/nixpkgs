{ callPackage, fetchFromGitHub }:

(callPackage ./cargo-vendor.nix {}).cargo_vendor_0_1_13.overrideAttrs (attrs: {
  src = fetchFromGitHub {
    owner = "alexcrichton";
    repo = "cargo-vendor";
    rev = "0.1.13";
    sha256 = "0ljh2d65zpxp26a95b3czy5ai2z2dm87x7ndfdc1s0v1fsy69kn4";
  };
})
