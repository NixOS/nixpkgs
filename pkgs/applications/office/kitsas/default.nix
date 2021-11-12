{ lib, mkDerivation, fetchFromGitHub, qmake, qtsvg, qtcreator, poppler, libzip, pkg-config }:

mkDerivation rec {
  pname = "kitsas";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "artoh";
    repo = "kitupiikki";
    rev = "v${version}";
    sha256 = "sha256-UH2bFJZd83APRjlv6JR+Uy+ng4DWnnLmavAgjgSOiRo=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ qmake qtsvg poppler libzip ];

  # We use a separate build-dir as otherwise ld seems to get confused between
  # directory and executable name on buildPhase.
  preConfigure = ''
    mkdir build-linux
    cd build-linux
  '';

  qmakeFlags = [
    "../kitsas/kitsas.pro"
    "-spec"
    "linux-g++"
    "CONFIG+=release"
  ];

  preFixup = ''
    make clean
    rm Makefile
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/applications
    cp kitsas $out/bin
    cp $src/kitsas.png $out/share/applications
    cp $src/kitsas.desktop $out/share/applications
  '';

  meta = with lib; {
    homepage = "https://github.com/artoh/kitupiikki";
    description = "An accounting tool suitable for Finnish associations and small business";
    maintainers = with maintainers; [ gspia ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
