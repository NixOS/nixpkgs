{ stdenv, fetchFromGitHub
, cmake
, qtbase, qtquickcontrols2
, SDL
, python3
}:

stdenv.mkDerivation rec {
  name = "sfxr-qt-${version}";
  version = "1.2.0";
  src = fetchFromGitHub {
    owner = "agateau";
    repo = "sfxr-qt";
    rev = version;
    sha256 = "1ndw1dcmzvkrc6gnb0y057zb4lqlhwrv18jlbx26w3s4xrbxqr41";
    fetchSubmodules = true;
  };
  nativeBuildInputs = [
    cmake
    (python3.withPackages (pp: with pp; [ pyyaml jinja2 ]))
  ];
  buildInputs = [
    qtbase qtquickcontrols2
    SDL
  ];
  configurePhase = "cmake . -DCMAKE_INSTALL_PREFIX=$out";

  meta = with stdenv.lib; {
    homepage = https://github.com/agateau/sfxr-qt;
    description = "A sound effect generator, QtQuick port of sfxr";
    license = licenses.gpl2;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.linux;
  };
}

