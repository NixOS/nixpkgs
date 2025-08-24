{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  freetype,
  glib,
  libjpeg,
  libpng,
  libxml2,
  uthash,
  zeromq,
  zlib,
  fontforge,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fontforge";
  # Follow https://github.com/pdf2htmlEX/pdf2htmlEX/blob/v0.18.8.rc1/buildScripts/versionEnvs
  version = "20200314";

  src = fetchFromGitHub {
    owner = "fontforge";
    repo = "fontforge";
    tag = finalAttrs.version;
    hash = "sha256-QygbZVJLel+QKTdJSO2hIzA1JgcUDsOOF67O35t4uxw=";
  };

  patches = [
    # Unreleased fix for https://github.com/fontforge/fontforge/issues/4229
    # which is required to fix an uninterposated `${CMAKE_INSTALL_PREFIX}/lib`, see
    # see https://github.com/nh2/static-haskell-nix/pull/98#issuecomment-665395399
    # TODO: Remove https://github.com/fontforge/fontforge/pull/4232 is in a release.
    (fetchpatch {
      name = "fontforge-cmake-set-rpath-to-the-configure-time-CMAKE_INSTALL_PREFIX";
      url = "https://github.com/fontforge/fontforge/commit/297ee9b5d6db5970ca17ebe5305189e79a1520a1.patch";
      hash = "sha256-E8/SsYytYLE4pmDpQBULjCILu2FWYEhW/H8DyC+6DpM=";
    })
  ];

  # https://github.com/fontforge/fontforge/issues/5251
  postPatch = ''
    rm -fv po/{fr,it}.po
    substituteInPlace po/LINGUAS \
      --replace-fail "fr" "" \
      --replace-fail "it" ""
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    freetype
    glib
    libjpeg
    libpng
    libxml2
    uthash
    zeromq
    zlib
  ];

  # Follow https://github.com/pdf2htmlEX/pdf2htmlEX/blob/v0.18.8.rc1/buildScripts/buildFontforge
  cmakeFlags = with lib; [
    (cmakeBool "BUILD_SHARED_LIBS" false)
    (cmakeBool "ENABLE_GUI" false)
    (cmakeBool "ENABLE_X11" false)
    (cmakeBool "ENABLE_NATIVE_SCRIPTING" true)
    (cmakeBool "ENABLE_PYTHON_SCRIPTING" false)
    (cmakeBool "ENABLE_PYTHON_EXTENSION" false)
    (cmakeBool "ENABLE_LIBSPIRO" false)
    (cmakeBool "ENABLE_LIBUNINAMESLIST" false)
    (cmakeBool "ENABLE_LIBGIF" false)
    (cmakeBool "ENABLE_LIBJPEG" true)
    (cmakeBool "ENABLE_LIBPNG" true)
    (cmakeBool "ENABLE_LIBREADLINE" false)
    (cmakeBool "ENABLE_LIBTIFF" false)
    (cmakeBool "ENABLE_WOFF2" false)
    (cmakeBool "ENABLE_DOCS" false)
    (cmakeBool "ENABLE_CODE_COVERAGE" false)
    (cmakeBool "ENABLE_DEBUG_RAW_POINTS" false)
    (cmakeBool "ENABLE_FONTFORGE_EXTRAS" false)
    (cmakeBool "ENABLE_MAINTAINER_TOOLS" false)
    (cmakeBool "ENABLE_TILE_PATH" false)
    (cmakeBool "ENABLE_WRITE_PFM" false)
    (cmakeFeature "ENABLE_SANITIZER" "none")
    (cmakeFeature "ENABLE_FREETYPE_DEBUGGER" "")
    (cmakeBool "SPHINX_USE_VENV" false)
    (cmakeFeature "REAL_TYPE" "double")
    (cmakeFeature "THEME" "tango")
  ];

  postInstall = ''
    install -Dvm644 -t $out/lib/ ./lib/libfontforge.a
    install -Dvm644 -t $out/include/ ./inc/*.h
  '';

  meta = fontforge.meta // {
    maintainers = with lib.maintainers; [
      Cryolitia
    ];
  };
})
