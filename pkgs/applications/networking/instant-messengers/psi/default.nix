{ stdenv, fetchFromGitHub, cmake, wrapQtAppsHook
, qtbase, qtmultimedia, qtx11extras, qttools, qtwebengine
, libidn, qca2-qt5, libXScrnSaver, hunspell
}:
stdenv.mkDerivation rec {
  pname = "psi";
  version = "1.4";
  src = fetchFromGitHub {
    owner = "psi-im";
    repo = pname;
    rev = version;
    sha256 = "09c7cg96vgxzgbpypgcw7yv73gvzppbi1lm4svbpfn2cfxy059d4";
    fetchSubmodules = true;
  };
  patches = [
    ./fix-cmake-hunspell-1.7.patch
  ];
  nativeBuildInputs = [ cmake wrapQtAppsHook ];
  buildInputs = [
    qtbase qtmultimedia qtx11extras qttools qtwebengine
    libidn qca2-qt5 libXScrnSaver hunspell
  ];
  enableParallelBuilding = true;
  meta = with stdenv.lib; {
    description = "Psi, an XMPP (Jabber) client";
    maintainers = [ maintainers.raskin ];
    license = licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
