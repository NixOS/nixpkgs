{
  lib,
  stdenv,
  fetchurl,
  fltk13,
  libjpeg,
  pkg-config,
}:

stdenv.mkDerivation rec {
  version = "1.3.6";
  pname = "flwrap";

  src = fetchurl {
    url = "mirror://sourceforge/fldigi/${pname}-${version}.tar.gz";
    sha256 = "sha256-g1V7bOcgVHpD+Ndn02Nj4I3rGItuQ2qLGlrZZshfGP8=";
  };

  buildInputs = [
    fltk13
    libjpeg
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  meta = with lib; {
    description = "Digital modem file transfer program";
    homepage = "https://sourceforge.net/projects/fldigi/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dysinger ];
    platforms = platforms.linux;
    mainProgram = "flwrap";
  };
}
