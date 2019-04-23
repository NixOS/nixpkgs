{ stdenv, fetchFromGitHub, cmake, pkgconfig, boost, gnuradio
, makeWrapper, cppunit, libosmocore, gnuradio-osmosdr
, pythonSupport ? true, python, swig
}:

assert pythonSupport -> python != null && swig != null;

stdenv.mkDerivation rec {
  name = "gnuradio-gsm-${version}";
  version = "2016-08-25";

  src = fetchFromGitHub {
    owner = "ptrkrysik";
    repo = "gr-gsm";
    rev = "3ca05e6914ef29eb536da5dbec323701fbc2050d";
    sha256 = "13nnq927kpf91iqccr8db9ripy5czjl5jiyivizn6bia0bam2pvx";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    cmake boost gnuradio makeWrapper cppunit libosmocore gnuradio-osmosdr
  ] ++ stdenv.lib.optionals pythonSupport [ python swig ];

  postInstall = ''
    for prog in "$out"/bin/*; do
        wrapProgram "$prog" --set PYTHONPATH $PYTHONPATH:${gnuradio-osmosdr}/lib/${python.libPrefix}/site-packages:$(toPythonPath "$out")
    done
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Gnuradio block for gsm";
    homepage = https://github.com/ptrkrysik/gr-gsm;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mog ];
  };
}
