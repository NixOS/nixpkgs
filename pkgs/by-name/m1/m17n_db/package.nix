{
  lib,
  stdenv,
  fetchurl,
  gettext,
  gawk,
  bash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "m17n-db";
  version = "1.8.12";

  src = fetchurl {
    url = "mirror://savannah/m17n/m17n-db-${finalAttrs.version}.tar.gz";
    hash = "sha256-0Rq1ggmJYJ0N8wPkIRwfAItmX5sJkqEHe8n0vQIKKes=";
  };

  nativeBuildInputs = [ gettext ];
  buildInputs = [
    gettext
    gawk
    bash
  ];

  strictDeps = true;

  configureFlags = [ "--with-charmaps=${stdenv.cc.libc}/share/i18n/charmaps" ];

  meta = {
    homepage = "https://www.nongnu.org/m17n/";
    description = "Multilingual text processing library (database)";
    mainProgram = "m17n-db";
    changelog = "https://git.savannah.nongnu.org/cgit/m17n/m17n-db.git/plain/NEWS?h=REL-${
      lib.replaceStrings [ "." ] [ "-" ] finalAttrs.version
    }";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
