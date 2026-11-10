{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  cmake,
  fontconfig,
  freetype,
  libGL,
  libGLU,
  libx11,
  expat,
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

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost
    fontconfig
    freetype
    libGL
    libGLU
    expat
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux libx11;

  cmakeFlags = [
    (lib.cmakeBool "USE_EXTERNAL_EXPAT" true)
  ];

  postFixup =
    lib.optionalString (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.hasSharedLibraries)
      ''
        patchelf --add-rpath ${
          lib.makeLibraryPath [
            libGLU
            freetype
            fontconfig
          ]
        } "$out/lib/libCoin.so"
      '';

  meta = {
    homepage = "https://github.com/coin3d/coin";
    description = "High-level, retained-mode toolkit for effective 3D graphics development";
    mainProgram = "coin-config";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
