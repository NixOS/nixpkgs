{ stdenv, fetchurl, gmp, m4 }:

let
  pname = "ecm";
  version = "6.4.4";
  name = "${pname}-${version}";
in

stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = http://gforge.inria.fr/frs/download.php/file/32159/ecm-6.4.4.tar.gz;
    sha256 = "0v5h2nicz9yx78c2d72plbhi30iq4nxbvphja1s9501db4aah4y8";
  };

  # See https://trac.sagemath.org/ticket/19233
  configureFlags = stdenv.lib.optional stdenv.isDarwin "--disable-asm-redc";

  buildInputs = [ m4 gmp ];

  doCheck = true;

  meta = {
    description = "Elliptic Curve Method for Integer Factorization";
    license = stdenv.lib.licenses.gpl2Plus;
    homepage = http://ecm.gforge.inria.fr/;
    maintainers = [ stdenv.lib.maintainers.roconnor ];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
