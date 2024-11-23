{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "lightningcss";
  version = "1.28.2";

  src = fetchFromGitHub {
    owner = "parcel-bundler";
    repo = "lightningcss";
    rev = "refs/tags/v${version}";
    hash = "sha256-IwuDJcKCG1CDyRsZbobPQnRzsaUfpJHKFemOWLJNM9c=";
  };

  cargoHash = "sha256-um8G6QKxqPEcuCWmlFOqZVQLU8GxLwZ3S7z2Na2uzhQ=";

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

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "Extremely fast CSS parser, transformer, and minifier written in Rust";
    homepage = "https://lightningcss.dev/";
    changelog = "https://github.com/parcel-bundler/lightningcss/releases/tag/v${version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ johnrtitor toastal ];
    mainProgram = "lightningcss";
    platforms = lib.platforms.all;
  };
}
