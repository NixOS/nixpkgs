{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "tetgen-1.4.3";

  src = fetchurl {
    url = "${meta.homepage}/files/tetgen1.4.3.tar.gz";
    sha256 = "0d70vjqdapmy1ghlsxjlvl5z9yp310zw697bapc4zxmp0sxi29wm";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp tetgen $out/bin
  '';

  meta = {
    description = "Quality Tetrahedral Mesh Generator and 3D Delaunay Triangulator";
    homepage = "http://tetgen.org/";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
  };
}
