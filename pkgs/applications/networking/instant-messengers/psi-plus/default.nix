{ lib, mkDerivation, fetchFromGitHub, cmake
, qtbase, qtmultimedia, qtx11extras, qttools, qtwebengine
, libidn, qca-qt5, libXScrnSaver, hunspell
, libsecret, libgcrypt, libotr, html-tidy, libgpgerror, libsignal-protocol-c
, usrsctp
}:

mkDerivation rec {
  pname = "psi-plus";
  version = "1.5.1520";

  src = fetchFromGitHub {
    owner = "psi-plus";
    repo = "psi-plus-snapshots";
    rev = version;
    sha256 = "0cj811qv0n8xck2qrnps2ybzrpvyjqz7nxkyccpaivq6zxj6mc12";
  };

  cmakeFlags = [
    "-DENABLE_PLUGINS=ON"
  ];

  nativeBuildInputs = [ cmake qttools ];

  buildInputs = [
    qtbase qtmultimedia qtx11extras qtwebengine
    libidn qca-qt5 libXScrnSaver hunspell
    libsecret libgcrypt libotr html-tidy libgpgerror libsignal-protocol-c
    usrsctp
  ];

  meta = with lib; {
    homepage = "https://psi-plus.com";
    description = "XMPP (Jabber) client";
    maintainers = with maintainers; [ orivej misuzu ];
    license = licenses.gpl2Only;
    platforms = platforms.linux;
  };
}
