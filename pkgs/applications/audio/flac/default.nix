{ stdenv, fetchurl, fetchpatch, libogg }:

stdenv.mkDerivation rec {
  pname = "flac";
  version = "1.3.3";

  src = fetchurl {
    url = "http://downloads.xiph.org/releases/flac/${pname}-${version}.tar.xz";
    sha256 = "0j0p9sf56a2fm2hkjnf7x3py5ir49jyavg4q5zdyd7bcf6yq4gi1";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2020-0499.patch";
      url = "https://github.com/xiph/flac/commit/2e7931c27eb15e387da440a37f12437e35b22dd4.patch";
      sha256 = "160qzq9ms5addz7sx06pnyjjkqrffr54r4wd8735vy4x008z71ah";
    })
  ];

  buildInputs = [ libogg ];

  #doCheck = true; # takes lots of time

  outputs = [ "bin" "dev" "out" "man" "doc" ];

  meta = with stdenv.lib; {
    homepage = "https://xiph.org/flac/";
    description = "Library and tools for encoding and decoding the FLAC lossless audio file format";
    platforms = platforms.all;
    license = licenses.bsd3;
  };
}
