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
  pname = "cloudreverb";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "xunil-cloud";
    repo = "CloudReverb";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-erpJlS9VYvYyqYyKjyDuob7Jup+zLuj93j+BRAjPtl4=";
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

  # JUCE dlopen's these at runtime, crashes without them
  env.NIX_LDFLAGS = toString [
    "-lX11"
    "-lXext"
    "-lXcursor"
    "-lXinerama"
    "-lXrandr"
  ];

  # Disable LTO to avoid optimization mismatch issues
  env.NIX_CFLAGS_COMPILE = toString [
    "-fno-lto"
  ];

  __structuredAttrs = true;
  strictDeps = true;
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -r CloudReverb_artefacts/Release/LV2 $out/lib/lv2
    cp -r CloudReverb_artefacts/Release/VST3 $out/lib/vst3
    install -Dm755 "CloudReverb_artefacts/Release/Standalone/CloudReverb" $out/bin/cloud_reverb

    runHook postInstall
  '';

  meta = {
    description = "Algorithmic reverb plugin based on CloudSeed";
    homepage = "https://github.com/xunil-cloud/CloudReverb";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ crop ];
    platforms = lib.platforms.linux;
    mainProgram = "cloud_reverb";
  };
})
