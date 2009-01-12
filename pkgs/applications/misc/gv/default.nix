{ stdenv, fetchurl, Xaw3d, ghostscriptX }:

stdenv.mkDerivation rec {
  name = "gv-3.6.6";

  src = fetchurl {
    url = "mirror://gnu/gv/${name}.tar.gz";
    sha256 = "08xnjg5nimrksn2fl18589ncb26vaabbypmvay8hh8psjsks5683";
  };

  buildInputs = [ Xaw3d ghostscriptX ];
  
  postConfigure = ''
    sed 's|\<gs\>|${ghostscriptX}/bin/gs|g' -i src/*.in
    sed 's|"gs"|"${ghostscriptX}/bin/gs"|g' -i src/*.c
  '';

  doCheck = true;

  meta = {
    homepage = http://www.gnu.org/software/gv/;
    description = "GNU gv, a PostScript/PDF document viewer";
    license = "GPLv3+";
  };
}
