{ stdenv, fetchurl, ocamlPackages }:

stdenv.mkDerivation rec {
  name = "cubicle-${version}";
  version = "1.1.1";
  src = fetchurl {
    url = "http://cubicle.lri.fr/cubicle-${version}.tar.gz";
    sha256 = "1sny9c4fm14k014pk62ibpwbrjjirkx8xmhs9jg7q1hk7y7x3q2h";
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
    maintainers = with maintainers; [ lucas8 ];
  };
}
