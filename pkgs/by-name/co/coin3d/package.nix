{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  cmake,
  libGL,
  libGLU,
  libx11,
  expat,
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

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost
    libGL
    libGLU
    expat
    zlib
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux libx11;

  cmakeFlags = [
    (lib.cmakeBool "USE_EXTERNAL_EXPAT" true)
    # Coin dlopens zlib by bare name at runtime otherwise, which never resolves
    # on NixOS, so gzip-compressed VRML (.wrz) silently fails to load.
    (lib.cmakeBool "ZLIB_RUNTIME_LINKING" false)
  ];

  meta = {
    homepage = "https://github.com/coin3d/coin";
    description = "High-level, retained-mode toolkit for effective 3D graphics development";
    mainProgram = "coin-config";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mornepousse ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
