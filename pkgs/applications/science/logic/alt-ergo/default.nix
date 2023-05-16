{ fetchFromGitHub, fetchpatch, lib, which, ocamlPackages }:

let
  pname = "alt-ergo";
<<<<<<< HEAD
  version = "2.4.3";
=======
  version = "2.4.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  configureScript = "ocaml unix.cma configure.ml";

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-2XARGr8rLiPMOM0rBBoRv5tZvKYtkLkJctGqLYkMe7Q=";
=======
    hash = "sha256-8pJ/1UAbheQaLFs5Uubmmf5D0oFJiPxF6e2WTZgRyAc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
in

let alt-ergo-lib = ocamlPackages.buildDunePackage rec {
  pname = "alt-ergo-lib";
  inherit version src configureScript;
  configureFlags = [ pname ];
  nativeBuildInputs = [ which ];
  buildInputs = with ocamlPackages; [ dune-configurator ];
<<<<<<< HEAD
  propagatedBuildInputs = with ocamlPackages; [ dune-build-info num ocplib-simplex seq stdlib-shims zarith ];
=======
  propagatedBuildInputs = with ocamlPackages; [ num ocplib-simplex seq stdlib-shims zarith ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
