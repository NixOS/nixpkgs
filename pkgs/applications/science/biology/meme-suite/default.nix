{ lib, stdenv, fetchurl, python3, perl, zlib }:

stdenv.mkDerivation rec {
  pname = "meme-suite";
  version = "5.1.1";

  src = fetchurl {
    url = "https://meme-suite.org/meme-software/${version}/meme-${version}.tar.gz";
    sha256 = "38d73d256d431ad4eb7da2c817ce56ff2b4e26c39387ff0d6ada088938b38eb5";
  };

  buildInputs = [ zlib ];
  nativeBuildInputs = [ perl python3 ];

  meta = with lib; {
    description = "Motif-based sequence analysis tools";
    license = licenses.unfree;
    maintainers = with maintainers; [ gschwartz ];
    platforms = platforms.linux;
  };
}
