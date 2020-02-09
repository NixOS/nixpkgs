{ stdenv, fetchurl, ocamlPackages }:

stdenv.mkDerivation rec {
  pname = "cubicle";
  version = "1.1.2";
  src = fetchurl {
    url = "http://cubicle.lri.fr/cubicle-${version}.tar.gz";
    sha256 = "10kk80jdmpdvql88sdjsh7vqzlpaphd8vip2lp47aarxjkwjlz1q";
  };

  postPatch = ''
    substituteInPlace Makefile.in --replace "\\n" ""
  '';

  buildInputs = with ocamlPackages; [ ocaml findlib functory ];

  meta = with stdenv.lib; {
    description = "An open source model checker for verifying safety properties of array-based systems";
    homepage = http://cubicle.lri.fr/;
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dwarfmaster ];
  };
}
