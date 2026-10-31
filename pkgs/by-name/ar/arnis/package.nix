{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  cargo-tauri,
  cacert,
  wrapGAppsHook4,
  webkitgtk_4_1,
  pkg-config,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "arnis";
  version = "3.3.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "louis-e";
    repo = "arnis";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fn2YGDJVb8ICfVOxVCUzPR+T+aYJr83e95O7YXxh+AE=";
  };

  cargoHash = "sha256-tPOHSiX7md/ga0+0ROB0Ar4/ZRW/Vifl/4XlxULOzbU=";

  nativeBuildInputs = [
    cargo-tauri.hook

    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wrapGAppsHook4
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    webkitgtk_4_1
  ];

  nativeCheckInputs = [ cacert ];

  checkFlags = [
    # Fetches OSM data from Overpass, which the build sandbox does not allow
    "--skip=map_transformation::translate::translator::tests::test_translate_by_vector"
  ]
  ++ lib.optionals stdenv.hostPlatform.isAarch64 [
    # Passes on x86_64, but overflows the test-thread stack on aarch64
    "--skip=world_editor::bedrock::leveldb_options_tests::bedrock_db_survives_heavy_compaction"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "--skip=mapillary::fetch::tests::the_run_counts_what_it_asked_of_the_network"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram =
    let
      binSubdirectory =
        if stdenv.hostPlatform.isLinux then
          "bin"
        else if stdenv.hostPlatform.isDarwin then
          "Applications/Arnis.app/Contents/MacOS"
        else
          throw "Unsuported system";
    in
    "${placeholder "out"}/${binSubdirectory}/arnis";
  doInstallCheck = true;

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Real world location generator for Minecraft Java Edition";
    longDescription = ''
      Open source project written in Rust generates any chosen location from
      the real world in Minecraft Java Edition with a high level of detail.
    '';
    homepage = "https://github.com/louis-e/arnis";
    changelog = "https://github.com/louis-e/arnis/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    inherit (cargo-tauri.hook.meta) platforms;
    maintainers = with lib.maintainers; [ nartsiss ];
    mainProgram = "arnis";
  };
})
