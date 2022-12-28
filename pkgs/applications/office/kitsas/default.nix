{ lib, stdenv, fetchFromGitHub, qmake, qtbase, qtsvg, poppler, libzip, pkg-config, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "kitsas";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "artoh";
    repo = "kitupiikki";
    rev = "v${version}";
    sha256 = "sha256-1gp6CMoDTAp6ORnuk5wos67zygmE9s2pXwvwcR+Hwgg=";
  };

  # QList::swapItemsAt was introduced in Qt 5.13
  patches = lib.optional (lib.versionOlder qtbase.version "5.13") ./qt-512.patch;

  nativeBuildInputs = [ pkg-config qmake wrapQtAppsHook ];

  buildInputs = [ qtsvg poppler libzip ];

  # We use a separate build-dir as otherwise ld seems to get confused between
  # directory and executable name on buildPhase.
  preConfigure = ''
    mkdir build && cd build
  '';

  qmakeFlags = [ "../kitsas/kitsas.pro" ];

  installPhase = if stdenv.isDarwin then ''
    mkdir -p $out/Applications
    mv kitsas.app $out/Applications
  '' else ''
    install -Dm755 kitsas -t $out/bin
    install -Dm644 ../kitsas.svg -t $out/share/icons/hicolor/scalable/apps
    install -Dm644 ../kitsas.png -t $out/share/icons/hicolor/256x256/apps
    install -Dm644 ../kitsas.desktop -t $out/share/applications
  '';

  meta = with lib; {
    homepage = "https://github.com/artoh/kitupiikki";
    description = "An accounting tool suitable for Finnish associations and small business";
    maintainers = with maintainers; [ gspia ];
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
