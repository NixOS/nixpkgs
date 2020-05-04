{ stdenv
, fetchurl
, pkg-config
, intltool
, gtk3
, wrapGAppsHook
, alsaLib
, libpulseaudio
, fftw
}:

stdenv.mkDerivation rec {
  pname = "lingot";
  version = "1.0.1";

  src = fetchurl {
    url = "mirror://savannah/${pname}/${pname}-${version}.tar.gz";
    sha256 = "cbjHe7mI6DhKDsv0yGHYOPe5hShKjhj3VTKrmBbGoA8=";
  };

  nativeBuildInputs = [
    pkg-config
    intltool
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    alsaLib
    libpulseaudio
    fftw
  ];

  configureFlags = [
    "--disable-jack"
  ];

  meta = {
    description = "Not a Guitar-Only tuner";
    homepage = "https://www.nongnu.org/lingot/";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [ viric ];
  };
}
