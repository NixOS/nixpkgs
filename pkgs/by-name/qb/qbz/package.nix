{
  alsa-lib,
  cargo-tauri,
  clang,
  fetchFromGitHub,
  fetchNpmDeps,
  lib,
  libappindicator,
  libappindicator-gtk3,
  libayatana-appindicator,
  llvmPackages,
  makeWrapper,
  nix-update-script,
  nodejs,
  npmHooks,
  openssl,
  pkg-config,
  rustPlatform,
  webkitgtk_4_1,
  wrapGAppsHook3,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "qbz";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "vicrodh";
    repo = "qbz";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KTnOK1cergq48UiPR7pCfXNk8MsC3eUaLe3JclCCLjE=";
  };

  cargoHash = "sha256-H9leYEYTy7H/I84/lrVBbyiETAmiGj9anPccgq3rRNg=";
  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  npmDeps = fetchNpmDeps {
    name = "qbz-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-Bpb91QV0cZFX9DzTmPKy2KupPRFnidUi9Ka90AXxZ3I=";
  };

  env.LIBCLANG_PATH = "${lib.getLib llvmPackages.libclang}/lib";

  nativeBuildInputs = [
    cargo-tauri.hook
    clang
    makeWrapper
    nodejs
    npmHooks.npmConfigHook
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    alsa-lib
    libappindicator-gtk3
    openssl
    webkitgtk_4_1
  ];

  doCheck = false;

  postInstall = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libappindicator
          libayatana-appindicator
        ]
      }
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A native, full-featured hi-fi Qobuz desktop player for Linux, with fast, bit-perfect audio playback";
    homepage = "https://qbz.lol";
    changelog = "https://github.com/vicrodh/qbz/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      felixsinger
    ];
    mainProgram = "qbz";
    platforms = lib.platforms.linux;
  };
})
