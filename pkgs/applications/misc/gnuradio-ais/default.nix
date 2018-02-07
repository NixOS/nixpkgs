{ stdenv, fetchFromGitHub, cmake, pkgconfig, boost, gnuradio
, makeWrapper, cppunit, gnuradio-osmosdr
, pythonSupport ? true, python, swig
}:

assert pythonSupport -> python != null && swig != null;

stdenv.mkDerivation rec {
  name = "gnuradio-ais-${version}";
  version = "2015-12-20";

  src = fetchFromGitHub {
    owner = "bistromath";
    repo = "gr-ais";
    # Upstream PR: https://github.com/bistromath/gr-ais/commit/8502d0252a2a1a9b8d1a71795eaeb5d820684054
    "rev" = "8502d0252a2a1a9b8d1a71795eaeb5d820684054";
    "sha256" = "1b9j0kc74cw12a7jv4lii77dgzqzg2s8ndzp4xmisxksgva1qfvh";
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

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Gnuradio block for ais";
    homepage = https://github.com/bistromath/gr-ais;
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ mog ];
  };
}
