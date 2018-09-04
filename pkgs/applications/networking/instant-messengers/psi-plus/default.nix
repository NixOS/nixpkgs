{ stdenv, fetchFromGitHub, cmake
, qt5, libidn, qca2-qt5, libXScrnSaver, hunspell
, libgcrypt, libotr, html-tidy, libgpgerror
}:

stdenv.mkDerivation rec {
  name = "psi-plus-${version}";
  version = "1.2.235";

  src = fetchFromGitHub {
    owner = "psi-plus";
    repo = "psi-plus-snapshots";
    rev = "${version}";
    sha256 = "0rc65gs6m3jxg407r99kikdylvrar5mq7x5m66ma604yk5igwg47";
  };

  resources = fetchFromGitHub {
    owner = "psi-plus";
    repo = "resources";
    rev = "8f5038380e1be884b04b5a1ad3cc3385e793f668";
    sha256 = "1b8a2aixg966fzjwp9hz51rc31imyvpx014mp2fsm47k8na4470d";
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
    libgcrypt libotr html-tidy libgpgerror
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "XMPP (Jabber) client";
    maintainers = with maintainers; [ orivej ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
