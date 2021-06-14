{ lib, stdenv, fetchFromGitHub, fetchpatch
, cmake, halide
, libpng, libjpeg, libtiff, libraw
}:

stdenv.mkDerivation rec {
  pname = "hdr-plus-unstable";
  version = "2020-10-29";

  src = fetchFromGitHub {
    owner = "timothybrooks";
    repo = "hdr-plus";
    rev = "132bd73ccd4eaef9830124605c93f06a98607cfa";
    sha256 = "1n49ggrppf336p7n510kapzh376791bysxj3f33m3bdzksq360ps";
  };

  patches = [
    # PR #70, fixes incompatibility with Halide 10.0.0
    (fetchpatch {
      url = "https://github.com/timothybrooks/hdr-plus/pull/70/commits/077e1a476279539c72e615210762dca27984c57b.patch";
      sha256 = "1sg2l1bqs2smpfpy4flwg86fzhcc4yf7zx998v1bfhim43yyrx59";
    })
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ halide libpng libjpeg libtiff libraw ];

  installPhase = ''
    for bin in hdrplus stack_frames; do
      install -Dm755 $bin $out/bin/$bin
    done
  '';

  meta = with lib; {
    description = "Burst photography pipeline based on Google's HDR+";
    homepage = "https://www.timothybrooks.com/tech/hdr-plus/";
    license = licenses.mit;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.all;
  };
}
