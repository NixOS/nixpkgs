{ stdenv, fetchurl, zlib } :

stdenv.mkDerivation rec {
  name = "osmctools-${version}";
  version = "0.8.5";

  src = fetchurl {
    url = http://m.m.i24.cc/osmconvert.c;
    sha256 = "9da0940912d1bc62223b962483fd796f92c959c48749806aee5806164e5875d7";
  };

  buildInputs = [ zlib ];

  phases = [ "buildPhase" "installPhase" ];

  buildPhase = ''
    cc $src -lz -O3 -o osmconvert
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv osmconvert $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Converter between various Open Street Map file formats";
    homepage = http://wiki.openstreetmap.org/wiki/Osmconvert;
    platforms = platforms.unix;
  };
}
