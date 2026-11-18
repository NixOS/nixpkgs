{
  lib,
  stdenv,
  rustPlatform,
  jemalloc,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lightningcss";
  version = "1.33.0";

  src = fetchFromGitHub {
    owner = "parcel-bundler";
    repo = "lightningcss";
    tag = "v${finalAttrs.version}";
    hash = "sha256-twodhkzM/h4ijZFeB2tQAOAV131r1ggLr3tcXUUGHFo=";
  };

  cargoHash = "sha256-Jz6kpaan1HNJKhG7Jb5f5mfZoYNDwQhemTuVCf5Cn0Q=";

  patches = [
    # Backport fix for build error for lightningcss-napi
    # see https://github.com/parcel-bundler/lightningcss/pull/713
    # FIXME: remove when merged upstream
    ./0001-napi-fix-build-error-in-cargo-auditable.patch
  ];

  buildFeatures = [
    "cli"
  ];

  cargoBuildFlags = [
    "--lib"
    "--bin=lightningcss"
  ];

  cargoTestFlags = [
    "--lib"
  ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    # jemalloc-sys 0.3.2 expects unprefixed symbols when JEMALLOC_OVERRIDE is set,
    # so use jemalloc (unprefixed on darwin) instead of the _rjem_-prefixed rust-jemalloc-sys
    JEMALLOC_OVERRIDE = "${lib.getLib jemalloc}/lib/libjemalloc${stdenv.hostPlatform.extensions.sharedLibrary}";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Extremely fast CSS parser, transformer, and minifier written in Rust";
    homepage = "https://lightningcss.dev/";
    changelog = "https://github.com/parcel-bundler/lightningcss/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      johnrtitor
      toastal
    ];
    mainProgram = "lightningcss";
    platforms = lib.platforms.all;
  };
})
