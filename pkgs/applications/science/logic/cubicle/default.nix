{ stdenv, fetchurl, ocaml, ocamlPackages }:

stdenv.mkDerivation rec {
  name = "cubicle-${version}";
  version = "1.0.2";
  src = fetchurl {
    url = "http://cubicle.lri.fr/cubicle-${version}.tar.gz";
    sha256 = "1fg39vlr2d5067512df32hkw6g8vglxj1m47md5mw3pn3ij6dpsx";
  };

  buildInputs = [ ocaml ocamlPackages.functory ];

  meta = with stdenv.lib; {
    description = "An open source model checker for verifying safety properties of array-based systems";
    homepage = "http://cubicle.lri.fr/";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lucas8 ];
  };
}
