{
  lib,
  clangStdenv,
  cmake,
  expat,
  fetchFromGitHub,
  ffmpeg_4-full,
  fontconfig,
  freetype,
  glib,
  harfbuzzFull,
  icu,
  libGL,
  libGLU,
  libjpeg_turbo,
  libpng,
  libsForQt5,
  libunwind,
  libwebp,
  ninja,
  patchelf,
  pcre2,
  pkg-config,
  python3,
  qt5Full,
  xorg,
  zlib,
}:

clangStdenv.mkDerivation rec {
  pname = "friction.graphics";
  version = "1.0.0-rc.2";
  src = fetchFromGitHub {
    owner = "friction2d";
    repo = "friction";
    rev = "v${version}";
    hash = "sha256-tmxzEfOy+eCe7K4Rv+bFNk0t3aD1n4iqAroB1li9vVM=";
    fetchSubmodules = true;
  };

  patches = [
    ./disable-ffmpeg-version-warning.patch
  ];
  buildInputs = [
    expat
    ffmpeg_4-full
    fontconfig
    freetype
    glib
    harfbuzzFull
    icu
    libGL
    libGLU
    libjpeg_turbo
    libpng
    libsForQt5.qscintilla
    libsForQt5.qtdeclarative
    libsForQt5.qtmultimedia
    libunwind
    libwebp
    ninja
    pcre2
    python3
    qt5Full
    zlib
  ]
  ++ lib.optionals (!clangStdenv.hostPlatform.isDarwin) [
    xorg.libX11
  ];
  nativeBuildInputs = [
    cmake
    pkg-config
    libsForQt5.wrapQtAppsHook
    patchelf
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DHARFBUZZ_INCLUDE_DIRS=${harfbuzzFull.dev}/include"
    "-DQSCINTILLA_INCLUDE_DIRS=${libsForQt5.qscintilla}/include"
    "-DQSCINTILLA_LIBRARIES_DIRS=${libsForQt5.qscintilla}/lib/"
    "-DQSCINTILLA_LIBRARIES=${
      if clangStdenv.hostPlatform.isDarwin then "libqscintilla2.dylib" else "libqscintilla2.so"
    }"
    "-DCMAKE_BUILD_WITH_INSTALL_RPATH=true"
    "-DCMAKE_INSTALL_RPATH_USE_LINK_PATH=true"
    "-DCMAKE_INSTALL_RPATH=${lib.makeLibraryPath buildInputs}"
    "-G Ninja"
  ]
  ++ lib.optionals clangStdenv.hostPlatform.isDarwin [
    "-DCMAKE_OSX_DEPLOYMENT_TARGET=12.7"
    "-DMAC_DEPLOY=ON"
  ];
  postPatch = ''
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" src/engine/skia/bin/gn
    grep -rl 'hb' | xargs sed -Ei 's/(["<])(hb.*\.h)/\1harfbuzz\/\2/'
  '';
  buildPhase = ''
    export VERBOSE=1
    cmake --build . --config Release
  '';
  meta = with lib; {
    description = "Vector motion graphics program";
    longDescription = "Friction is a powerful and versatile motion graphics application that allows you to create stunning vector and raster animations for web and video platforms with ease.";
    homepage = "https://friction.graphics/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ socksy ];
    mainProgram = "friction";
  };
}
