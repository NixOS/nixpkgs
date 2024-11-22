{ lib, stdenv, fetchurl, pkg-config, libopus }:

stdenv.mkDerivation rec {
  pname = "libopusenc";
  version = "0.2.1";

  src = fetchurl {
    url = "mirror://mozilla/opus/libopusenc-${version}.tar.gz";
    sha256 = "1ffb0vhlymlsq70pxsjj0ksz77yfm2x0a1x8q50kxmnkm1hxp642";
  };

  outputs = [ "out" "dev" ];

  doCheck = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libopus ];

  meta = with lib; {
    description = "Library for encoding .opus audio files and live streams";
    license = licenses.bsd3;
    homepage = "https://www.opus-codec.org/";
    platforms = platforms.unix;
    maintainers = with maintainers; [ pmiddend ];
  };
}
