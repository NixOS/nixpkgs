{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clzip";
  version = "1.14";

  src = fetchurl {
    url = "mirror://savannah/lzip/clzip/clzip-${finalAttrs.version}.tar.gz";
    hash = "sha256-9j/hJFuDL+B/9nnpubhofpN5q2E6Jr+wrKN1TIsWLXM=";
  };

  meta = with lib; {
    homepage = "https://www.nongnu.org/lzip/clzip.html";
    description = "C language version of lzip";
    mainProgram = "clzip";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.all;
  };
})
