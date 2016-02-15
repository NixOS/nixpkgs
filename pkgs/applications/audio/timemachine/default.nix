{ stdenv, fetchFromGitHub, autoconf, automake, pkgconfig, gtk2
, libjack2, libsndfile
}:

stdenv.mkDerivation rec {
  name = "timemachine-${version}";
  version = "0.3.1";
  src = fetchFromGitHub {
    owner = "swh";
    repo = "timemachine";
    rev = "1966d8524d4e4c47c525473bab3b010a168adc98";
    sha256 = "0w5alysixnvlkfl79wf7vs5wsw2vgxl3gqxxcm0zbmhjdpmjpcal";
  };

    buildInputs = [ autoconf automake pkgconfig gtk2 libjack2
      libsndfile
    ];

  preConfigure = "./autogen.sh";

  meta = {
    description = "JACK audio recorder";
    homepage = http://plugin.org.uk/timemachine/;
    license = stdenv.lib.licenses.lgpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.nico202 ];
  };
}

