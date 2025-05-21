{
  lib,
  stdenv,
  fetchurl,
  python3,
  perl,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "meme-suite";
  version = "5.5.7";

  src = fetchurl {
    url = "https://meme-suite.org/meme-software/${version}/meme-${version}.tar.gz";
    sha256 = "sha256-HcqNDm0dNlcMGoirjb5+Sxd3M/u+rKoujEZ0/r9XqvQ=";
  };

  buildInputs = [ zlib ];
  nativeBuildInputs = [
    perl
    python3
  ];

  meta = with lib; {
    description = "Motif-based sequence analysis tools";
    homepage = "https://meme-suite.org/meme/meme-software/";
    license = licenses.unfree;
    maintainers = with maintainers; [ gschwartz ];
    platforms = platforms.linux;
  };
}
