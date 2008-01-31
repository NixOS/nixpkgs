{ stdenv, fetchurl, Xaw3d, ghostscriptX }:

stdenv.mkDerivation {
  name = "gv-3.6.1";

  src = fetchurl {
    url = http://ftp.gnu.org/gnu/gv/gv-3.6.3.tar.gz;
    sha256 = "9486c25675719e986cbd77b48204025e825c46258b6750deeb64b3940685a033";
  };

  buildInputs = [ Xaw3d ghostscriptX ];
  
  postConfigure = [ "sed 's|\\<gs\\>|${ghostscriptX}/bin/gs|g' -i src/*.am src/*.ad" ];

  inherit ghostscriptX;

  meta = {
    homepage = http://wwwthep.physik.uni-mainz.de/~plass/gv;
  };
}
