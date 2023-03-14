{ fetchFromGitHub, fetchpatch, lib, which, ocamlPackages }:

let
  pname = "alt-ergo";
  version = "2.4.2";

  configureScript = "ocaml unix.cma configure.ml";

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-8pJ/1UAbheQaLFs5Uubmmf5D0oFJiPxF6e2WTZgRyAc=";
  };
in

let alt-ergo-lib = ocamlPackages.buildDunePackage rec {
  pname = "alt-ergo-lib";
  inherit version src configureScript;
  configureFlags = [ pname ];
  nativeBuildInputs = [ which ];
  buildInputs = with ocamlPackages; [ dune-configurator ];
  propagatedBuildInputs = with ocamlPackages; [ num ocplib-simplex seq stdlib-shims zarith ];
  preBuild = ''
    substituteInPlace src/lib/util/version.ml --replace 'version="dev"' 'version="${version}"'
  '';
}; in

let alt-ergo-parsers = ocamlPackages.buildDunePackage rec {
  pname = "alt-ergo-parsers";
  inherit version src configureScript;
  configureFlags = [ pname ];
  nativeBuildInputs = [ which ocamlPackages.menhir ];
  propagatedBuildInputs = [ alt-ergo-lib ] ++ (with ocamlPackages; [ camlzip psmt2-frontend ]);
}; in

ocamlPackages.buildDunePackage {

  inherit pname version src configureScript;

  configureFlags = [ pname ];

  nativeBuildInputs = [ which ocamlPackages.menhir ];
  buildInputs = [ alt-ergo-parsers ocamlPackages.cmdliner ];

  meta = {
    description = "High-performance theorem prover and SMT solver";
    homepage    = "https://alt-ergo.ocamlpro.com/";
    license     = lib.licenses.ocamlpro_nc;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}
