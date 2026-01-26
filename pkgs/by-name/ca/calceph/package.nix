{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  gfortran,
}:
stdenv.mkDerivation rec {
  pname = "calceph";
  version = "4.0.5";
  src = fetchFromGitLab {
    domain = "gitlab.obspm.fr";
    owner = "imcce_calceph";
    repo = "calceph";
    tag = "calceph_${builtins.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-V4Hh3FItBv3zYerNqNPeRJ5Afj3QTfdG3Ps5xeiDASg=";
  };

  nativeBuildInputs = [
    cmake
    gfortran
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  meta = {
    homepage = "https://www.imcce.fr/inpop/calceph/";
    changelog = "https://gitlab.obspm.fr/imcce_calceph/calceph/-/blob/${src.rev}/NEWS";
    description = "C library for interacting with binary planetary ephemeris files, such INPOPxx, JPL DExxx and SPICE";
    license = with lib.licenses; [
      cecill21
      cecill-b
      cecill-c
    ];
    maintainers = with lib.maintainers; [ kiranshila ];
    platforms = lib.platforms.all;
  };
}
