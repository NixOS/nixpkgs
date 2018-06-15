{ stdenv, fetchgit, cmake, pkgconfig, boost, gnuradio, rtl-sdr, uhd
, makeWrapper, hackrf, airspy
, pythonSupport ? true, python, swig
}:

assert pythonSupport -> python != null && swig != null;

stdenv.mkDerivation rec {
  name = "gnuradio-osmosdr-${version}";
  version = "0.1.4";

  src = fetchgit {
    url = "git://git.osmocom.org/gr-osmosdr";
    rev = "refs/tags/v${version}";
    sha256 = "0vyzr4fhkblf2v3d7m0ch5hws4c493jw3ydl4y6b2dfbfzchhsz8";
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
