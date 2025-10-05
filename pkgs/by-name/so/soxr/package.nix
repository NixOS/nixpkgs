{
  lib,
  stdenv,
  fetchurl,
  cmake,
}:

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

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    # Workaround for upstream not using GNUInstallDirs.
    "-DINCLUDE_INSTALL_DIR=${placeholder "dev"}/include"
  ];

  meta = with lib; {
    description = "Audio resampling library";
    homepage = "https://soxr.sourceforge.net";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix ++ platforms.windows;
    maintainers = [ ];
  };
}
