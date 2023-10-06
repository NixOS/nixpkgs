{ fetchurl, lib, stdenv, libjpeg, libpng, libtiff, perl, cmake }:

stdenv.mkDerivation rec {
  pname = "libpano13";
  version = "2.9.22";

  src = fetchurl {
    url = "mirror://sourceforge/panotools/${pname}-${version}.tar.gz";
    sha256 = "sha256-r/xoMM2+ccKNJzHcv43qKs2m2f/UYJxtvzugxoRAqOM=";
  };

  buildInputs = [ perl libjpeg libpng libtiff ];
  nativeBuildInputs = [ cmake ];

  # one of the tests succeeds on my machine but fails on Hydra (no idea why)
  #doCheck = true;

  meta = {
    homepage = "https://panotools.sourceforge.net/";
    description = "Free software suite for authoring and displaying virtual reality panoramas";
    license = lib.licenses.gpl2Plus;

    platforms = lib.platforms.gnu ++ lib.platforms.linux;  # arbitrary choice
  };
}
