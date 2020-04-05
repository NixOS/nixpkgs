{ stdenv
, fetchFromGitHub
, cmake
, pkgconfig
, boost
, gnuradio
, cppunit
, libosmocore
, gr-osmosdr
, pythonSupport ? true
, python
, swig
}:

assert pythonSupport -> python != null && swig != null;

# See https://github.com/ptrkrysik/gr-gsm/issues/475
assert stdenv.lib.asserts.assertMsg (gnuradio.branch == "3.7") "gnuradio.plugins.gsm is not supported by a gnuradio version other then 3.7";

stdenv.mkDerivation {
  pname = "gr-gsm";
  version = "2016-08-25";

  src = fetchFromGitHub {
    owner = "ptrkrysik";
    repo = "gr-gsm";
    rev = "3ca05e6914ef29eb536da5dbec323701fbc2050d";
    sha256 = "13nnq927kpf91iqccr8db9ripy5czjl5jiyivizn6bia0bam2pvx";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    cmake
    boost
    gnuradio
    cppunit
    libosmocore
    gr-osmosdr
  ]
    ++ stdenv.lib.optionals pythonSupport [
      python
      swig
    ]
  ;

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Gnuradio block for gsm";
    homepage = "https://github.com/ptrkrysik/gr-gsm";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mog ];
  };
}
