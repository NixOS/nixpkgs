{ stdenv, fetchgit, cmake, pkgconfig, makeWrapper
, boost
, pythonSupport ? true, python, swig
, airspy
, gnuradio
, hackrf
, libbladeRF
, rtl-sdr
, soapysdr-with-plugins
, uhd
}:

assert pythonSupport -> python != null && swig != null;

stdenv.mkDerivation rec {
  name = "gnuradio-osmosdr-${version}";
  version = "2018-08-15";

  src = fetchgit {
    url = "git://git.osmocom.org/gr-osmosdr";
    rev = "4d83c6067f059b0c5015c3f59f8117bbd361e877";
    sha256 = "1d5nb47506qry52bg4cn02d3l4lwxwz44g2fz1ph0q93c7892j60";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    cmake makeWrapper boost
    airspy gnuradio hackrf libbladeRF rtl-sdr uhd
  ] ++ stdenv.lib.optionals stdenv.isLinux [ soapysdr-with-plugins ]
    ++ stdenv.lib.optionals pythonSupport [ python swig ];

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
