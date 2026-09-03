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
    tag = "v${version}";
    hash = "sha256-9v8ybq+zKGiS5PT/88SYg9lXBclE3bj57FDL3uf4Eqc=";
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
    mainProgram = "fotowall";
  };
}
