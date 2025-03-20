{ lib, stdenv, fetchurl, gettext, gawk, bash }:

stdenv.mkDerivation rec {
  pname = "m17n-db";
  version = "1.8.9";

  src = fetchurl {
    url = "https://download.savannah.gnu.org/releases/m17n/m17n-db-${version}.tar.gz";
    sha256 = "sha256-SBJUo4CqnGbX9Ow6o3Kn4dL+R/w53252BEvUQBfEJKQ=";
  };

  nativeBuildInputs = [ gettext ];
  buildInputs = [ gettext gawk bash ];

  strictDeps = true;

  configureFlags = [ "--with-charmaps=${stdenv.cc.libc}/share/i18n/charmaps" ]
  ;

  meta = {
    homepage = "https://www.nongnu.org/m17n/";
    description = "Multilingual text processing library (database)";
    mainProgram = "m17n-db";
    changelog = "https://git.savannah.nongnu.org/cgit/m17n/m17n-db.git/plain/NEWS?h=REL-${lib.replaceStrings [ "." ] [ "-" ] version}";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ astsmtl ];
  };
}
