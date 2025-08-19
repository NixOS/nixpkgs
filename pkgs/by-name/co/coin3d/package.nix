{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  cmake,
  libGL,
  libGLU,
  libX11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "coin";
  version = "4.0.5";

  src = fetchFromGitHub {
    owner = "coin3d";
    repo = "coin";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2lfy33Qx0AjKDfwwRn7hjaz7mPQsr7MRB9v75qshGjM=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost
    libGL
    libGLU
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux libX11;

  cmakeFlags = [ "-DCOIN_USE_CPACK=OFF" ];

  meta = with lib; {
    homepage = "https://github.com/coin3d/coin";
    description = "High-level, retained-mode toolkit for effective 3D graphics development";
    mainProgram = "coin-config";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux ++ platforms.darwin;
  };
})
