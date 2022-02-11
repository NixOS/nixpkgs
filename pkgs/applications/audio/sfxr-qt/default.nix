{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, extra-cmake-modules
, qtbase
, qtquickcontrols2
, SDL
, python3
}:

mkDerivation rec {
  pname = "sfxr-qt";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "agateau";
    repo = "sfxr-qt";
    rev = version;
    sha256 = "sha256-Mn+wcwu70BwsTLFlc12sOOe6U1AJ8hR7bCIPlPnCooE=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    (python3.withPackages (pp: with pp; [ pyyaml jinja2 setuptools ]))
  ];

  buildInputs = [
    qtbase
    qtquickcontrols2
    SDL
  ];

  meta = with lib; {
    homepage = "https://github.com/agateau/sfxr-qt";
    description = "A sound effect generator, QtQuick port of sfxr";
    license = licenses.gpl2;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.linux;
  };
}
