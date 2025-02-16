{
  lib,
  stdenv,
  fetchurl,
  ladspaH,
  libjack2,
  liblo,
  alsa-lib,
  libX11,
  libsndfile,
  libSM,
  libsamplerate,
  libtool,
  autoconf,
  automake,
  xorgproto,
  libICE,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "dssi";
  version = "1.1.1";

  src = fetchurl {
    url = "mirror://sourceforge/project/dssi/dssi/${version}/${pname}-${version}.tar.gz";
    sha256 = "0kl1hzhb7cykzkrqcqgq1dk4xcgrcxv0jja251aq4z4l783jpj7j";
  };

  nativeBuildInputs = [
    autoconf
    automake
    pkg-config
  ];
  buildInputs = [
    ladspaH
    libjack2
    liblo
    alsa-lib
    libX11
    libsndfile
    libSM
    libsamplerate
    libtool
    xorgproto
    libICE
  ];

  meta = with lib; {
    description = "Plugin SDK for virtual instruments";
    maintainers = with maintainers; [
      raskin
    ];
    platforms = platforms.linux;
    license = licenses.lgpl21;
    downloadPage = "https://sourceforge.net/projects/dssi/files/dssi/";
  };
}
