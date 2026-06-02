{
  lib,
  stdenv,
  ocaml_oasis,
  ocaml,
  findlib,
  ocamlbuild,
}:

{
  pname,
  version,
  nativeBuildInputs ? [ ],
  meta ? {
    platforms = ocaml.meta.platforms or [ ];
  },
  minimumOCamlVersion ? null,
  createFindlibDestdir ? true,
  dontStrip ? true,
  ...
}@args:

stdenv.mkDerivation (
  args
  // {
    name = "ocaml${ocaml.version}-${pname}-${version}";

    nativeBuildInputs = [
      ocaml
      findlib
      ocamlbuild
      ocaml_oasis
    ]
    ++ nativeBuildInputs;

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

    meta = args.meta // {
      broken = args ? minimumOCamlVersion && lib.versionOlder ocaml.version args.minimumOCamlVersion;
    };
  }
)
