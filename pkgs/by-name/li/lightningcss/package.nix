{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lightningcss";
  version = "1.30.1";

  src = fetchFromGitHub {
    owner = "parcel-bundler";
    repo = "lightningcss";
    tag = "v${finalAttrs.version}";
    hash = "sha256-imLbsQ2F5CQiepwWSMcXj0Fgyv4liCMmCwA/0SE07Mo=";
  };

  cargoHash = "sha256-aNho9NavEgY4dwGcNXsLDnlVCB2rODIPae3LnfOwJIA=";

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
