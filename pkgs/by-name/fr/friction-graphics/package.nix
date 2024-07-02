{ lib
, clangStdenv
, cmake
, expat
, fetchgit
, ffmpeg_4-full
, fontconfig
, freetype
, glib
, gn
, harfbuzzFull
, icu
, libGL
, libjpeg_turbo
, libpng
, libsForQt5
, libunwind
, libwebp
, ninja
, pcre2
, pkg-config
, python3
, qt5Full
, xorg
, zlib
}:

clangStdenv.mkDerivation rec {
  pname = "friction.graphics";
  version = "0.9.6";
  src = fetchgit {
    url = "https://github.com/friction2d/friction";
    rev = version;
    sha256 = "sha256-QjwkijsTAEEN1VqGtIfsNsHTM1DIRUp+hfABuXoj+nU=";
    fetchSubmodules = true;
  };
  buildInputs = [
    expat
    ffmpeg_4-full
    fontconfig
    freetype
    glib
    gn
    harfbuzzFull
    icu
    libGL
    libjpeg_turbo
    libpng
    libsForQt5.qscintilla
    libunwind
    libwebp
    ninja
    pcre2
    python3
    qt5Full
    xorg.libX11
    zlib
  ];
  nativeBuildInputs = [ cmake pkg-config ];
  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_INSTALL_PREFIX=bin"
    "-DHARFBUZZ_INCLUDE_DIRS=${harfbuzzFull.dev}/include"
    "-DQSCINTILLA_INCLUDE_DIRS=${libsForQt5.qscintilla}/include"
    "-DQSCINTILLA_LIBRARIES_DIRS=${libsForQt5.qscintilla}/lib/"
    "-DQSCINTILLA_LIBRARIES=libqscintilla2.so"
    "-G Ninja"
  ];
  patchPhase = ''
    sed -i 's|''${SKIA_SRC}/bin/gn)|${gn}/bin/gn)|' src/engine/CMakeLists.txt
    sed -i 's|fontconfig|${fontconfig.lib}/lib/libfontconfig.so|' src/cmake/friction-common.cmake
    grep -rl 'hb' | xargs sed -Ei 's/(["<])(hb.*\.h)/\1harfbuzz\/\2/'
  '';
  buildPhase = ''
    export VERBOSE=1
    cmake --build . --config Release
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp src/app/friction $out/friction
  '';
  meta = with lib; {
    description = "Vector motion graphics program";
    longDescription =
      "Friction is a powerful and versatile motion graphics application that allows you to create stunning vector and raster animations for web and video platforms with ease.";
    homepage = "https://friction.graphics/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ socksy ];
    mainProgram = "friction";
  };
}
