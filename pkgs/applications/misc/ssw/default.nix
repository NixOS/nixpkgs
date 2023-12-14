{ lib, stdenv, fetchurl, pkg-config, gtk3 }:

stdenv.mkDerivation rec {
  pname = "ssw";
  version = "0.8";

  src = fetchurl {
    url = "https://alpha.gnu.org/gnu/ssw/spread-sheet-widget-${version}.tar.gz";
    sha256 = "sha256-hYnYKY/PO1hQ0JaLBIAaT0D68FVVRPbMnZVLAWLplUs=";
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
