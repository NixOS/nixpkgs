{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

# unstable was chosen because of an added Cargo.lock
# revert to stable for the version after 0.9.0
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lnx";
  version = "unstable-2022-06-25";
  
  src = fetchFromGitHub {
    owner = "lnx-search";
    repo = "lnx";
    rev = "2cb80f344c558bfe37f21ccfb83265bf351419d9";
    hash = "sha256-iwoZ6xRzEDArmhWYxIrbIXRTQjOizyTsXCvMdnUrs2g=";
  };

  cargoHash = "sha256-9fro1Dx7P+P9NTsg0gtMfr0s4TEpkZA31EFAnObiNFo=";
  meta = {
    description = "Ultra-fast, adaptable deployment of the tantivy search engine via REST";
    mainProgram = "lnx";
    homepage = "https://lnx.rs/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
    platforms = lib.platforms.unix;
  };
})
