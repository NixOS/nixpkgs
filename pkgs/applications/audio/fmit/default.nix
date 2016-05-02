{ stdenv, fetchFromGitHub, fftw, freeglut, mesa_glu, qtbase, qtmultimedia, qmakeHook
, alsaSupport ? true, alsaLib ? null
, jackSupport ? false, libjack2 ? null
, portaudioSupport ? false, portaudio ? null }:

assert alsaSupport -> alsaLib != null;
assert jackSupport -> libjack2 != null;
assert portaudioSupport -> portaudio != null;

stdenv.mkDerivation rec {
  name = "fmit-${version}";
  version = "1.0.13";

  src = fetchFromGitHub {
    sha256 = "04cj70q60sqns68nvw4zfy6078x4cc2q1y2y13z3rs5n80jw27by";
    rev = "v${version}";
    repo = "fmit";
    owner = "gillesdegottex";
  };

  buildInputs = [ fftw freeglut mesa_glu qtbase qtmultimedia qmakeHook ]
    ++ stdenv.lib.optionals alsaSupport [ alsaLib ]
    ++ stdenv.lib.optionals jackSupport [ libjack2 ]
    ++ stdenv.lib.optionals portaudioSupport [ portaudio ];

  preConfigure = ''
    qmakeFlags="$qmakeFlags \
      CONFIG+=${stdenv.lib.optionalString alsaSupport "acs_alsa"} \
      CONFIG+=${stdenv.lib.optionalString jackSupport "acs_jack"} \
      CONFIG+=${stdenv.lib.optionalString portaudioSupport "acs_portaudio"} \
      PREFIXSHORTCUT=$out"
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
