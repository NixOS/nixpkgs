{ stdenv, fetchurl, python27Packages, glew, freeglut, libpng, libxml2, tk, freetype }:

let
  version = "1.8.4.0";
in
python27Packages.buildPythonApplication {
  name = "pymol-${version}";
  src = fetchurl {
    url = "mirror://sourceforge/project/pymol/pymol/1.8/pymol-v1.8.4.0.tar.bz2";
    sha256 = "0yfj8g5yic9zz6f0bw2n8h6ifvgsn8qvhq84alixsi28wzppn55n";
  };

  buildInputs = [ python27Packages.numpy glew freeglut libpng libxml2 tk freetype ];
  NIX_CFLAGS_COMPILE = "-I ${libxml2.dev}/include/libxml2";

  installPhase = ''
    python setup.py install --home=$out
  '';

  meta = with stdenv.lib; {
    description = "A Python-enhanced molecular graphics tool";
    homepage = "https://www.pymol.org/";
    license = licenses.psfl;
  };
}
