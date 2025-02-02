{
  darwin,
  fetchurl,
  lib,
  ocamlPackages,
  stdenv,
}:

let
  pname = "alt-ergo";
  version = "2.6.0";

  src = fetchurl {
    url = "https://github.com/OCamlPro/alt-ergo/releases/download/v${version}/alt-ergo-${version}.tbz";
    hash = "sha256-EmkxGvJSeKRmiSuoeMyIi6WfF39T3QPxKixiOwP8834=";
  };
in

let
  alt-ergo-lib = ocamlPackages.buildDunePackage rec {
    pname = "alt-ergo-lib";
    inherit version src;
    buildInputs = with ocamlPackages; [ ppx_blob ];
    propagatedBuildInputs = with ocamlPackages; [
      camlzip
      dolmen_loop
      dune-build-info
      fmt
      ocplib-simplex
      ppx_deriving
      seq
      stdlib-shims
      zarith
    ];
  };
in

let
  alt-ergo-parsers = ocamlPackages.buildDunePackage rec {
    pname = "alt-ergo-parsers";
    inherit version src;
    nativeBuildInputs = [ ocamlPackages.menhir ];
    propagatedBuildInputs = [ alt-ergo-lib ] ++ (with ocamlPackages; [ psmt2-frontend ]);
  };
in

ocamlPackages.buildDunePackage {

  inherit pname version src;

  nativeBuildInputs = [
    ocamlPackages.menhir
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.sigtool ];
  propagatedBuildInputs =
    [ alt-ergo-parsers ]
    ++ (with ocamlPackages; [
      cmdliner
      dune-site
      ppxlib
    ]);

  outputs = [
    "bin"
    "out"
  ];

  installPhase = ''
    runHook preInstall
    dune install --prefix $bin ${pname}
    mkdir -p $out/lib/ocaml/${ocamlPackages.ocaml.version}/site-lib
    mv $bin/lib/alt-ergo $out/lib/ocaml/${ocamlPackages.ocaml.version}/site-lib/
    runHook postInstall
  '';

  meta = {
    description = "High-performance theorem prover and SMT solver";
    homepage = "https://alt-ergo.ocamlpro.com/";
    license = lib.licenses.ocamlpro_nc;
    maintainers = [ lib.maintainers.thoughtpolice ];
  };
}
