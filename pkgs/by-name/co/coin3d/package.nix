{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  boost,
  cmake,
  libGL,
  libGLU,
  libx11,
  expat,
  freetype,
  fontconfig,
  openal,
  bzip2,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "coin";
  version = "4.0.10";

  src = fetchFromGitHub {
    owner = "coin3d";
    repo = "coin";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Zymizcj+HeNgvvuuIoIHf03I0suOyWGOBIqvnjx5qyw=";
  };

  patches = [
    (fetchpatch {
      # remove next release
      # fixes fontconfig linking for FONTCONFIG_RUNTIME_LINKING=OFF
      url = "https://github.com/coin3d/coin/commit/fbd7ad614b06e0ab60dacd976ded0d8a6dd9f0fb.patch";
      hash = "sha256-uS1UGwwy5FW7GKu5Vd/icW16uOBxigZIhLtYUK3gQzQ=";
    })
    # cmake doesn't actually set HAVE_GLU if EGL is enabled
    # fixing that, it also checks for the wrong spelling
    # Upstream doesn't run into this issue as HAVE_GLU is ignored if glu is loaded via dlopen,
    # as is the default configuration. We disable dlopen here though.
    # https://github.com/coin3d/coin/pull/847
    ./set-have-glu.patch
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost
    libGL
    libGLU
    expat
    freetype
    fontconfig
    openal
    bzip2
    zlib
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux libx11;

  cmakeFlags = [
    (lib.cmakeBool "USE_EXTERNAL_EXPAT" true) # don't use vendored expat. Vendored is 2.2.10, which has various security issues.
    (lib.cmakeBool "COIN_HAVE_JAVASCRIPT" false) # don't pull in spidermonkey

    # don't rely on dlopen for a bunch of stuff
    # this allows us to not mess around with rpath, instead properly linking these libraries
    (lib.cmakeBool "FREETYPE_RUNTIME_LINKING" false)
    (lib.cmakeBool "FONTCONFIG_RUNTIME_LINKING" false)
    (lib.cmakeBool "LIBBZIP2_RUNTIME_LINKING" false)
    (lib.cmakeBool "OPENAL_RUNTIME_LINKING" false)
    (lib.cmakeBool "ZLIB_RUNTIME_LINKING" false)
    (lib.cmakeBool "GLU_RUNTIME_LINKING" false)
  ];

  meta = {
    homepage = "https://github.com/coin3d/coin";
    description = "High-level, retained-mode toolkit for effective 3D graphics development";
    mainProgram = "coin-config";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
