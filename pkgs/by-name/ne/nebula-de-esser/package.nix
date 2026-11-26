{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libGL,
  libx11,
  libxcursor,
  libxrandr,
  libxinerama,
  libxi,
  libxcb,
  libxkbcommon,
  fontconfig,
  freetype,
  autoPatchelfHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nebula-de-esser";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "subhankardas15071992-cloud";
    repo = "Nebula-De-Esser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-coIVl6CiyD8klDW45OY5WIoPgZwmmPqAlWUCpmo3xSw=";
  };

  cargoHash = "sha256-59CRnTkUq0wDkcsr/gM4Uu2tZHdEr1cDVLneqprC1Wo=";

  __structuredAttrs = true;

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libGL
    libx11
    libxcursor
    libxrandr
    libxinerama
    libxi
    libxcb
    libxkbcommon
    fontconfig
    freetype
  ];

  cargoBuildFlags = [
    "--package"
    "xtask"
  ];

  postBuild = ''
    cargo run --release --package xtask -- bundle nebula_desser --release
  '';

  installPhase = ''
    runHook preInstall

    vst3Dir="${
      if stdenv.hostPlatform.isDarwin then "$out/Library/Audio/Plug-Ins/VST3" else "$out/lib/vst3"
    }"

    mkdir -p "$vst3Dir"

    cp -r "target/bundled/Nebula De-Esser.vst3" "$vst3Dir/"

    runHook postInstall
  '';

  meta = {
    description = "Nebula De-Esser - Rust de-esser plugin for CLAP and VST3";
    homepage = "https://github.com/subhankardas15071992-cloud/Nebula-De-Esser";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ eymeric ];
    platforms = lib.platforms.unix;
  };
})
