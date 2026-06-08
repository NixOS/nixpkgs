{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clzip";
  version = "1.16";

  src = fetchurl {
    url = "mirror://savannah/lzip/clzip/clzip-${finalAttrs.version}.tar.gz";
    hash = "sha256-8zmjpd/CIgUy3Db5N6eljjoyeLF08oFcxWFRB+VZZuQ=";
  };

  meta = {
    homepage = "https://www.nongnu.org/lzip/clzip.html";
    description = "C language version of lzip";
    mainProgram = "clzip";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
