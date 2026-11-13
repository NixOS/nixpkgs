{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ifrextractor-rs";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "LongSoft";
    repo = "ifrextractor-rs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Us9p/W5/fsk3gE9xUIDwbhILe/y9GGTkf1N+qKo1n5U=";
  };

  cargoHash = "sha256-Co8mzfZJRUCBSEXr65vWbQUtmXZSN1AMgLID/Zo9BVc=";

  meta = {
    description = "Rust utility to extract UEFI IFR data into human-readable text";
    mainProgram = "ifrextractor";
    homepage = "https://github.com/LongSoft/IFRExtractor-RS";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ jiegec ];
  };
})
