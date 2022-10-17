{ lib, stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  pname = "soxr";
  version = "0.1.3";

  src = fetchurl {
    url = "mirror://sourceforge/soxr/soxr-${version}-Source.tar.xz";
    sha256 = "12aql6svkplxq5fjycar18863hcq84c5kx8g6f4rj0lcvigw24di";
  };

  patches = [
    # Remove once https://sourceforge.net/p/soxr/code/merge-requests/5/ is merged.
    ./arm64-check.patch
  ];

  outputs = [ "out" "doc" ]; # headers are just two and very small

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "An audio resampling library";
    homepage = "http://soxr.sourceforge.net";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
  };
}
