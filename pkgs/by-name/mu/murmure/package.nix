{
  lib,
  fetchzip,
  rustPlatform,
  fetchFromGitHub,
  pnpm,

  # patches
  libayatana-appindicator,
  libappindicator-gtk3,

  # nativeBuildInputs
  cargo-tauri,
  pkg-config,
  nodejs,

  # buildInputs
  alsa-lib,
  atk,
  glib,
  libX11,
  libXi,
  libXtst,
  libsoup_3,
  onnxruntime,
  openssl,
  pango,
  webkitgtk_4_1,
  xdotool,

  # passthru
  nix-update-script,
}:

let
  parakeet-model = fetchzip {
    url = "https://github.com/Kieirra/murmure-model/releases/download/1.0.0/parakeet-tdt-0.6b-v3-int8.zip";
    hash = "sha256-rlV7mi5Y6qu/9jRWRPNBlABW8GxsvVAMCM6Ye2tVb2s=";
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "murmure";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "Kieirra";
    repo = "murmure";
    tag = finalAttrs.version;
    hash = "sha256-IyAIcwXYSXt221+b+zsv9nEtla7v3cm44TdzOqwNm5w=";
  };

  # The libappindicator_sys crate loads these libraries at runtime
  postPatch = ''
    substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
      --replace-fail \
        "libayatana-appindicator3.so.1" \
        "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1" \
      --replace-fail \
        "libappindicator3.so.1" \
        "${libappindicator-gtk3}/lib/libappindicator3.so.1"
  '';

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-uzZeYhmrhF/FJAfEEU9B8ylFXcId2fNfwPiwifs0Cuk=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoHash = "sha256-8StCNg14yaBXwm6eErpzwSYiI8xBEQ7U5TC3nV4XOH4=";

  env.OPENSSL_NO_VENDOR = true;

  nativeBuildInputs = [
    pnpm.configHook
    nodejs

    cargo-tauri.hook
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    atk
    glib
    libX11
    libXi
    libXtst
    libappindicator-gtk3
    libsoup_3
    onnxruntime
    openssl
    pango
    webkitgtk_4_1
    xdotool
  ];

  checkFlags = [
    # Couldn't compile the test.
    # error[E0433]: failed to resolve: use of unresolved module or unlinked crate `transcribe_rs`
    "--skip=engine::engine::ParakeetEngine"
    "--skip=engine::engine::ParakeetEngine::new"
    "--skip=engine::engine::ParakeetModelParams::int8"
    "--skip=engine::transcription_engine::TranscriptionEngine"
    "--skip=engine::transcription_engine::TranscriptionEngine"
  ];

  postInstall = ''
    mkdir -p $out/lib/murmure/resources
    ln -s ${parakeet-model} $out/lib/murmure/resources/parakeet-tdt-0.6b-v3-int8
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Privacy-first and free Speech-to-Text";
    homepage = "https://murmure.al1x-ai.com";
    downloadPage = "https://github.com/Kieirra/murmure";
    changelog = "https://github.com/Kieirra/murmure/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "murmure";
  };
})
