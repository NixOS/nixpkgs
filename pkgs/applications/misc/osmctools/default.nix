{ stdenv, fetchurl, zlib } :

let

  convert_src = fetchurl {
    url = http://m.m.i24.cc/osmconvert.c;
    sha256 = "1mvmb171c1jqxrm80jc7qicwk4kgg7yq694n7ci65g6i284r984x";
    # version = 0.8.5
  };

  filter_src = fetchurl {
    url = http://m.m.i24.cc/osmfilter.c;
    sha256 = "0vm3bls9jb2cb5b11dn82sxnc22qzkf4ghmnkivycigrwa74i6xl";
    # version = 1.4.0
  };

in

stdenv.mkDerivation rec {
  name = "osmctools-${version}";
  version = "0.8.5plus1.4.0";

  buildInputs = [ zlib ];

  phases = [ "buildPhase" "installPhase" ];

  buildPhase = ''
    cc ${convert_src} -lz -O3 -o osmconvert
    cc ${filter_src} -O3 -o osmfilter
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv osmconvert $out/bin
    mv osmfilter $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Command line tools for transforming Open Street Map files";
    homepage = [
      https://wiki.openstreetmap.org/wiki/Osmconvert
      https://wiki.openstreetmap.org/wiki/Osmfilter
    ];
    platforms = platforms.unix;
    license = licenses.agpl3;
  };
}
