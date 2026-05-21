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
  version = "5.5.9";

  src = fetchurl {
    url = "https://meme-suite.org/meme-software/${version}/meme-${version}.tar.gz";
    sha256 = "sha256-BAb7ex3Cf2qrPW06KezfYXu92UZpDPqXyiEpvCEL/RI=";
  };

  buildInputs = [ zlib ];
  nativeBuildInputs = [
    perl
    python3
  ];

  meta = {
    description = "Motif-based sequence analysis tools";
    homepage = "https://meme-suite.org/meme/meme-software/";
    license = lib.licenses.unfree;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
