{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "shhopt";
  version = "1.1.7";

  src = fetchurl {
    url = "https://shh.thathost.com/pub-unix/files/shhopt-${finalAttrs.version}.tar.gz";
    sha256 = "0yd6bl6qw675sxa81nxw6plhpjf9d2ywlm8a5z66zyjf28sl7sds";
  };

  postPatch = ''
    substituteInPlace Makefile --replace "gcc" "${stdenv.cc.targetPrefix}cc"
  '';

  installFlags = [ "INSTBASEDIR=$(out)" ];

  meta = {
    description = "Library for parsing command line options";
    homepage = "https://shh.thathost.com/pub-unix/";
    license = lib.licenses.artistic1;
    platforms = lib.platforms.all;
  };
})
