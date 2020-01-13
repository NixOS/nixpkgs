{ stdenv, fetchFromGitHub, cmake, pkgconfig, boost, gnuradio
, makeWrapper, pythonSupport ? true, python2, swig
}:

assert pythonSupport -> python2 != null && swig != null;

stdenv.mkDerivation rec {
  pname = "gr-rds";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "bastibl";
    repo = "gr-rds";
    rev = "v${version}";
    sha256 = "0jkzchvw0ivcxsjhi1h0mf7k13araxf5m4wi5v9xdgqxvipjzqfy";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    cmake boost gnuradio makeWrapper
  ] ++ stdenv.lib.optionals pythonSupport [ python2 swig ];

  postInstall = ''
    for prog in "$out"/bin/*; do
        wrapProgram "$prog" --set PYTHONPATH $PYTHONPATH:$(toPythonPath "$out")
    done
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Gnuradio block for radio data system";
    homepage = https://github.com/bastibl/gr-rds;
    license = licenses.gpl2Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ mog ];
  };
}
