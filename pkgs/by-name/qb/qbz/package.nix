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
  stdenv,
  webkitgtk_4_1,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "qbz";
  version = "1.1.20";

  src = fetchFromGitHub {
    owner = "vicrodh";
    repo = "qbz";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PliZLuVwsCodsXcjt9Bu9mw7b3umzaMEWgJKudUiSkA=";
  };

  cargoHash = "sha256-psGZ/fmW4kXL472cJT1aVdHOixDoZ5QQBSXqCkwPb4k=";
  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  npmDeps = fetchNpmDeps {
    name = "qbz-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-R5m+QzZsGQWo5tSDk+K++Im7o8ZFlV+Bx14hdPYGtAg=";
  };

  env.LIBCLANG_PATH = "${lib.getLib llvmPackages.libclang}/lib";

  nativeBuildInputs = [
    cargo-tauri.hook
    clang
    makeWrapper
    nodejs
    npmHooks.npmConfigHook
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    libappindicator-gtk3
    libayatana-appindicator
    openssl
    webkitgtk_4_1
  ];

  checkFlags = [
    "--skip=credentials::tests::test_encryption_roundtrip"
  ];

  postInstall = ''
    wrapProgram $out/bin/qbz \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libappindicator
          libappindicator-gtk3
          libayatana-appindicator
        ]
      }
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
