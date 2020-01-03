{ stdenv, fetchFromGitHub, cmake
, qtbase, qtmultimedia, qtx11extras, qttools, qtwebengine
, libidn, qca2-qt5, qtkeychain, libXScrnSaver, hunspell
, libgcrypt, libotr, html-tidy, libgpgerror, libsignal-protocol-c
}:

stdenv.mkDerivation rec {
  pname = "psi-plus";
  version = "1.4.904";

  src = fetchFromGitHub {
    owner = "psi-plus";
    repo = "psi-plus-snapshots";
    rev = version;
    sha256 = "1bs7yk3qp91sm8nb9gna8vm59381afn1wfs7aii9yi29bhx6fw9h";
  };

  resources = fetchFromGitHub {
    owner = "psi-plus";
    repo = "resources";
    rev = "182c92ca0bcc055579d8c91bccba9efe157e77a9";
    sha256 = "06k7q63cxpifpzjnlw1snclkr2mwf9fh71cgfd40n7jgzswzwhpb";
  };

  postUnpack = ''
    cp -a "${resources}/iconsets" "$sourceRoot"
  '';

  cmakeFlags = [
    "-DENABLE_PLUGINS=ON"
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    qtbase qtmultimedia qtx11extras qttools qtwebengine
    libidn qca2-qt5 qtkeychain libXScrnSaver hunspell
    libgcrypt libotr html-tidy libgpgerror libsignal-protocol-c
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "XMPP (Jabber) client";
    maintainers = with maintainers; [ orivej ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
