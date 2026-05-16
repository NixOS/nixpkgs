{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rxp";
  version = "1.5.2";

  src = fetchurl {
    url = "https://www.inf.ed.ac.uk/research/isddarch/admin/rxp-${finalAttrs.version}.tar.gz";
    hash = "sha256-+mQbSlGF0KHZYQyCRbnVr/WXLBoooNqU8+ONafbBRRM=";
  };

  meta = {
    license = lib.licenses.gpl2Plus;
    description = "Validating XML parser written in C";
    homepage = "https://www.cogsci.ed.ac.uk/~richard/rxp.html";
    platforms = lib.platforms.unix;
    mainProgram = "rxp";
  };
})
