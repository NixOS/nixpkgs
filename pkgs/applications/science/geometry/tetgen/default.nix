{stdenv, fetchurl}: 

let version = "1.5.1"; in
stdenv.mkDerivation {
  pname = "tetgen";
  inherit version;

  src = fetchurl {
    url = "http://wias-berlin.de/software/tetgen/1.5/src/tetgen${version}.tar.gz";
    sha256 = "0l5q066crs4cjj7qr0r2gnz8ajkgighngwglr1201h77lcs48sp4";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp tetgen $out/bin
  '';

  meta = {
    inherit version;
    description = "Quality Tetrahedral Mesh Generator and 3D Delaunay Triangulator";
    homepage = http://tetgen.org/;
    license = stdenv.lib.licenses.agpl3Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
