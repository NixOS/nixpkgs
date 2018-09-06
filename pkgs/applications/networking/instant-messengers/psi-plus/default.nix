{ stdenv, fetchFromGitHub, cmake
, qt5, libidn, qca2-qt5, libXScrnSaver, hunspell
, libgcrypt, libotr, html-tidy, libgpgerror, libsignal-protocol-c
}:

stdenv.mkDerivation rec {
  name = "psi-plus-${version}";
  version = "1.3.410";

  src = fetchFromGitHub {
    owner = "psi-plus";
    repo = "psi-plus-snapshots";
    rev = "${version}";
    sha256 = "02m984z2dfmlx522q9x1z0aalvi2mi48s5ghhs80hr5afnfyc5w6";
  };

  resources = fetchFromGitHub {
    owner = "psi-plus";
    repo = "resources";
    rev = "c0bfb8a025eeec82cd0a23a559e0aa3da15c3ec3";
    sha256 = "1q7v01w085vk7ml6gwis7j409w6f5cplpm7c0ajs4i93c4j53xdf";
  };

  postUnpack = ''
    cp -a "${resources}/iconsets" "$sourceRoot"
  '';

  cmakeFlags = [
    "-DENABLE_PLUGINS=ON"
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    qt5.qtbase qt5.qtmultimedia qt5.qtx11extras qt5.qttools qt5.qtwebkit
    libidn qca2-qt5 libXScrnSaver hunspell
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
