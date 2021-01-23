{ stdenv, ocaml, findlib, dune, dune_2 }:

{ pname, version, buildInputs ? [], enableParallelBuilding ? true, ... }@args:

let Dune = if args.useDune2 or false then dune_2 else dune; in

if args ? minimumOCamlVersion &&
   ! stdenv.lib.versionAtLeast ocaml.version args.minimumOCamlVersion
then throw "${pname}-${version} is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation ({

  inherit enableParallelBuilding;

  buildPhase = ''
    runHook preBuild
    dune build -p ${pname} ''${enableParallelBuilding:+-j $NIX_BUILD_CORES}
    runHook postBuild
  '';
  checkPhase = ''
    runHook preCheck
    dune runtest -p ${pname} ''${enableParallelBuilding:+-j $NIX_BUILD_CORES}
    runHook postCheck
  '';
  installPhase = ''
    runHook preInstall
    dune install --prefix $out --libdir $OCAMLFIND_DESTDIR ${pname}
    runHook postInstall
  '';

} // args // {

  name = "ocaml${ocaml.version}-${pname}-${version}";

  buildInputs = [ ocaml Dune findlib ] ++ buildInputs;

  meta = (args.meta or {}) // { platforms = args.meta.platforms or ocaml.meta.platforms; };

})
