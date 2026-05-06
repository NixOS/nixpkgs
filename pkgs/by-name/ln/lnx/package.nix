{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lnx";
  version = "0.9.0-master";

  src = fetchFromGitHub {
    owner = "lnx-search";
    repo = "lnx";
    tag = finalAttrs.version;
    hash = "sha256-J2WP+/f6g1UsjpAdCvkdSpiAyDn9dyAXEbqNfWbNbHk=";
  };

  cargoHash = "sha256-9fro1Dx7P+P9NTsg0gtMfr0s4TEpkZA31EFAnObiNFo=";

  # mimalloc uses ATOMIC_VAR_INIT which was removed in C23 (GCC 15 default)
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isGNU "-std=c17";

  meta = {
    description = "Ultra-fast, adaptable deployment of the tantivy search engine via REST";
    mainProgram = "lnx";
    homepage = "https://lnx.rs/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
    platforms = lib.platforms.unix;
  };
})
