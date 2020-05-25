{ stdenv, ocaml, findlib, dune, dune_2, opaline }:

{ pname, version, buildInputs ? [], ... }@args:

let Dune = if args.useDune2 or false then dune_2 else dune; in

if args ? minimumOCamlVersion &&
   ! stdenv.lib.versionAtLeast ocaml.version args.minimumOCamlVersion
then throw "${pname}-${version} is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation ({

  buildPhase = ''
    runHook preBuild
    dune build -p ${pname}
    runHook postBuild
  '';
  checkPhase = ''
    runHook preCheck
    dune runtest -p ${pname}
    runHook postCheck
  '';
  installPhase = ''
    runHook preInstall
    ${opaline}/bin/opaline -prefix $out -libdir $OCAMLFIND_DESTDIR
    runHook postInstall
  '';

} // args // {

  name = "ocaml${ocaml.version}-${pname}-${version}";

  buildInputs = [ ocaml Dune findlib ] ++ buildInputs;

  meta = (args.meta or {}) // { platforms = args.meta.platforms or ocaml.meta.platforms; };

})
