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
  version = "1.1.11";

  src = fetchFromGitHub {
    sha256 = "1w492lf8n2sjkr53z8cvkgywzn0w53cf78hz93zaw6dwwv36lwdp";
    rev = "v${version}";
    repo = "fmit";
    owner = "gillesdegottex";
  };

  nativeBuildInputs = [ qmakeHook ];
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
    maintainers = with maintainers; [ nckx ];
  };
}
