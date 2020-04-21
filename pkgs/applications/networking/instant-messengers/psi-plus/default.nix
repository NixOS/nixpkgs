{ stdenv, fetchFromGitHub, cmake, wrapQtAppsHook
, qtbase, qtmultimedia, qtx11extras, qttools, qtwebengine
, libidn, qca2-qt5, libsecret, libXScrnSaver, hunspell
, libgcrypt, libotr, html-tidy, libgpgerror, libsignal-protocol-c
}:

stdenv.mkDerivation rec {
  pname = "psi-plus";
  version = "1.4.1086";

  src = fetchFromGitHub {
    owner = "psi-plus";
    repo = "psi-plus-snapshots";
    rev = version;
    sha256 = "0war4hbjs1m7ll6rvpl3lj44lb0p5fi0g2siinnxpjffz2ydi97p";
  };

  cmakeFlags = [
    "-DENABLE_PLUGINS=ON"
  ];

  nativeBuildInputs = [ cmake wrapQtAppsHook ];

  buildInputs = [
    qtbase qtmultimedia qtx11extras qttools qtwebengine
    libidn qca2-qt5 libsecret libXScrnSaver hunspell
    libgcrypt libotr html-tidy libgpgerror libsignal-protocol-c
  ];

  meta = with stdenv.lib; {
    description = "XMPP (Jabber) client";
    maintainers = with maintainers; [ orivej misuzu ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
