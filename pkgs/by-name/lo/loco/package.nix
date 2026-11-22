{
  lib,
  rustPlatform,
  fetchCrate,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "loco";
  version = "1.2.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-w82GwVnsmIwwiNcGA4RBu8lWzu6ZOn2VX7GlxUCAKVQ=";
  };

  cargoHash = "sha256-ncHHwvGgDF2t1oE+uHfP0zyB9NBZMO4wtJZajeaxur0=";

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
