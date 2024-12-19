{
  fetchurl,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "matio";
  version = "1.5.28";

  src = fetchurl {
    url = "mirror://sourceforge/matio/matio-${finalAttrs.version}.tar.gz";
    hash = "sha256-naaYk0ohVprwWOY0hWRmb0UCnmwrCHjKDY+WCb93uNg=";
  };

  meta = {
    changelog = "https://sourceforge.net/p/matio/news/";
    description = "C library for reading and writing Matlab MAT files";
    homepage = "http://matio.sourceforge.net/";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    mainProgram = "matdump";
    platforms = lib.platforms.all;
  };
})
