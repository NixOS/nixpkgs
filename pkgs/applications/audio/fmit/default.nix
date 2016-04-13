{ stdenv, fetchFromGitHub, fftw, freeglut, qtbase, qtmultimedia
, alsaSupport ? true, alsaLib ? null
, jackSupport ? false, libjack2 ? null
, portaudioSupport ? false, portaudio ? null }:

assert alsaSupport -> alsaLib != null;
assert jackSupport -> libjack2 != null;
assert portaudioSupport -> portaudio != null;

stdenv.mkDerivation rec {
  name = "fmit-${version}";
  version = "1.0.8";

  src = fetchFromGitHub {
    sha256 = "04s7xcgmi5g58lirr48vf203n1jwdxf981x1p6ysbax24qwhs2kd";
    rev = "v${version}";
    repo = "fmit";
    owner = "gillesdegottex";
  };

  buildInputs = [ fftw freeglut qtbase qtmultimedia ]
    ++ stdenv.lib.optionals alsaSupport [ alsaLib ]
    ++ stdenv.lib.optionals jackSupport [ libjack2 ]
    ++ stdenv.lib.optionals portaudioSupport [ portaudio ];

  configurePhase = ''
    mkdir build
    cd build
    qmake \
      CONFIG+=${stdenv.lib.optionalString alsaSupport "acs_alsa"} \
      CONFIG+=${stdenv.lib.optionalString jackSupport "acs_jack"} \
      CONFIG+=${stdenv.lib.optionalString portaudioSupport "acs_portaudio"} \
      PREFIX="$out" PREFIXSHORTCUT="$out" \
      ../fmit.pro
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Free Musical Instrument Tuner";
    longDescription = ''
      FMIT is a graphical utility for tuning musical instruments, with error
      and volume history, and advanced features.
    '';
    homepage = http://gillesdegottex.github.io/fmit/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
