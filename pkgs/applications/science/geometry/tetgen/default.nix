{stdenv, fetchurl}: 

let version = "1.5.0"; in
stdenv.mkDerivation {
  name = "tetgen-${version}";

  src = fetchurl {
    url = "http://wias-berlin.de/software/tetgen/1.5/src/tetgen${version}.tar.gz";
    sha256 = "1www3x2r6r7pck43ismlwy82x0j6xj2qiwvfs2pn687gsmhlh4ad";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp tetgen $out/bin
  '';

  meta = {
    inherit version;
    description = "Quality Tetrahedral Mesh Generator and 3D Delaunay Triangulator";
    homepage = "http://tetgen.org/";
    license = stdenv.lib.licenses.agpl3Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
