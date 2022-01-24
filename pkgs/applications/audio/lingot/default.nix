{ lib, stdenv
, fetchurl
, pkg-config
, intltool
, gtk3
, wrapGAppsHook
, alsa-lib
, libjack2
, libpulseaudio
, fftw
, jackSupport ? true
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
    alsa-lib
    libpulseaudio
    fftw
  ] ++ lib.optional jackSupport libjack2;

  configureFlags = lib.optional (!jackSupport) "--disable-jack";

  meta = {
    description = "Not a Guitar-Only tuner";
    homepage = "https://www.nongnu.org/lingot/";
    license = lib.licenses.gpl2Plus;
    platforms = with lib.platforms; linux;
    maintainers = with lib.maintainers; [ viric ];
  };
}
