{ stdenv, fetchFromGitHub, fftw, freeglut, mesa_glu, qtbase, qtmultimedia, qmakeHook
, alsaSupport ? true, alsaLib ? null
, jackSupport ? false, libjack2 ? null
, portaudioSupport ? false, portaudio ? null }:

assert alsaSupport -> alsaLib != null;
assert jackSupport -> libjack2 != null;
assert portaudioSupport -> portaudio != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "fmit-${version}";
  version = "1.0.14";

  src = fetchFromGitHub {
    sha256 = "1f8raqpqqyr02lnpxxpg69a2if1nbw0za71x62kcp3pms1qc0mbh";
    rev = "v${version}";
    repo = "fmit";
    owner = "gillesdegottex";
  };

  buildInputs = [ fftw freeglut mesa_glu qtbase qtmultimedia qmakeHook ]
    ++ optionals alsaSupport [ alsaLib ]
    ++ optionals jackSupport [ libjack2 ]
    ++ optionals portaudioSupport [ portaudio ];

  preConfigure = ''
    qmakeFlags="$qmakeFlags \
      CONFIG+=${optionalString alsaSupport "acs_alsa"} \
      CONFIG+=${optionalString jackSupport "acs_jack"} \
      CONFIG+=${optionalString portaudioSupport "acs_portaudio"} \
      PREFIXSHORTCUT=$out"
  '';

  enableParallelBuilding = true;

  meta = {
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
