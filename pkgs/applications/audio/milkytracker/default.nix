{ stdenv, fetchurl, SDL2, alsaLib, cmake, libjack2, perl
, zlib, zziplib, pkgconfig, makeWrapper
}:

stdenv.mkDerivation rec {
  version = "1.01";
  name = "milkytracker-${version}";

  src = fetchurl {
    url = "https://github.com/milkytracker/MilkyTracker/archive/v${version}.00.tar.gz";
    sha256 = "1dvnddsnn9c83lz4dlm0cfjpc0m524amfkbalxbswdy0qc8cj1wv";
  };

  preBuild=''
    export CPATH=${zlib.out}/lib
  '';

  nativeBuildInputs = [ cmake pkgconfig makeWrapper ];

  buildInputs = [ SDL2 alsaLib libjack2 perl zlib zziplib ];

  meta = {
    description = "Music tracker application, similar to Fasttracker II";
    homepage = http://milkytracker.org;
    license = stdenv.lib.licenses.gpl3Plus;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = [ stdenv.lib.maintainers.zoomulator ];
  };
}
