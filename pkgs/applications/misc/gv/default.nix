{ stdenv, fetchurl, Xaw3d, ghostscriptX }:

stdenv.mkDerivation rec {
  name = "gv-3.6.5";

  src = fetchurl {
    url = "mirror://gnu/gv/${name}.tar.gz";
    sha256 = "0wxxq695psb57n3kaj6swlczkwf9p79zdmn1dxrj4isyyr0gxm7d";
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
