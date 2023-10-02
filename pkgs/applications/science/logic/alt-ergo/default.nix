{ fetchurl, fetchpatch, lib, ocamlPackages }:

let
  pname = "alt-ergo";
  version = "2.5.1";

  src = fetchurl {
    url = "https://github.com/OCamlPro/alt-ergo/releases/download/v${version}/alt-ergo-${version}.tbz";
    hash = "sha256-nPjWmg5FepObhquioYxhVPq6UdOHtCo2Hs5V0yndYB0=";
  };
in

let alt-ergo-lib = ocamlPackages.buildDunePackage rec {
  pname = "alt-ergo-lib";
  inherit version src;
  buildInputs = with ocamlPackages; [ ppx_blob ];
  propagatedBuildInputs = with ocamlPackages; [ camlzip dolmen_loop dune-build-info fmt ocplib-simplex seq stdlib-shims zarith ];
}; in

let alt-ergo-parsers = ocamlPackages.buildDunePackage rec {
  pname = "alt-ergo-parsers";
  inherit version src;
  nativeBuildInputs = [ ocamlPackages.menhir ];
  propagatedBuildInputs = [ alt-ergo-lib ] ++ (with ocamlPackages; [ psmt2-frontend ]);
}; in

ocamlPackages.buildDunePackage {

  inherit pname version src;

  nativeBuildInputs = [ ocamlPackages.menhir ];
  buildInputs = [ alt-ergo-parsers ] ++ (with ocamlPackages; [ cmdliner dune-site ]);

  meta = {
    description = "High-performance theorem prover and SMT solver";
    homepage    = "https://alt-ergo.ocamlpro.com/";
    license     = lib.licenses.ocamlpro_nc;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}
