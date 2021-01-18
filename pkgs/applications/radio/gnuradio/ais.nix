{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, boost, gnuradio
, makeWrapper, cppunit, gr-osmosdr, log4cpp
, pythonSupport ? true, python, swig
}:

assert pythonSupport -> python != null && swig != null;

stdenv.mkDerivation {
  pname = "gr-ais";
  version = "2015-12-20";

  src = fetchFromGitHub {
    owner = "bistromath";
    repo = "gr-ais";
    # Upstream PR: https://github.com/bistromath/gr-ais/commit/8502d0252a2a1a9b8d1a71795eaeb5d820684054
    rev = "8502d0252a2a1a9b8d1a71795eaeb5d820684054";
    sha256 = "1b9j0kc74cw12a7jv4lii77dgzqzg2s8ndzp4xmisxksgva1qfvh";
  };

  nativeBuildInputs = [ cmake makeWrapper pkg-config ];
  buildInputs = [ boost gnuradio cppunit gr-osmosdr log4cpp ]
             ++ lib.optionals pythonSupport [ python swig ];

  postInstall = ''
    for prog in "$out"/bin/*; do
        wrapProgram "$prog" --set PYTHONPATH $PYTHONPATH:$(toPythonPath "$out")
    done
  '';

  meta = with lib; {
    description = "Gnuradio block for ais";
    homepage = "https://github.com/bistromath/gr-ais";
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ mog ];
  };
}
