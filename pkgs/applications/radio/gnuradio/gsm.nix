{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, boost, gnuradio, log4cpp
, makeWrapper, cppunit, libosmocore, gr-osmosdr
, pythonSupport ? true, python, swig
}:

assert pythonSupport -> python != null && swig != null;

stdenv.mkDerivation {
  pname = "gr-gsm";
  version = "2016-08-25";

  src = fetchFromGitHub {
    owner = "ptrkrysik";
    repo = "gr-gsm";
    rev = "3ca05e6914ef29eb536da5dbec323701fbc2050d";
    sha256 = "13nnq927kpf91iqccr8db9ripy5czjl5jiyivizn6bia0bam2pvx";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    boost gnuradio makeWrapper cppunit libosmocore gr-osmosdr log4cpp
  ] ++ stdenv.lib.optionals pythonSupport [ python swig ];

  postInstall = ''
    for prog in "$out"/bin/*; do
        wrapProgram "$prog" --set PYTHONPATH $PYTHONPATH:${gr-osmosdr}/lib/${python.libPrefix}/site-packages:$(toPythonPath "$out")
    done
  '';

  meta = with lib; {
    description = "Gnuradio block for gsm";
    homepage = "https://github.com/ptrkrysik/gr-gsm";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mog ];
  };
}
