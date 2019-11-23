{ stdenv, mkDerivation, fetchFromGitHub, fftw, qtbase, qtmultimedia, qmake, itstool, wrapQtAppsHook
, alsaSupport ? true, alsaLib ? null
, jackSupport ? false, libjack2 ? null
, portaudioSupport ? false, portaudio ? null }:

assert alsaSupport -> alsaLib != null;
assert jackSupport -> libjack2 != null;
assert portaudioSupport -> portaudio != null;

with stdenv.lib;

mkDerivation rec {
  pname = "fmit";
  version = "1.2.13";

  src = fetchFromGitHub {
    owner = "gillesdegottex";
    repo = "fmit";
    rev = "v${version}";
    sha256 = "1qyskam053pvlap1av80rgp12pzhr92rs88vqs6s0ia3ypnixcc6";
  };

  nativeBuildInputs = [ qmake itstool wrapQtAppsHook ];
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
