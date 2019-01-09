{ stdenv, fetchurl, ocaml, findlib, dune, opaline }:

{ pname, version, buildInputs ? [], ... }@args:

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

  buildInputs = [ ocaml dune findlib ] ++ buildInputs;

  meta = (args.meta or {}) // { platforms = args.meta.platforms or ocaml.meta.platforms; };

})
