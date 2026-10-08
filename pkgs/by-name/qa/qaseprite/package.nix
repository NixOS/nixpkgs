{
  lib,
  stdenv,
  cmake,
  fetchzip,
  freetype,
  harfbuzz,
  libxcursor,
  libxi,
  libpng,
  libsForQt5,
  ninja,
  pixman,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qaseprite";
  version = "1.0.3";

  __structuredAttrs = true;

  src = fetchzip {
    url = "https://github.com/mapeditor/qaseprite/releases/download/${finalAttrs.version}/qaseprite-${finalAttrs.version}-source.tar.gz";
    hash = "sha256-plRmszRdGISL0Iu59Dh8JlmfTIwcJt/TjoBy8wfPLPA=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    freetype
    harfbuzz
    libxcursor
    libxi
    libpng
    libsForQt5.qtbase
    pixman
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_CCACHE" false)
    (lib.cmakeBool "USE_SHARED_ZLIB" true)
    (lib.cmakeBool "USE_SHARED_LIBPNG" true)
    (lib.cmakeBool "USE_SHARED_PIXMAN" true)
    (lib.cmakeBool "USE_SHARED_FREETYPE" true)
    (lib.cmakeBool "USE_SHARED_HARFBUZZ" true)
    (lib.cmakeFeature "HARFBUZZ_INCLUDE_DIRS" "${lib.getDev harfbuzz}/include/harfbuzz")
    (lib.cmakeFeature "QT_PLUGIN_PATH" "${placeholder "out"}/${libsForQt5.qtbase.qtPluginPrefix}")
  ];

  dontWrapQtApps = true;

  strictDeps = true;

  meta = {
    description = "Qt image format plugin for reading Aseprite images";
    homepage = "https://github.com/mapeditor/qaseprite";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ayushthoren ];
    platforms = lib.platforms.linux;
  };
})
