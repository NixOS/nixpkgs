# FIXME: upgrading qt5Full (Qt 5.3) to qt5.{base,multimedia} (Qt 5.4) breaks
# the default Qt audio capture source!
{ stdenv, fetchFromGitHub, fftw, freeglut, qt5Full
, alsaSupport ? false, alsaLib ? null
, jackSupport ? false, libjack2 ? null }:

assert alsaSupport -> alsaLib != null;
assert jackSupport -> libjack2 != null;

let version = "1.0.7"; in
stdenv.mkDerivation {
  name = "fmit-${version}";

  src = fetchFromGitHub {
    sha256 = "14dzrrxjskhqamhfqhzp6napvc1vyjxcc0v8id1iqzsfdn86xqm9";
    rev = "v${version}";
    repo = "fmit";
    owner = "gillesdegottex";
  };

  buildInputs = [ fftw freeglut qt5Full ]
    ++ stdenv.lib.optional alsaSupport [ alsaLib ]
    ++ stdenv.lib.optional jackSupport [ libjack2 ];

  postPatch = ''
    substituteInPlace fmit.pro --replace '$$FMITVERSIONGITPRO' '${version}'
  '';

  configurePhase = ''
    mkdir build
    cd build
    qmake \
      CONFIG+=${stdenv.lib.optionalString alsaSupport "acs_alsa"} \
      CONFIG+=${stdenv.lib.optionalString jackSupport "acs_jack"} \
      PREFIX="$out" PREFIXSHORTCUT="$out" \
      ../fmit.pro
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    inherit version;
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
