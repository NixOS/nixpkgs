{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  qt6,
}:

stdenv.mkDerivation rec {
  pname = "fotowall";
  version = "1.1.0";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fotowall";
    repo = "fotowall";
    rev = "v${version}";
    hash = "sha256-3zgZ9yuS7N/pqWF9CczMSjWb1afMFaNYPRgwEo/AZp8=";
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
