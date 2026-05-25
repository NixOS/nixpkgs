{
  lib,
  clangStdenv,
  cmake,
  expat,
  fetchFromGitHub,
  ffmpeg_4,
  fontconfig,
  freetype,
  glib,
  harfbuzzFull,
  libGL,
  libGLU,
  libjpeg_turbo,
  libpng,
  libsForQt5,
  libunwind,
  libwebp,
  ninja,
  pcre2,
  pkg-config,
  python3,
  libx11,
  zlib,
  enableWayland ? false,
}:

clangStdenv.mkDerivation rec {
  pname = "friction";
  version = "1.0.0-rc.3";
  src = fetchFromGitHub {
    owner = "friction2d";
    repo = "friction";
    rev = "v${version}";
    hash = "sha256-JUDqjUhtYiDll7bTNmYCItT8eQHS5pV38OwqiTXKowM=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    python3
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    expat
    ffmpeg_4
    fontconfig
    freetype
    glib
    harfbuzzFull
    libGL
    libGLU
    libjpeg_turbo
    libpng
    libsForQt5.qscintilla
    libsForQt5.qtbase
    libsForQt5.qtdeclarative
    libsForQt5.qtmultimedia
    libsForQt5.qtwayland
    libunwind
    libwebp
    pcre2
    zlib
  ]
  ++ lib.optionals (!clangStdenv.hostPlatform.isDarwin) [
    libx11
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DQSCINTILLA_INCLUDE_DIRS=${libsForQt5.qscintilla}/include"
    "-DQSCINTILLA_LIBRARIES_DIRS=${libsForQt5.qscintilla}/lib/"
    "-DQSCINTILLA_LIBRARIES=${
      if clangStdenv.hostPlatform.isDarwin then "libqscintilla2.dylib" else "libqscintilla2.so"
    }"
    "-DCMAKE_INSTALL_RPATH=${lib.makeLibraryPath buildInputs}"
  ]
  ++ lib.optionals clangStdenv.hostPlatform.isDarwin [
    "-DCMAKE_OSX_DEPLOYMENT_TARGET=12.7"
    "-DMAC_DEPLOY=ON"
  ];

  postPatch = ''
    grep -rl 'hb' src/skia | xargs sed -Ei 's/(["<])(hb.*\.h)/\1harfbuzz\/\2/'
  ''
  + lib.optionalString enableWayland ''
    sed -i '/qputenv("QT_QPA_PLATFORM", "xcb")/d' src/core/appsupport.cpp
  '';

  meta = {
    description = "Vector motion graphics program";
    longDescription = "Friction is a powerful and versatile motion graphics application that allows you to create stunning vector and raster animations for web and video platforms with ease.";
    homepage = "https://friction.graphics/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ socksy ];
    mainProgram = "friction";
  };
}
