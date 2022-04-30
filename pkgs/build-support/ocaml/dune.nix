{ lib, stdenv, ocaml, findlib, dune_1, dune_2, dune_3 }:

{ pname, version, nativeBuildInputs ? [], enableParallelBuilding ? true, ... }@args:

let Dune =
  let dune-version = args . duneVersion or (if args.useDune2 or true then "2" else "1"); in
  { "1" = dune_1; "2" = dune_2; "3" = dune_3; }."${dune-version}"
; in

if (args ? minimumOCamlVersion && lib.versionOlder ocaml.version args.minimumOCamlVersion) ||
   (args ? minimalOCamlVersion && lib.versionOlder ocaml.version args.minimalOCamlVersion)
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

} // (builtins.removeAttrs args [ "minimalOCamlVersion" "duneVersion" ]) // {

  name = "ocaml${ocaml.version}-${pname}-${version}";

  nativeBuildInputs = [ ocaml Dune findlib ] ++ nativeBuildInputs;

  meta = (args.meta or {}) // { platforms = args.meta.platforms or ocaml.meta.platforms; };

})
