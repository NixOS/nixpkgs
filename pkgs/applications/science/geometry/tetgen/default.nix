{stdenv, fetchurl}: 

stdenv.mkDerivation rec {
  name = "tetgen-1.4.3";

  src = fetchurl {
    url = http://tetgen.berlios.de/files/tetgen1.4.3.tar.gz;
    sha256 = "159i0vdjz7abb8bycz47ax4fqlzc82kv19sygqnrkr86qm4g43wy";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp tetgen $out/bin
  '';

  meta = {
    description = "Quality Tetrahedral Mesh Generator and 3D Delaunay Triangulator";
    homepage = "http://tetgen.berlios.de/";
    license = "MIT";
  };
}
