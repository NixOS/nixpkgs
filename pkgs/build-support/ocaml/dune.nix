{ lib, stdenv, ocaml, findlib, dune_1, dune_2 }:

{ pname, version, nativeBuildInputs ? [], enableParallelBuilding ? true, useDune1 ? false, ... }@args:

let
  useDune1' =
    if useDune1 then true
    else if (args.useDune2 or false)  then
      lib.warnIf (args.useDune2) "useDune2 is now deprecated since dune 2 is the default, set useDune1 = true if you need dune 1, please update ${pname}" (!args.useDune2)
    else false;
  Dune = if useDune1' then dune_1 else dune_2; in

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
