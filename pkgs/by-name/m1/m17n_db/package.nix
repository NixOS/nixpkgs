{
  lib,
  stdenv,
  fetchurl,
  gettext,
  gawk,
  bash,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "m17n-db";
  version = "1.8.19";

  src = fetchurl {
    url = "mirror://savannah/m17n/m17n-db-${finalAttrs.version}.tar.gz";
    hash = "sha256-0XIT06gXiFe0teBs1UkXi/m8wfd69h1zDmlthGVWwjE=";
  };

  nativeBuildInputs = [ gettext ];
  buildInputs = [
    gettext
    gawk
    bash
  ];

  strictDeps = true;

  configureFlags = [ "--with-charmaps=${stdenv.cc.libc}/share/i18n/charmaps" ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  __structuredAttrs = true;

  meta = {
    homepage = "https://www.nongnu.org/m17n/";
    description = "Multilingual text processing library (database)";
    mainProgram = "m17n-db";
    changelog = "https://git.savannah.nongnu.org/cgit/m17n/m17n-db.git/plain/NEWS?h=REL-${
      lib.replaceStrings [ "." ] [ "-" ] finalAttrs.version
    }";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    pkgConfigModules = [ "m17n-db" ];
  };
})
