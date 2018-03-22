{ stdenv, fetchFromGitHub, fftw, freeglut, libGLU, qtbase, qtmultimedia, qmake
, alsaSupport ? true, alsaLib ? null
, jackSupport ? false, libjack2 ? null
, portaudioSupport ? false, portaudio ? null }:

assert alsaSupport -> alsaLib != null;
assert jackSupport -> libjack2 != null;
assert portaudioSupport -> portaudio != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "fmit-${version}";
  version = "1.1.13";

  src = fetchFromGitHub {
    sha256 = "1p374gf7iksrlyvddm3w4qk3l0rxsiyymz5s8dmc447yvin8ykfq";
    rev = "v${version}";
    repo = "fmit";
    owner = "gillesdegottex";
  };

  nativeBuildInputs = [ qmake ];
  buildInputs = [ fftw qtbase qtmultimedia ]
    ++ optionals alsaSupport [ alsaLib ]
    ++ optionals jackSupport [ libjack2 ]
    ++ optionals portaudioSupport [ portaudio ];

  postPatch = ''
    substituteInPlace fmit.pro --replace '$$FMITVERSIONGITPRO' '${version}'
  '';

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
  };
}
