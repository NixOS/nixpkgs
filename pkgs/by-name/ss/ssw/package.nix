{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gtk3,
}:

stdenv.mkDerivation rec {
  pname = "ssw";
  version = "0.10";

  src = fetchurl {
    url = "https://alpha.gnu.org/gnu/ssw/spread-sheet-widget-${version}.tar.gz";
    sha256 = "sha256-gGkuw1AnGZXhR9x1mSnN1507ZF5rXvqmtX9NLQXoR+U=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk3 ];

  meta = with lib; {
    homepage = "https://www.gnu.org/software/ssw/";
    license = licenses.gpl3;
    description = "GNU Spread Sheet Widget";
    platforms = platforms.linux;
  };
}
