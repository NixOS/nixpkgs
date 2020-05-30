{ stdenv, fetchFromGitHub, cmake, wrapQtAppsHook
, qtbase, qtmultimedia, qtx11extras, qttools, qtwebengine
, libidn, qca2-qt5, libsecret, libXScrnSaver, hunspell
, libgcrypt, libotr, html-tidy, libgpgerror, libsignal-protocol-c
}:

stdenv.mkDerivation rec {
  pname = "psi-plus";
  version = "1.4.1231";

  src = fetchFromGitHub {
    owner = "psi-plus";
    repo = "psi-plus-snapshots";
    rev = version;
    sha256 = "0m5p8is8nk3g0cbwiq73cff9nn2y09fcnh1pzc6rlqqhmz1acg4i";
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
