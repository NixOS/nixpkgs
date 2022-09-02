{ lib, stdenv, fetchurl, fetchpatch, autoreconfHook, libogg }:

stdenv.mkDerivation rec {
  pname = "flac";
  version = "1.3.4";

  src = fetchurl {
    url = "http://downloads.xiph.org/releases/flac/${pname}-${version}.tar.xz";
    sha256 = "0dz7am8kbc97a6afml1h4yp085274prg8j7csryds8m3fmz61w4g";
  };

  patches = [
    # Remove on next bump
    (fetchpatch {
      name = "flac-Add-POWER-AltiVec-VSX-checks.patch";
      url = "https://github.com/xiph/flac/commit/d15bcf80a06bd5300e33d5f5c94d69fbf879f45a.patch";
      sha256 = "sha256-Pex4zAZiP2WsHbZ3SmsDY+taN5jNLOItN2FaBa+mebM=";
    })
  ];

  nativeBuildInputs = [
    # Needed for patching of configure.ac, can be removed on next bump
    autoreconfHook
  ];

  buildInputs = [ libogg ];

  #doCheck = true; # takes lots of time

  outputs = [ "bin" "dev" "out" "man" "doc" ];

  meta = with lib; {
    homepage = "https://xiph.org/flac/";
    description = "Library and tools for encoding and decoding the FLAC lossless audio file format";
    platforms = platforms.all;
    license = licenses.bsd3;
  };
}
