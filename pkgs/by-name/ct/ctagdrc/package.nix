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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ctagdrc";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "BillyDM";
    repo = "CTAGDRC";
    tag = finalAttrs.version;
    hash = "sha256-szBI8ESJz1B/JuGcZD8D53c1yJeUW1uK4GewQExtD9Q=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    fontconfig
    freetype
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

  postPatch = ''
    substituteInPlace CMakeLists.txt \
          --replace-fail 'COPY_PLUGIN_AFTER_BUILD TRUE' 'COPY_PLUGIN_AFTER_BUILD FALSE'
    substituteInPlace CMakeLists.txt \
          --replace-fail 'include(cmake-include/CPM.cmake)' '# No CPM needed'
    substituteInPlace CMakeLists.txt \
          --replace-fail 'juce::juce_recommended_lto_flags' '# Not forcing LTO'
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/clap $out/lib/vst3
    install -Dm755 "CTAGDRC_artefacts/Release/Standalone/CTAGDRC" $out/bin/CTAGDRC
    install -Dm644 "CTAGDRC_artefacts/Release/CLAP/CTAGDRC.clap" -t $out/lib/clap
    cp -r "CTAGDRC_artefacts/Release/VST3/CTAGDRC.vst3" $out/lib/vst3

    runHook postInstall
  '';

  # JUCE dlopens these, make sure they are in rpath
  # Otherwise, segfault will happen
  env.NIX_LDFLAGS = toString [
    "-lX11"
    "-lXext"
    "-lXcomposite"
    "-lXcursor"
    "-lXinerama"
    "-lXrandr"
    "-lXrender"
    "-lXtst"
    "-lXdmcp"
  ];

  meta = {
    description = "Audio compressor plugin created with JUCE";
    homepage = "https://github.com/BillyDM/CTAGDRC";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ magnetophon ];
    mainProgram = "CTAGDRC";
    platforms = lib.platforms.all;
  };
})
