{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "openfx";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "openfx";
    rev = "OFX_Release_1.5.1";
    hash = "sha256-qiY5klmGDiU9cqjfNdFsCcNqSBwV0dVZB2ZIsElRBD4=";
  };

  outputs = [
    "dev"
    "out"
  ];

  enableParallelBuilding = true;

  buildPhase = ''
    mkdir $dev
    mkdir $out
  '';

  installPhase = ''
    mkdir -p $dev/include/OpenFX/
    cp -r include/* $dev/include/OpenFX/
  '';

  meta = {
    description = "Image processing plug-in standard";
    homepage = "https://openeffects.org/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.guibou ];
  };
}
