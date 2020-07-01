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
    sha256 = "03x0qqb9iarjapvii3ja522vkxrqv1hwix6b1r53is48p5xwgf3i";
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
