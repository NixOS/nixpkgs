{
  lib,
  stdenv,
  fetchurl,
  fltk13,
  libjpeg,
  pkg-config,
}:

stdenv.mkDerivation rec {
  version = "4.0.23";
  pname = "flmsg";

  src = fetchurl {
    url = "mirror://sourceforge/fldigi/${pname}-${version}.tar.gz";
    sha256 = "sha256-3eR0wrzkNjlqm5xW5dtgihs33cVUmZeS0/rf+xnPeRY=";
  };

  buildInputs = [
    fltk13
    libjpeg
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  meta = with lib; {
    description = "Digital modem message program";
    homepage = "https://sourceforge.net/projects/fldigi/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dysinger ];
    platforms = platforms.linux;
    mainProgram = "flmsg";
  };
}
