{ lib, stdenv, fetchFromGitHub
, cmake, halide
, libpng, libjpeg, libtiff, libraw
}:

stdenv.mkDerivation rec {
  pname = "hdr-plus";
  version = "unstable-2021-12-10";

  src = fetchFromGitHub {
    owner = "timothybrooks";
    repo = "hdr-plus";
    rev = "0ab70564493bdbcd5aca899b5885505d0c824435";
    sha256 = "sha256-QV8bGxkwFpbNzJG4kmrWwFQxUo2XzLPnoI1e32UmM6g=";
  };

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
