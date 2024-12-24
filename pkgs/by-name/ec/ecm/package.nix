{
  lib,
  stdenv,
  fetchurl,
  gmp,
  m4,
}:

let
  pname = "ecm";
  version = "7.0.4";
  name = "${pname}-${version}";
in

stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://gforge.inria.fr/frs/download.php/file/36224/ecm-${version}.tar.gz";
    sha256 = "0hxs24c2m3mh0nq1zz63z3sb7dhy1rilg2s1igwwcb26x3pb7xqc";
  };

  # See https://trac.sagemath.org/ticket/19233
  configureFlags = lib.optional stdenv.hostPlatform.isDarwin "--disable-asm-redc";

  buildInputs = [
    m4
    gmp
  ];

  doCheck = true;

  meta = {
    description = "Elliptic Curve Method for Integer Factorization";
    mainProgram = "ecm";
    license = lib.licenses.gpl2Plus;
    homepage = "http://ecm.gforge.inria.fr/";
    maintainers = [ lib.maintainers.roconnor ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
