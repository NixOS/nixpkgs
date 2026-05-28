{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  zlib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "norgolith";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "NTBBloodbath";
    repo = "norgolith";
    tag = "v${finalAttrs.version}";
    hash = "sha256-K3Gg/8LKmxrHLzVUx4IF3nTxwl2PU7CrV5oZ8BwHo1U=";
  };

  cargoHash = "sha256-O3Sd0A9XhhtBUqwCDV2TVYAe9Q8Ir0j5YHX220AgTjc=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ];

  useNextest = true;

  env = {
    LIBGIT2_NO_VENDOR = true;
    OPENSSL_NO_VENDOR = true;
  };

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "The monolithic Norg static site generator built with Rust";
    homepage = "https://norgolith.amartin.beer";
    changelog = "https://github.com/NTBBloodbath/norgolith/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ Ladas552 ];
    mainProgram = "lith";
  };
})
