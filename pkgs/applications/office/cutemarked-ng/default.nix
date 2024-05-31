{ lib
, stdenv
, fetchFromGitHub
, qmake
, pkg-config
, qttools
, qtbase
, qtwebengine
, wrapQtAppsHook
, qmarkdowntextedit
, md4c
, hunspell
}:

stdenv.mkDerivation rec {
  pname = "CuteMarkEd-NG";
  version = "unstable-2021-07-29";

  src = fetchFromGitHub {
    owner = "Waqar144";
    repo = pname;
    rev = "9431ac603cef23d6f29e51e18f1eeee156f5bfb3";
    sha256 = "sha256-w/D4C2ZYgI/7ZCDamTQlhrJ9vtvAMThgM/fopkdKWYc";
  };

  patches = [
    ./0001-remove-dependency-on-vendored-library.patch
    ./0002-use-pkgcofig-to-find-libraries.patch
  ];

  postPatch = ''
    substituteInPlace app/app.pro \
      --replace '$$[QT_INSTALL_BINS]/lrelease' "lrelease"
  '';

  nativeBuildInputs = [
    qmake
    qttools
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    md4c
    qtwebengine
    qmarkdowntextedit
    hunspell.dev
  ];

  meta = with lib; {
    description = "A Qt-based, free and open source markdown editor";
    mainProgram = "cutemarked";
    homepage = "https://github.com/Waqar144/CuteMarkEd-NG";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ rewine ];
    platforms = platforms.linux;
  };
}
