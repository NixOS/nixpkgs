{
  lib,
  stdenv,
  fetchurl,
  fltk13,
  libjpeg,
  pkg-config,
}:

stdenv.mkDerivation rec {
  version = "1.2.9";
  pname = "fllog";

  src = fetchurl {
    url = "mirror://sourceforge/fldigi/${pname}-${version}.tar.gz";
    sha256 = "sha256-3eJvT9PjHTrMn0/pArUDIIE7T7y1YnayG5PuGokwtRk=";
  };

  buildInputs = [
    fltk13
    libjpeg
  ];

  nativeBuildInputs = [
    fltk13 # fltk-config
    pkg-config
  ];

  meta = {
    description = "Digital modem log program";
    homepage = "https://sourceforge.net/projects/fldigi/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dysinger ];
    platforms = lib.platforms.linux;
    mainProgram = "fllog";
  };
}
