{ stdenv, fetchgit, cmake, pkgconfig, boost, gnuradio, rtl-sdr, uhd
, makeWrapper, hackrf, airspy
, pythonSupport ? true, python, swig
}:

assert pythonSupport -> python != null && swig != null;

stdenv.mkDerivation rec {
  name = "gnuradio-osmosdr-${version}";
  version = "0.1.5-git";

  src = fetchgit {
    url = "git://git.osmocom.org/gr-osmosdr";
    rev = "c653754dde5e2cf682965e939cc016fbddbd45e4";
    sha256 = "05na9bbcv3sd533p5q57x40jq5ypknrzr89y8kxrjq7w3xlyk6qd";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    cmake boost gnuradio rtl-sdr uhd makeWrapper hackrf airspy
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
