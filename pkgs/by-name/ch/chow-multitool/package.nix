{
  alsa-lib,
  cmake,
  curl,
  libepoxy,
  fetchFromGitHub,
  freetype,
  gtk3,
  lib,
  libXcursor,
  libXdmcp,
  libXext,
  libXinerama,
  libXrandr,
  libXtst,
  libdatrie,
  libjack2,
  libpsl,
  libselinux,
  libsepol,
  libsysprof-capture,
  libthai,
  libuuid,
  libxkbcommon,
  nix-update-script,
  pcre,
  pcre2,
  pkg-config,
  sqlite,
  webkitgtk_4_0,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "chow-multitool";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "Chowdhury-DSP";
    repo = "ChowMultiTool";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vyVa+l/Ie+CwnLjDyEEd0Aq8JCZfaoXaowR2QSgQ4LQ=";
    fetchSubmodules = true;
  };

  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    alsa-lib
    curl
    libepoxy
    freetype
    gtk3
    libXcursor
    libXdmcp
    libXext
    libXinerama
    libXrandr
    libXtst
    libdatrie
    libjack2
    libpsl
    libselinux
    libsepol
    libsysprof-capture
    libthai
    libuuid
    libxkbcommon
    pcre
    pcre2
    sqlite
    webkitgtk_4_0
  ];

  cmakeFlags = [
    "-DCMAKE_AR=${stdenv.cc.cc}/bin/gcc-ar"
    "-DCMAKE_RANLIB=${stdenv.cc.cc}/bin/gcc-ranlib"
    "-DCMAKE_NM=${stdenv.cc.cc}/bin/gcc-nm"
  ];

  cmakeBuildType = "Release";

  # LTO does not work for this plugin, disable it
  postPatch = ''
    sed -i -e '/juce::juce_recommended_lto_flags/d' modules/CMakeLists.txt
  '';

  installPhase = ''
    mkdir -p $out/lib/lv2 $out/lib/vst3 $out/bin $out/lib/clap
    cd ChowMultiTool_artefacts/${finalAttrs.cmakeBuildType}
    cp -r LV2/ChowMultiTool.lv2 $out/lib/lv2
    cp -r VST3/ChowMultiTool.vst3 $out/lib/vst3
    cp -r CLAP/ChowMultiTool.clap $out/lib/clap
    cp Standalone/ChowMultiTool  $out/bin
  '';

  # JUCE dlopens these, make sure they are in rpath
  # Otherwise, segfault will happen
  NIX_LDFLAGS = (
    toString [
      "-lX11"
      "-lXext"
      "-lXcursor"
      "-lXinerama"
      "-lXrandr"
    ]
  );

  meta = {
    homepage = "https://github.com/Chowdhury-DSP/ChowMultiTool";
    description = "Multi-Tool Audio Plugin";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
})
