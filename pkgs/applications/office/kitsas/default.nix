{ lib
, stdenv
, fetchFromGitHub
, qmake
, qtsvg
, qtwebengine
, qt5compat
, poppler
, libzip
, pkg-config
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "kitsas";
  version = "5.7";

  src = fetchFromGitHub {
    owner = "artoh";
    repo = "kitupiikki";
    rev = "v${version}";
    hash = "sha256-1TZFw1Q9+FsGHwitErDhwyA941rtb+h9OgJLFLyhV7k=";
  };

  nativeBuildInputs = [ pkg-config qmake wrapQtAppsHook ];

  buildInputs = [ qtsvg poppler qtwebengine qt5compat libzip ];

  # We use a separate build-dir as otherwise ld seems to get confused between
  # directory and executable name on buildPhase.
  preConfigure = ''
    mkdir build && cd build
  '';

  qmakeFlags = [ "../kitsas/kitsas.pro" ];

  installPhase = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    mv kitsas.app $out/Applications
  '' + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    install -Dm755 kitsas -t $out/bin
    install -Dm644 ../kitsas.svg -t $out/share/icons/hicolor/scalable/apps
    install -Dm644 ../kitsas.png -t $out/share/icons/hicolor/256x256/apps
    install -Dm644 ../kitsas.desktop -t $out/share/applications
  '';

  meta = with lib; {
    homepage = "https://github.com/artoh/kitupiikki";
    description = "Accounting tool suitable for Finnish associations and small business";
    mainProgram = "kitsas";
    maintainers = with maintainers; [ gspia ];
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
