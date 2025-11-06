{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

# unstable was chosen because of an added Cargo.lock
# revert to stable for the version after 0.9.0
let
  version = "unstable-2022-06-25";
in
rustPlatform.buildRustPackage {
  pname = "lnx";
  inherit version;
  src = fetchFromGitHub {
    owner = "lnx-search";
    repo = "lnx";
    rev = "2cb80f344c558bfe37f21ccfb83265bf351419d9";
    sha256 = "sha256-iwoZ6xRzEDArmhWYxIrbIXRTQjOizyTsXCvMdnUrs2g=";
  };

  cargoHash = "sha256-9fro1Dx7P+P9NTsg0gtMfr0s4TEpkZA31EFAnObiNFo=";
  meta = with lib; {
    description = "Ultra-fast, adaptable deployment of the tantivy search engine via REST";
    mainProgram = "lnx";
    homepage = "https://lnx.rs/";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
    platforms = platforms.unix;
  };
}
