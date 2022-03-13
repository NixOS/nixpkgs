{ lib, stdenv, ocaml, findlib, dune_1, dune_2 }:

{ pname, version, nativeBuildInputs ? [], enableParallelBuilding ? true, ... }@args:

let Dune = if args.useDune2 or true then dune_2 else dune_1; in

if (args ? minimumOCamlVersion && ! lib.versionAtLeast ocaml.version args.minimumOCamlVersion) ||
   (args ? minimalOCamlVersion && ! lib.versionAtLeast ocaml.version args.minimalOCamlVersion)
then throw "${pname}-${version} is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation ({

  inherit enableParallelBuilding;
  dontAddStaticConfigureFlags = true;
  configurePlatforms = [];

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

} // (builtins.removeAttrs args [ "minimalOCamlVersion" ]) // {

  name = "ocaml${ocaml.version}-${pname}-${version}";

  nativeBuildInputs = [ ocaml Dune findlib ] ++ nativeBuildInputs;

  meta = (args.meta or {}) // { platforms = args.meta.platforms or ocaml.meta.platforms; };

})
