{ lib, stdenv, fetchurl, pkg-config, gtk3 }:

stdenv.mkDerivation rec {
  pname = "ssw";
<<<<<<< HEAD
  version = "0.8";

  src = fetchurl {
    url = "https://alpha.gnu.org/gnu/ssw/spread-sheet-widget-${version}.tar.gz";
    sha256 = "sha256-hYnYKY/PO1hQ0JaLBIAaT0D68FVVRPbMnZVLAWLplUs=";
=======
  version = "0.6";

  src = fetchurl {
    url = "https://alpha.gnu.org/gnu/ssw/spread-sheet-widget-${version}.tar.gz";
    sha256 = "08ck9l697xg8vpya5h07raq837i4pqxjqzx30vhscq4xpps2b8kj";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
