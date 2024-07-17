{
  lib,
  stdenv,
  fetchurl,
  gtk3,
  gtkdatabox,
  fftw,
  gnum4,
  comedilib,
  alsa-lib,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "xoscope";
  version = "2.3";

  src = fetchurl {
    url = "mirror://sourceforge/xoscope/${pname}-${version}.tar.gz";
    sha256 = "0a5ycfc1qdmibvagc82r2mhv2i99m6pndy5i6ixas3j2297g6pgq";
  };

  nativeBuildInputs = [
    pkg-config
    gnum4
  ];
  buildInputs = [
    gtk3
    gtkdatabox
    fftw
    comedilib
    alsa-lib
  ];

  meta = {
    description = "Oscilloscope through the sound card";
    mainProgram = "xoscope";
    homepage = "https://xoscope.sourceforge.net";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ viric ];
    platforms = with lib.platforms; linux;
  };
}
