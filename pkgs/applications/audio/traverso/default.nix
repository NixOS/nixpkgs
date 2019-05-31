{ stdenv, fetchurl, cmake, pkgconfig
, alsaLib, fftw, flac, lame, libjack2, libmad, libpulseaudio
, libsamplerate, libsndfile, libvorbis, portaudio, qtbase, wavpack
}:
stdenv.mkDerivation rec {
  name = "traverso-${version}";
  version = "0.49.6";

  src = fetchurl {
    url = "http://traverso-daw.org/traverso-0.49.6.tar.gz";
    sha256 = "12f7x8kw4fw1j0xkwjrp54cy4cv1ql0zwz2ba5arclk4pf6bhl7q";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ alsaLib fftw flac.dev libjack2 lame
                  libmad libpulseaudio libsamplerate.dev libsndfile.dev libvorbis
                  portaudio qtbase wavpack ];

  cmakeFlags = [ "-DWANT_PORTAUDIO=1" "-DWANT_PULSEAUDIO=1" "-DWANT_MP3_ENCODE=1" "-DWANT_LV2=0" ];

  enableParallelBuilding = true;
  hardeningDisable = [ "format" ];

  meta = with stdenv.lib; {
    description = "Cross-platform multitrack audio recording and audio editing suite";
    homepage = http://traverso-daw.org/;
    license = with licenses; [ gpl2Plus lgpl21Plus ];
    platforms = platforms.all;
    maintainers = with maintainers; [ coconnor ];
  };
}
