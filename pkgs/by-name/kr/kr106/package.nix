{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  alsa-lib,
  freetype,
  fontconfig,
  libGL,
  libx11,
  libxcursor,
  libxext,
  libxinerama,
  libxrandr,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kr106";
  version = "2.5.13";

  src = fetchFromGitHub {
    owner = "kayrockscreenprinting";
    repo = "ultramaster_kr106";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-R0nvtdhhrT+ucpBSsWjJEUCInd4/0jDammlUsaCgL6M=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    freetype
    fontconfig
    libGL
    libx11
    libxcursor
    libxext
    libxinerama
    libxrandr
  ];

  cmakeFlags = [
    (lib.cmakeBool "KR106_COPY_AFTER_BUILD" false)
  ];

  # JUCE dlopen's these at runtime, crashes without them
  env.NIX_LDFLAGS = toString [
    "-lX11"
    "-lXext"
    "-lXcursor"
    "-lXinerama"
    "-lXrandr"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -r KR106_artefacts/Release/LV2  $out/lib/lv2
    cp -r KR106_artefacts/Release/VST3 $out/lib/vst3
    cp -r KR106_artefacts/Release/CLAP $out/lib/clap
    install -Dm755 "KR106_artefacts/Release/Standalone/Ultramaster KR-106" $out/bin/kr106

    runHook postInstall
  '';

  __structuredAttrs = true;
  strictDeps = true;

  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Synthesizer plugin emulating the Roland Juno-6, Juno-60 and Juno-106";
    homepage = "https://kayrock.org/kr106";
    downloadPage = "https://github.com/kayrockscreenprinting/ultramaster_kr106";
    changelog = "https://kayrock.org/kr106/changelog.html";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ crop ];
    platforms = lib.platforms.linux;
    mainProgram = "kr106";
  };
})
