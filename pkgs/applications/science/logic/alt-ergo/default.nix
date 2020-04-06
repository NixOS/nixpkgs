{ fetchurl, lib, which, ocamlPackages }:

let
  pname = "alt-ergo";
  version = "2.3.1";

  src = fetchurl {
    url    = "https://alt-ergo.ocamlpro.com/download_manager.php?target=${pname}-${version}.tar.gz";
    name   = "${pname}-${version}.tar.gz";
    sha256 = "124n836alqm13245hcnxixzc6a15rip919shfflvxqnl617mkmhg";
  };

  preConfigure = "patchShebangs ./configure";

  nativeBuildInputs = [ which ];

in

let alt-ergo-lib = ocamlPackages.buildDunePackage rec {
  pname = "alt-ergo-lib";
  inherit version src preConfigure nativeBuildInputs;
  configureFlags = pname;
  propagatedBuildInputs = with ocamlPackages; [ num ocplib-simplex zarith ];
}; in

let alt-ergo-parsers = ocamlPackages.buildDunePackage rec {
  pname = "alt-ergo-parsers";
  inherit version src preConfigure nativeBuildInputs;
  configureFlags = pname;
  buildInputs = with ocamlPackages; [ menhir ];
  propagatedBuildInputs = [ alt-ergo-lib ] ++ (with ocamlPackages; [ camlzip psmt2-frontend ]);
}; in

ocamlPackages.buildDunePackage {

  inherit pname version src preConfigure nativeBuildInputs;

  configureFlags = pname;

  buildInputs = [ alt-ergo-parsers ocamlPackages.menhir ];

  meta = {
    description = "High-performance theorem prover and SMT solver";
    homepage    = "https://alt-ergo.ocamlpro.com/";
    license     = lib.licenses.ocamlpro_nc;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}
