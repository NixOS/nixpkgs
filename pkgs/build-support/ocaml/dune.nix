{ stdenv, fetchurl, ocaml, findlib, dune }:

{ pname, version, buildInputs ? [], ... }@args:

if args ? minimumOCamlVersion &&
   ! stdenv.lib.versionAtLeast ocaml.version args.minimumOCamlVersion
then throw "${pname}-${version} is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation ({

  buildPhase = "dune build -p ${pname}";
  checkPhase = "dune runtest -p ${pname}";
  inherit (dune) installPhase;

  meta.platform = ocaml.meta.platform;

} // args // {

  name = "ocaml${ocaml.version}-${pname}-${version}";

  buildInputs = [ ocaml dune findlib ] ++ buildInputs;

})
