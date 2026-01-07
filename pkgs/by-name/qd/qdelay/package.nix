{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  alsa-lib,
  fontconfig,
  freetype,
  libX11,
  libXcomposite,
  libXcursor,
  libXdmcp,
  libXext,
  libXinerama,
  libXrandr,
  libXtst,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qdelay";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "tiagolr";
    repo = "qdelay";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-6V9L8GTAHN3bzVZ00XlSwh71ZQrx4o37J8kOZtRzjC8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    writableTmpDirAsHomeHook # fontconfig cache
  ];

  buildInputs = [
    fontconfig
    freetype
  ]
  ++ lib.optionals stdenv.isLinux [
    alsa-lib
    libX11
    libXcomposite
    libXcursor
    libXdmcp
    libXext
    libXinerama
    libXrandr
    libXtst
  ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DCOPY_PLUGIN_AFTER_BUILD=FALSE"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "-DCMAKE_OSX_ARCHITECTURES=${stdenv.hostPlatform.darwinArch}"
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'juce::juce_recommended_lto_flags' '# Not forcing LTO'
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/vst3

  ''
  + (
    if stdenv.hostPlatform.isDarwin then
      ''
        mkdir -p $out/Applications
        cp -R QDelay_artefacts/Release/Standalone/QDelay.app \
          $out/Applications/QDelay.app
        ln -s \
          $out/Applications/QDelay.app/Contents/MacOS/QDelay \
          $out/bin/QDelay
      ''
    else
      ''
        install -Dm755 \
          QDelay_artefacts/Release/Standalone/QDelay \
          $out/bin/QDelay

        mkdir -p $out/bin $out/lib/lv2
        cp -r "QDelay_artefacts/Release/LV2/QDelay.lv2" $out/lib/lv2
      ''
  )
  + ''
    cp -r "QDelay_artefacts/Release/VST3/QDelay.vst3" $out/lib/vst3

    runHook postInstall
  '';

  meta = {
    description = "Dual delay with more features than it should";
    homepage = "https://github.com/tiagolr/qdelay";
    changelog = "https://github.com/tiagolr/qdelay/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ magnetophon ];
    mainProgram = "QDelay";
    platforms = lib.platforms.all;
  };
})
