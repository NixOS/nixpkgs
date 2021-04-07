{ mkDerivation, lib, fetchFromGitHub, cmake
, qtbase, qtmultimedia, qtx11extras, qttools, qtwebengine
, libidn, qca-qt5, libsecret, libXScrnSaver, hunspell
, libgcrypt, libotr, html-tidy, libgpgerror, libsignal-protocol-c
}:

mkDerivation rec {
  pname = "psi-plus";
  version = "1.4.1473";

  src = fetchFromGitHub {
    owner = "psi-plus";
    repo = "psi-plus-snapshots";
    rev = version;
    sha256 = "03f28zwbjn6fnsm0fqg8lmc11rpfdfvzjf7k7xydc3lzy8pxbds5";
  };

  cmakeFlags = [
    "-DENABLE_PLUGINS=ON"
  ];

  nativeBuildInputs = [ cmake qttools ];

  buildInputs = [
    qtbase qtmultimedia qtx11extras qtwebengine
    libidn qca-qt5 libsecret libXScrnSaver hunspell
    libgcrypt libotr html-tidy libgpgerror libsignal-protocol-c
  ];

  meta = with lib; {
    homepage = "https://sourceforge.net/projects/psiplus/";
    description = "XMPP (Jabber) client";
    maintainers = with maintainers; [ orivej misuzu ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
