{ fetchurl, lib, which, ocamlPackages }:

let
  pname = "alt-ergo";
  version = "2.3.3";

  src = fetchurl {
    url = "https://alt-ergo.ocamlpro.com/http/alt-ergo-${version}/alt-ergo-${version}.tar.gz";
    sha256 = "124k2a4ikk4wdpmvgjpgl97x9skvr9qznk8m68dzsynzpv6yksaj";
  };

  useDune2 = true;

  nativeBuildInputs = [ which ];

in

let alt-ergo-lib = ocamlPackages.buildDunePackage rec {
  pname = "alt-ergo-lib";
  inherit version src useDune2 nativeBuildInputs;
  configureFlags = pname;
  propagatedBuildInputs = with ocamlPackages; [ num ocplib-simplex stdlib-shims zarith ];
}; in

let alt-ergo-parsers = ocamlPackages.buildDunePackage rec {
  pname = "alt-ergo-parsers";
  inherit version src useDune2 nativeBuildInputs;
  configureFlags = pname;
  buildInputs = with ocamlPackages; [ menhir ];
  propagatedBuildInputs = [ alt-ergo-lib ] ++ (with ocamlPackages; [ camlzip psmt2-frontend ]);
}; in

ocamlPackages.buildDunePackage {

  inherit pname version src useDune2 nativeBuildInputs;

  configureFlags = pname;

  buildInputs = [ alt-ergo-parsers ocamlPackages.menhir ];

  meta = {
    description = "High-performance theorem prover and SMT solver";
    homepage    = "https://alt-ergo.ocamlpro.com/";
    license     = lib.licenses.ocamlpro_nc;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}
