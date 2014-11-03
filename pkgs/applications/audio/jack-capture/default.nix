{ stdenv, fetchurl, jack2, libsndfile, pkgconfig }:

stdenv.mkDerivation rec {
  name = "jack_capture-${version}";
  version = "0.9.69";

  src = fetchurl {
    url = "http://archive.notam02.no/arkiv/src/${name}.tar.gz";
    sha256 = "0sk7b92my1v1g7rhkpl1c608rb0rdb28m9zqfll95kflxajd16zv";
  };

  buildInputs = [ jack2 libsndfile pkgconfig ];

  buildPhase = "PREFIX=$out make jack_capture";

  installPhase = ''
    mkdir -p $out/bin
    cp jack_capture $out/bin/
  '';

  meta = with stdenv.lib; { 
    description = "A program for recording soundfiles with jack";
    homepage = http://archive.notam02.no/arkiv/src;
    license = licenses.gpl2;
    maintainers = [ maintainers.goibhniu ];
    platforms = stdenv.lib.platforms.linux;
  };
}
