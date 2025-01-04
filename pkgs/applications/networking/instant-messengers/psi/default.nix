{
  lib,
  mkDerivation,
  fetchFromGitHub,
  cmake,
  qtbase,
  qtmultimedia,
  qtx11extras,
  qttools,
  qtwebengine,
  libidn,
  qca-qt5,
  libXScrnSaver,
  hunspell,
}:

mkDerivation rec {
  pname = "psi";
  version = "1.5";
  src = fetchFromGitHub {
    owner = "psi-im";
    repo = pname;
    rev = version;
    sha256 = "hXDZODHl14kimRlMQ1XjISQ2kk9NS78axVN3U21wkuM=";
    fetchSubmodules = true;
  };
  patches = [
    ./fix-cmake-hunspell-1.7.patch
  ];
  nativeBuildInputs = [
    cmake
    qttools
  ];
  buildInputs = [
    qtbase
    qtmultimedia
    qtx11extras
    qtwebengine
    libidn
    qca-qt5
    libXScrnSaver
    hunspell
  ];

  meta = with lib; {
    homepage = "https://psi-im.org";
    description = "XMPP (Jabber) client";
    mainProgram = "psi";
    maintainers = [ maintainers.raskin ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
