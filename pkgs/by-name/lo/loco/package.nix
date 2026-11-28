{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "loco";
  version = "1.3.1";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-JkGAIW4v4jxRg2r8zee9Uu7jAwPkSRMeNhchxtEEtzE=";
  };

  cargoHash = "sha256-uGFKp+RmlnVFeCB8P+PNGpVBRI5psLH/RNZOPgMmloU=";

  #Skip trycmd integration tests
  checkFlags = [
    "--skip=cli_tests"
    "--skip=tests::loco_version_floor_tracks_the_framework_release"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Loco CLI is a powerful command-line tool designed to streamline the process of generating Loco websites";
    homepage = "https://loco.rs";
    changelog = "https://github.com/loco-rs/loco/blob/master/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      sebrut
      mkapra
    ];
    mainProgram = "loco";
  };
})
