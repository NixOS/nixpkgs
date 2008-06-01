{ stdenv, fetchurl, Xaw3d, ghostscriptX }:

stdenv.mkDerivation rec {
  name = "gv-3.6.4";

  src = fetchurl {
    url = "mirror://gnu/gv/${name}.tar.gz";
    sha256 = "09v87h0fmpg7wid6b7wwcbl28x9m1wmn465hvpxs95wmn7nw98c2";
  };

  buildInputs = [ Xaw3d ghostscriptX ];
  
  postConfigure = [ "sed 's|\\<gs\\>|${ghostscriptX}/bin/gs|g' -i src/*.am src/*.ad" ];

  doCheck = true;

  meta = {
    homepage = http://www.gnu.org/software/gv/;
    description = "GNU gv, a PostScript/PDF document viewer";
    license = "GPLv2+";
  };
}
