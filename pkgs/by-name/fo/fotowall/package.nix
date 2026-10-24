{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  qt6,
}:

stdenv.mkDerivation rec {
  pname = "fotowall";
  version = "1.1.4";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fotowall";
    repo = "fotowall";
    rev = "v${version}";
    hash = "sha256-1aFHHt1DtjtEF5NievhlzVR1JbUS+3W98Klfi5bcPSk=";
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
  ];

  meta = {
    description = "Pictures collage & creativity tool";
    homepage = "https://github.com/fotowall/fotowall";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "fotowall";
  };
}
