{ lib, mkDerivation, fetchFromGitHub, fftw, qtbase, qtmultimedia, qmake, itstool, wrapQtAppsHook
, alsaSupport ? true, alsa-lib ? null
, jackSupport ? false, libjack2 ? null
, portaudioSupport ? false, portaudio ? null }:

assert alsaSupport -> alsa-lib != null;
assert jackSupport -> libjack2 != null;
assert portaudioSupport -> portaudio != null;

with lib;

mkDerivation rec {
  pname = "fmit";
  version = "1.2.14";

  src = fetchFromGitHub {
    owner = "gillesdegottex";
    repo = "fmit";
    rev = "v${version}";
    sha256 = "1q062pfwz2vr9hbfn29fv54ip3jqfd9r99nhpr8w7mn1csy38azx";
  };

  nativeBuildInputs = [ qmake itstool wrapQtAppsHook ];
  buildInputs = [ fftw qtbase qtmultimedia ]
    ++ optionals alsaSupport [ alsa-lib ]
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

  meta = {
    description = "Free Musical Instrument Tuner";
    longDescription = ''
      FMIT is a graphical utility for tuning musical instruments, with error
      and volume history, and advanced features.
    '';
    homepage = "http://gillesdegottex.github.io/fmit/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
