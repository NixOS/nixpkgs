{
  mkDerivation,
  lib,
  fetchFromGitHub,
  alsa-lib,
  pkg-config,
  qtbase,
  qtscript,
  qmake,
}:

mkDerivation rec {
  pname = "iannix";
  version = "unstable-2020-12-09";

  src = fetchFromGitHub {
    owner = "iannix";
    repo = "IanniX";
    rev = "287b51d9b90b3e16ae206c0c4292599619f7b159";
    sha256 = "AhoP+Ok78Vk8Aee/RP572hJeM8O7v2ZTvFalOZZqRy8=";
  };

  nativeBuildInputs = [
    pkg-config
    qmake
  ];
  buildInputs = [
    alsa-lib
    qtbase
    qtscript
  ];

  qmakeFlags = [ "PREFIX=/" ];

  installFlags = [ "INSTALL_ROOT=$(out)" ];

  meta = with lib; {
    description = "Graphical open-source sequencer";
    mainProgram = "iannix";
    homepage = "https://www.iannix.org/";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ freezeboy ];
  };
}
