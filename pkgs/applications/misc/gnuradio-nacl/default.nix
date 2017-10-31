{ stdenv, fetchFromGitHub, cmake, pkgconfig, boost, gnuradio, uhd
, makeWrapper, libsodium, cppunit
, pythonSupport ? true, python, swig
}:

assert pythonSupport -> python != null && swig != null;

stdenv.mkDerivation rec {
  name = "gnuradio-nacl-${version}";
  version = "2015-11-05";

  src = fetchFromGitHub {
    owner = "stwunsch";
    repo = "gr-nacl";
    rev = "d6dd3c02dcda3f601979908b61b1595476f6bf95";
    sha256 = "0q28lgkndcw9921hm6cw5ilxd83n65hjajwl78j50mh6yc3bim35";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    cmake boost gnuradio uhd makeWrapper libsodium cppunit
  ] ++ stdenv.lib.optionals pythonSupport [ python swig ];

  postInstall = ''
    for prog in "$out"/bin/*; do
        wrapProgram "$prog" --set PYTHONPATH $PYTHONPATH:$(toPythonPath "$out")
    done
  '';

  meta = with stdenv.lib; {
    description = "Gnuradio block for encryption";
    homepage = https://github.com/stwunsch/gr-nacl;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mog ];
  };
}
