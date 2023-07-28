{ lib, stdenv, fetchpatch, fetchurl, flac }:

stdenv.mkDerivation {
  version = "3.0.10";
  pname = "shntool";

  src = fetchurl {
    url = "http://www.etree.org/shnutils/shntool/dist/src/shntool-3.0.10.tar.gz";
    sha256 = "00i1rbjaaws3drkhiczaign3lnbhr161b7rbnjr8z83w8yn2wc3l";
  };

  buildInputs = [ flac ];

  patches = fetchpatch {
    url = "https://salsa.debian.org/debian/shntool/-/raw/57efcd7b34c2107dd785c11d79dfcd4520b2bc41/debian/patches/950803.patch?inline=false";
    sha256 = "sha256:0rlybjm6qf3ydqr44ns4yg4hwi4jhq237a5p6ph2v7s0630c90i9";
  };

  meta = {
    description = "Multi-purpose WAVE data processing and reporting utility";
    homepage = "http://www.etree.org/shnutils/shntool/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ jcumming ];
  };
}
