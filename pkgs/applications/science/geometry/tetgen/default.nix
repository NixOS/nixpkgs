{lib, stdenv, fetchurl}:

let version = "1.6.0"; in
stdenv.mkDerivation {
  pname = "tetgen";
  inherit version;

  src = fetchurl {
    url = "http://wias-berlin.de/software/tetgen/1.5/src/tetgen${version}.tar.gz";
    sha256 = "sha256-h7XmHr06Rx/E8s3XEkwrEd1mOfT+sflBpdL1EQ0Fzjk=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp tetgen $out/bin
  '';

  meta = {
    inherit version;
    description = "Quality Tetrahedral Mesh Generator and 3D Delaunay Triangulator";
    homepage = "http://tetgen.org/";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.linux;
  };
}
