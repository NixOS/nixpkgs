{ stdenv, fetchgit, cmake, pkgconfig, boost, gnuradio, rtl-sdr, uhd
, makeWrapper, hackrf, airspy, libbladeRF
, pythonSupport ? true, python, swig
}:

assert pythonSupport -> python != null && swig != null;

stdenv.mkDerivation rec {
  name = "gnuradio-osmosdr-unstable-2018-06-26";
# version = "0.1.4";

  src = fetchgit {
    url = "git://git.osmocom.org/gr-osmosdr";
    rev = "4d83c6067f059b0c5015c3f59f8117bbd361e877";
    sha256 = "1d5nb47506qry52bg4cn02d3l4lwxwz44g2fz1ph0q93c7892j60";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    cmake boost gnuradio rtl-sdr uhd makeWrapper hackrf airspy libbladeRF
  ] ++ stdenv.lib.optionals pythonSupport [ python swig ];

  postInstall = ''
    for prog in "$out"/bin/*; do
        wrapProgram "$prog" --set PYTHONPATH $PYTHONPATH:$(toPythonPath "$out")
    done
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Gnuradio block for OsmoSDR and rtl-sdr";
    homepage = https://sdr.osmocom.org/trac/wiki/GrOsmoSDR;
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ bjornfor the-kenny ];
  };
}
