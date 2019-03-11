{ stdenv, fetchFromGitHub, cmake
, qt5, libidn, qca2-qt5, libXScrnSaver, hunspell
, libgcrypt, libotr, html-tidy, libgpgerror, libsignal-protocol-c
}:

stdenv.mkDerivation rec {
  name = "psi-plus-${version}";
  version = "1.4.504";

  src = fetchFromGitHub {
    owner = "psi-plus";
    repo = "psi-plus-snapshots";
    rev = "${version}";
    sha256 = "1nv1ynad2gcn7r8mm2w3kixmahaql7xax1lccsqyxqmj1r0klk8q";
  };

  resources = fetchFromGitHub {
    owner = "psi-plus";
    repo = "resources";
    rev = "d623f57db35eb5af81ccdf69b2cbe1c437190f29";
    sha256 = "024cyazyxka5vcbjrkkw32c5zw6aa70n50fdp6zh5v5c51d9ci8k";
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
