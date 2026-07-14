{
  fetchFromGitHub,
  fetchurl,
  lib,
  rustPlatform,
  stdenv,
}:

let
  saplingSpendParams = fetchurl {
    url = "https://download.z.cash/downloads/sapling-spend.params";
    hash = "sha256-jkj/0jq7Ol/ZxViSBPMtnDEoWgS3gJa6QKebdWd+/BM=";
  };

  saplingOutputParams = fetchurl {
    url = "https://download.z.cash/downloads/sapling-output.params";
    hash = "sha256-Lw67y7m7C8/+laOX5+uonCnrTd5hkcM524hXDj8/sOQ=";
  };
in
rustPlatform.buildRustPackage {
  pname = "cake-wallet-warp-api-ffi";
  # This is the zcash-warpsync crate version at the pinned zwallet revision.
  version = "1.2.15-unstable-2026-06-04";

  src = fetchFromGitHub {
    owner = "MrCyjaneK";
    repo = "zwallet";
    rev = "5800cfdfc89ae46d8a343721d052d5e02470c2a7";
    fetchSubmodules = true;
    hash = "sha256-nV+9Gjui4eNezgHW9CwJD8ZMGsa9NX2OnoWvXaQcS0k=";
  };

  cargoHash = "sha256-4IVp+M1FNpApy+ryBX7xNoEVMDNhFGVs65EagKwyvX8=";

  postPatch = ''
    # Keep this in sync with Cake Wallet's scripts/prepare_zcash.sh.
    find . -name Cargo.toml -exec sed -i -E \
      's|rusqlite[[:space:]]*=[[:space:]]*\{[^}]*\}|rusqlite = { version = "0.29.0", features = ["bundled", "modern_sqlite", "backup"] }|g' \
      {} +

    # zcash-params' build script otherwise copies these from $HOME.
    ln -s ${saplingSpendParams} native/zcash-params/src/sapling-spend.params
    ln -s ${saplingOutputParams} native/zcash-params/src/sapling-output.params
  '';

  cargoBuildFlags = [
    "--package"
    "zcash-warpsync"
    "--features"
    "dart_ffi"
  ];

  doCheck = false;

  installPhase = ''
    runHook preInstall

    install -Dm755 \
      target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/libwarp_api_ffi.so \
      "$out/lib/libwarp_api_ffi.so"

    runHook postInstall
  '';

  passthru.libraryPath = "lib/libwarp_api_ffi.so";

  meta = {
    description = "Warp API FFI library for Cake Wallet";
    homepage = "https://github.com/MrCyjaneK/zwallet";
    platforms = lib.platforms.linux;
  };
}
