{
  lib,
  stdenv,
  writeScriptBin,
  fetchFromGitHub,
  cjson,
  cmake,
  curl,
  freetype,
  glew,
  libjpeg,
  libogg,
  libpng,
  libtheora,
  libX11,
  lua5_4,
  minizip,
  openal,
  SDL2,
  sqlite,
  zlib,
}:
let
  version = "2.83.2";
  fakeGit = writeScriptBin "git" ''
    if [ "$1" = "describe" ]; then
      echo "${version}"
    fi
  '';
in
stdenv.mkDerivation {
  pname = "etlegacy-unwrapped";
  inherit version;

  src = fetchFromGitHub {
    owner = "etlegacy";
    repo = "etlegacy";
    tag = "v${version}";
    hash = "sha256-hZwLYaYV0j3YwFi8KRr4DZV73L2yIwFJ3XqCyq6L7hE=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    fakeGit
  ];

  buildInputs = [
    cjson
    curl
    freetype
    glew
    libjpeg
    libogg
    libpng
    libtheora
    libX11
    lua5_4
    minizip
    openal
    SDL2
    sqlite
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeBool "CROSS_COMPILE32" false)
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "Release")
    (lib.cmakeBool "BUILD_SERVER" true)
    (lib.cmakeBool "BUILD_CLIENT" true)
    (lib.cmakeBool "BUNDLED_ZLIB" false)
    (lib.cmakeBool "BUNDLED_CJSON" false)
    (lib.cmakeBool "BUNDLED_JPEG" false)
    (lib.cmakeBool "BUNDLED_LIBS" false)
    (lib.cmakeBool "BUNDLED_LIBS_DEFAULT" false)
    (lib.cmakeBool "BUNDLED_FREETYPE" false)
    (lib.cmakeBool "BUNDLED_OGG_VORBIS" false)
    (lib.cmakeBool "BUNDLED_OPENAL" false)
    (lib.cmakeBool "BUNDLED_PNG" false)
    (lib.cmakeBool "BUNDLED_THEORA" false)
    (lib.cmakeBool "BUNDLED_MINIZIP" false)
    (lib.cmakeBool "CLIENT_GLVND" true)
    (lib.cmakeBool "ENABLE_SSE" true)
    (lib.cmakeBool "INSTALL_EXTRA" false)
    (lib.cmakeBool "INSTALL_OMNIBOT" false)
    (lib.cmakeBool "INSTALL_GEOIP" false)
    (lib.cmakeBool "INSTALL_WOLFADMIN" false)
    (lib.cmakeBool "FEATURE_AUTOUPDATE" false)
    (lib.cmakeBool "FEATURE_RENDERER2" false)
    (lib.cmakeFeature "INSTALL_DEFAULT_BASEDIR" "${placeholder "out"}/lib/etlegacy")
    (lib.cmakeFeature "INSTALL_DEFAULT_BINDIR" "${placeholder "out"}/bin")
  ];

  meta = {
    description = "ET: Legacy is an open source project based on the code of Wolfenstein: Enemy Territory which was released in 2010 under the terms of the GPLv3 license";
    homepage = "https://etlegacy.com";
    license = with lib.licenses; [ gpl3Plus ];
    longDescription = ''
      ET: Legacy, an open source project fully compatible client and server
      for the popular online FPS game Wolfenstein: Enemy Territory - whose
      gameplay is still considered unmatched by many, despite its great age.
    '';
    maintainers = with lib.maintainers; [
      ashleyghooper
    ];
  };
}
