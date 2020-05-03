{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, qtbase
, qtquickcontrols2
, SDL
, python3
}:

mkDerivation rec {
  pname = "sfxr-qt";
  version = "1.3.0";
  src = fetchFromGitHub {
    owner = "agateau";
    repo = "sfxr-qt";
    rev = version;
    sha256 = "15yjgjl1c5k816mnpc09104zq0ack2a3mjsxmhcik7cmjkfiipr5";
    fetchSubmodules = true;
  };
  nativeBuildInputs = [
    cmake
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

