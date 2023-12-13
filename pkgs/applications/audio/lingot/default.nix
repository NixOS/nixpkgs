{ lib
, stdenv
, fetchurl
, pkg-config
, intltool
, wrapGAppsHook
, gtk3
, alsa-lib
, libpulseaudio
, fftw
, fftwFloat
, json_c
, libjack2
, jackSupport ? true
}:

stdenv.mkDerivation rec {
  pname = "lingot";
  version = "1.1.1";

  src = fetchurl {
    url = "mirror://savannah/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-xPl+SWo2ZscHhtE25vLMxeijgT6wjNo1ys1+sNFvTVY=";
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
    fftwFloat
    json_c
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
