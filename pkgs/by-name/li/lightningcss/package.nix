{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "lightningcss";
  version = "1.28.0";

  src = fetchFromGitHub {
    owner = "parcel-bundler";
    repo = "lightningcss";
    rev = "refs/tags/v${version}";
    hash = "sha256-nW5tnHD5saY7KnccRg5NsszvrADd/tuoN7SWr7JYBVs=";
  };

  cargoHash = "sha256-He5lb5y3Zd1nygWJWZDzBq5avL81ZKoiZMxtxjKkU7I=";

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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Extremely fast CSS parser, transformer, and minifier written in Rust";
    homepage = "https://lightningcss.dev/";
    changelog = "https://github.com/parcel-bundler/lightningcss/releases/tag/v${version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      johnrtitor
      toastal
    ];
    mainProgram = "lightningcss";
    platforms = lib.platforms.all;
  };
}
