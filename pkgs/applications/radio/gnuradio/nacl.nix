{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, boost, gnuradio, uhd
, makeWrapper, libsodium, cppunit, log4cpp
, pythonSupport ? true, python, swig
}:

assert pythonSupport -> python != null && swig != null;

stdenv.mkDerivation {
  pname = "gr-nacl";
  version = "2017-04-10";

  src = fetchFromGitHub {
    owner = "stwunsch";
    repo = "gr-nacl";
    rev = "15276bb0fcabf5fe4de4e58df3d579b5be0e9765";
    sha256 = "018np0qlk61l7mlv3xxx5cj1rax8f1vqrsrch3higsl25yydbv7v";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    boost gnuradio uhd makeWrapper libsodium cppunit log4cpp
  ] ++ stdenv.lib.optionals pythonSupport [ python swig ];

  postInstall = ''
    for prog in "$out"/bin/*; do
        wrapProgram "$prog" --set PYTHONPATH $PYTHONPATH:$(toPythonPath "$out")
    done
  '';

  meta = with lib; {
    description = "Gnuradio block for encryption";
    homepage = "https://github.com/stwunsch/gr-nacl";
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ mog ];
  };
}
