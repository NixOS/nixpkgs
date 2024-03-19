{ lib, stdenv, fetchFromGitHub, qmake, qtbase, qtsvg, poppler, libzip, pkg-config, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "kitsas";
  version = "4.0.5";

  src = fetchFromGitHub {
    owner = "artoh";
    repo = "kitupiikki";
    rev = "v${version}";
    hash = "sha256-ODl1yrtrCVhuBWbA1AvHl22d+JSdySG/Gi2hlpVW3jg=";
  };

  postPatch = ''
    substituteInPlace kitsas/kitsas.pro \
      --replace "LIBS += -L/usr/local/opt/poppler-qt5/lib -lpoppler-qt6" "LIBS += -lpoppler-qt5"
  '';

  nativeBuildInputs = [ pkg-config qmake wrapQtAppsHook ];

  buildInputs = [ qtsvg poppler libzip ];

  # We use a separate build-dir as otherwise ld seems to get confused between
  # directory and executable name on buildPhase.
  preConfigure = ''
    mkdir build && cd build
  '';

  qmakeFlags = [ "../kitsas/kitsas.pro" ];

  installPhase = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv kitsas.app $out/Applications
  '' + lib.optionalString (!stdenv.isDarwin) ''
    install -Dm755 kitsas -t $out/bin
    install -Dm644 ../kitsas.svg -t $out/share/icons/hicolor/scalable/apps
    install -Dm644 ../kitsas.png -t $out/share/icons/hicolor/256x256/apps
    install -Dm644 ../kitsas.desktop -t $out/share/applications
  '';

  meta = with lib; {
    homepage = "https://github.com/artoh/kitupiikki";
    description = "An accounting tool suitable for Finnish associations and small business";
    mainProgram = "kitsas";
    maintainers = with maintainers; [ gspia ];
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}
