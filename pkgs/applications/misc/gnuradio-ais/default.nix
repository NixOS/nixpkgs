{ stdenv, fetchFromGitHub, cmake, pkgconfig, boost, gnuradio
, makeWrapper, cppunit, gnuradio-osmosdr
, pythonSupport ? true, python, swig
}:

assert pythonSupport -> python != null && swig != null;

stdenv.mkDerivation rec {
  name = "gnuradio-ais-${version}";
  version = "2016-08-26";

  src = fetchFromGitHub {
    owner = "bistromath";
    repo = "gr-ais";
    rev = "1863d1bf8a7709a8dfedb3ddb8e2b99112e7c872";
    sha256 = "1vl3kk8xr2mh5lf31zdld7yzmwywqffffah8iblxdzblgsdwxfl6";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    cmake boost gnuradio makeWrapper cppunit gnuradio-osmosdr
  ] ++ stdenv.lib.optionals pythonSupport [ python swig ];

  postInstall = ''
    for prog in "$out"/bin/*; do
        wrapProgram "$prog" --set PYTHONPATH $PYTHONPATH:$(toPythonPath "$out")
    done
  '';

  meta = with stdenv.lib; {
    description = "Gnuradio block for ais";
    homepage = https://github.com/bistromath/gr-ais;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mog ];
  };
}
