{ lib, stdenv, ocaml_oasis, ocaml, findlib, ocamlbuild }:

{ pname, version, nativeBuildInputs ? [], meta ? { platforms = ocaml.meta.platforms or []; },
  createFindlibDestdir ? true,
  dontStrip ? true,
  ...
}@args:

lib.warnIf (args ? minimumOCamlVersion)
  "The `minimumOCamlVersion` argument is deprecated, use `minimalOCamlVersion` instead."

lib.throwIf ((args ? minimumOCamlVersion && lib.versionOlder ocaml.version args.minimumOCamlVersion) ||
             (args ? minimalOCamlVersion && lib.versionOlder ocaml.version args.minimalOCamlVersion))
  "${pname}-${version} is not available for OCaml ${ocaml.version}"

stdenv.mkDerivation (args // {
  name = "ocaml${ocaml.version}-${pname}-${version}";

  nativeBuildInputs = [ ocaml findlib ocamlbuild ocaml_oasis ] ++ nativeBuildInputs;

  inherit createFindlibDestdir;
  inherit dontStrip;

  strictDeps = true;

  buildPhase = ''
    runHook preBuild
    oasis setup
    ocaml setup.ml -configure --prefix $OCAMLFIND_DESTDIR --exec-prefix $out
    ocaml setup.ml -build
    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck
    ocaml setup.ml -test
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    ocaml setup.ml -install
    runHook postInstall
  '';

})
