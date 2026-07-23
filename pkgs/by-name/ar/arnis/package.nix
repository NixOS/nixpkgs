{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  cargo-tauri,
  wrapGAppsHook4,
  webkitgtk_4_1,
  pkg-config,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "arnis";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "louis-e";
    repo = "arnis";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hNVECK6+I3ML/knsBdvEx2Uz1w4jXHynanlQfgrM9oM=";
  };

  cargoHash = "sha256-Kff+76lZ6hsSbssYhrupmE2xAt1gwia8sMZR15ReqgU=";

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

  checkFlags = [
    # Fail to run in sandbox environment
    "--skip=map_transformation::translate::translator::tests::test_translate_by_vector"
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
