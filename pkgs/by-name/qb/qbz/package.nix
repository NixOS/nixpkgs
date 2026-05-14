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
  version = "1.2.12";

  src = fetchFromGitHub {
    owner = "vicrodh";
    repo = "qbz";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SuEmBxwwEkINmH/cswV9Ed6FtBKP6IRrjQ7sIYMPOTg=";
  };

  cargoHash = "sha256-bOm2W7lQag87dDRqcCCFPp2c+qVuOAoLpPH7Pihz1BU=";
  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  tauriBuildFlags = [ "--no-sign" ];

  npmDeps = fetchNpmDeps {
    name = "qbz-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-WjZg3xaJFOdCA0XaIFwWhd4kglUjkWei6Cw3+NiP6zs=";
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
