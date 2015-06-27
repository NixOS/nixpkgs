{ stdenv, fetchFromGitHub, alsaLib, cmake, fftw
, freeglut, libjack2, libXmu, qt4 }:

let version = "1.0.0"; in
stdenv.mkDerivation {
  name = "fmit-${version}";

  src = fetchFromGitHub {
    sha256 = "13y9csv34flz7065kg69h99hd7d9zskq12inmkf34l4qjyk7c185";
    rev = "v${version}";
    repo = "fmit";
    owner = "gillesdegottex";
  };

  buildInputs = [ alsaLib fftw freeglut libjack2 libXmu qt4 ];
  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    inherit version;
    description = "Free Musical Instrument Tuner";
    longDescription = ''
      FMIT is a graphical utility for tuning your musical instruments, with
      error and volume history and advanced features.
    '';
    homepage = http://gillesdegottex.github.io/fmit/;
    license = licenses.gpl3Plus;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };
}
