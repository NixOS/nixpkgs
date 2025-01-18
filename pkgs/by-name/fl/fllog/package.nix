{
  lib,
  stdenv,
  fetchurl,
  fltk13,
  libjpeg,
  pkg-config,
}:

stdenv.mkDerivation rec {
  version = "1.2.8";
  pname = "fllog";

  src = fetchurl {
    url = "mirror://sourceforge/fldigi/${pname}-${version}.tar.gz";
    sha256 = "sha256-kJLb1ifd8sUOwGgNsIEmlhH29fQLdTfDMjKLrzK7r1I=";
  };

  buildInputs = [
    fltk13
    libjpeg
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  meta = with lib; {
    description = "Digital modem log program";
    homepage = "https://sourceforge.net/projects/fldigi/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dysinger ];
    platforms = platforms.linux;
    mainProgram = "fllog";
  };
}
