{ stdenv, fetchgit, cmake, pkgconfig, boost, gnuradio, rtl-sdr, uhd
, makeWrapper
, pythonSupport ? true, python, swig
}:

assert pythonSupport -> python != null && swig != null;

stdenv.mkDerivation rec {
  name = "gnuradio-osmosdr-${version}";
  version = "0.1.0";

  src = fetchgit {
    url = "git://git.osmocom.org/gr-osmosdr";
    rev = "refs/tags/v${version}";
    sha256 = "112zfvnr6fjvhdc06ihi2sb0dp441qy7jq8rvr81nbyv3r8jspj4";
  };

  buildInputs = [
    cmake pkgconfig boost gnuradio rtl-sdr uhd makeWrapper
  ] ++ stdenv.lib.optionals pythonSupport [ python swig ];

  postInstall = ''
    for prog in "$out"/bin/*; do
        wrapProgram "$prog" --set PYTHONPATH $PYTHONPATH:$(toPythonPath "$out")
    done
  '';

  meta = with stdenv.lib; {
    description = "Gnuradio block for OsmoSDR and rtl-sdr";
    homepage = http://sdr.osmocom.org/trac/wiki/GrOsmoSDR;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
