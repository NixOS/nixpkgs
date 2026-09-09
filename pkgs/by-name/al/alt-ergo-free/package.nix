{
  fetchurl,
  lib,
  ocamlPackages,
  stdenv,
}:

ocamlPackages.buildDunePackage (finalAttrs: {
  pname = "alt-ergo-free";
  version = "2.4.3";

  src = fetchurl {
    url = "https://github.com/OCamlPro/alt-ergo/releases/download/v${finalAttrs.version}-free/alt-ergo-${finalAttrs.version}-free.tar.gz";
    hash = "sha256-ksVP9HH9pY+T6Es/wgC9pGd805AGw1e1vgfVlNGCXG8=";
  };

  nativeBuildInputs = [ ocamlPackages.menhir ];

  sourceRoot = ".";

  buildInputs = with ocamlPackages; [
    cmdliner
    camlzip
    stdlib-shims
    dune-configurator
    dune-build-info
    num
    psmt2-frontend
    ocplib-simplex_0_4
    zarith
    seq
  ];

  meta = {
    description = "High-performance theorem prover and SMT solver";
    homepage = "https://alt-ergo.ocamlpro.com/";
    license = lib.licenses.cecill-c;
    maintainers = with lib.maintainers; [ redianthus ];
  };
})
