{ stdenv, fetchFromGitHub, cmake, wrapQtAppsHook
, qtbase, qtmultimedia, qtx11extras, qttools, qtwebengine
, libidn, qca2-qt5, libsecret, libXScrnSaver, hunspell
, libgcrypt, libotr, html-tidy, libgpgerror, libsignal-protocol-c
}:

stdenv.mkDerivation rec {
  pname = "psi-plus";
  version = "1.4.984";

  src = fetchFromGitHub {
    owner = "psi-plus";
    repo = "psi-plus-snapshots";
    rev = version;
    sha256 = "1nii2nfi37i6mn79xmygscmm8ax75ky244wxkzlga0ya8i8wfjh7";
  };

  resources = fetchFromGitHub {
    owner = "psi-plus";
    repo = "resources";
    rev = "2f1c12564f7506bf902a26040fdb47ead4df6b73";
    sha256 = "1dgm9k052fq7f2bpx13kchg7sxb227dkn115lyspzvhnhprnypz2";
  };

  postUnpack = ''
    cp -a "${resources}/iconsets" "$sourceRoot"
  '';

  cmakeFlags = [
    "-DENABLE_PLUGINS=ON"
  ];

  nativeBuildInputs = [ cmake wrapQtAppsHook ];

  buildInputs = [
    qtbase qtmultimedia qtx11extras qttools qtwebengine
    libidn qca2-qt5 libsecret libXScrnSaver hunspell
    libgcrypt libotr html-tidy libgpgerror libsignal-protocol-c
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "XMPP (Jabber) client";
    maintainers = with maintainers; [ orivej misuzu ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
