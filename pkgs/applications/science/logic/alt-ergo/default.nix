{ fetchFromGitHub, lib, which, ocamlPackages }:

let
  pname = "alt-ergo";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = pname;
    rev = version;
    sha256 = "0hglj1p0753w2isds01h90knraxa42d2jghr35dpwf9g8a1sm9d3";
  };

  useDune2 = true;
in

let alt-ergo-lib = ocamlPackages.buildDunePackage rec {
  pname = "alt-ergo-lib";
  inherit version src useDune2;
  configureFlags = pname;
  nativeBuildInputs = [ which ];
  buildInputs = with ocamlPackages; [ dune-configurator ];
  propagatedBuildInputs = with ocamlPackages; [ num ocplib-simplex stdlib-shims zarith ];
}; in

let alt-ergo-parsers = ocamlPackages.buildDunePackage rec {
  pname = "alt-ergo-parsers";
  inherit version src useDune2;
  configureFlags = pname;
  nativeBuildInputs = [ which ocamlPackages.menhir ];
  propagatedBuildInputs = [ alt-ergo-lib ] ++ (with ocamlPackages; [ camlzip psmt2-frontend ]);
}; in

ocamlPackages.buildDunePackage {

  inherit pname version src useDune2;

  configureFlags = pname;

  nativeBuildInputs = [ which ocamlPackages.menhir ];
  buildInputs = [ alt-ergo-parsers ocamlPackages.cmdliner ];

  meta = {
    description = "High-performance theorem prover and SMT solver";
    homepage    = "https://alt-ergo.ocamlpro.com/";
    license     = lib.licenses.ocamlpro_nc;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}
