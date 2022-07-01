{ lib, stdenv, fetchurl, pkg-config, gtk3 }:

stdenv.mkDerivation rec {
  pname = "ssw";
  version = "0.6";

  src = fetchurl {
    url = "https://alpha.gnu.org/gnu/ssw/spread-sheet-widget-${version}.tar.gz";
    sha256 = "08ck9l697xg8vpya5h07raq837i4pqxjqzx30vhscq4xpps2b8kj";
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
