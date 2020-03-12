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
  pname = "gr-osmosdr";
  version = "0.1.5";

  src = fetchgit {
    url = "git://git.osmocom.org/gr-osmosdr";
    rev = "v${version}";
    sha256 = "0bf9bnc1c3c4yqqqgmg3nhygj6rcfmyk6pybi27f7461d2cw1drv";
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
