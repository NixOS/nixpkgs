{ stdenv
, fetchgit
, automake
, alsaLib
, ladspaH
, libjack2
, fftw
, zita-alsa-pcmi
, qt5
, pkg-config
, autoreconfHook
}:

stdenv.mkDerivation rec {
  name = "ams";
  version = "unstable-2019-04-27";

  src = fetchgit {
    url = "https://git.code.sf.net/p/alsamodular/ams.git";
    sha256 = "0qdyz5llpa94f3qx1xi1mz97vl5jyrj1mqff28p5g9i5rxbbk8z9";
    rev = "3250bbcfea331c4fcb9845305eebded80054973d";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    alsaLib
    ladspaH
    libjack2
    fftw
    zita-alsa-pcmi
  ] ++ (with qt5; [
    qtbase
    qttools
  ]);

  meta = with stdenv.lib; {
    description = "Realtime modular synthesizer for ALSA";
    homepage = "http://alsamodular.sourceforge.net";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ sjfloat ];
  };
}
