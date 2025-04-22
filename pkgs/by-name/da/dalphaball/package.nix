{
  lib,
  stdenv,
  fetchFromGitHub,
  gfortran,
  gmp,
}:

stdenv.mkDerivation rec {
  pname = "dalphaball";
  version = "0-unstable-2023-06-15";

  src = fetchFromGitHub {
    owner = "outpace-bio";
    repo = "DAlphaBall";
    rev = "7b9dc05fa2a40f7ea36c6d89973d150eaed459d9";
    hash = "sha256-mUxEL9b67z/mG+0pcM5uQ/jPAfEUpJlXOXPmqDea+U4=";
  };

  sourceRoot = "${src.name}/src";
  strictDeps = true;

  nativeBuildInputs = [
    gfortran
  ];

  buildInputs = [
    gfortran.cc.lib
    gmp
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 DAlphaBall.gcc $out/bin/DAlphaBall
    runHook postInstall
  '';

  meta = {
    description = "Computes the surface area and volume of unions of many balls";
    mainProgram = "DAlphaBall";
    homepage = "https://github.com/outpace-bio/DAlphaBall";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ aschleck ];
    platforms = lib.platforms.unix;
  };
}
